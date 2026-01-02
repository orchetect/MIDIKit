//
//  HUIHostView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Controls
import MIDIKitControlSurfaces
import MIDIKitIO
import SwiftUI

struct HUIHostView: View {
    @Environment(MIDIHelper.self) private var midiHelper
    
    @State private var huiHostHelper: HUIHostHelper = HUIHostHelper()
    
    /// Convenience accessor for first HUI bank.
    private var huiBank0: HUIHostBank? {
        get async { await huiHostHelper.huiHost.banks.first }
    }
    
    @State private var vPotDisplayFormat: VPotDisplayFormat = .single
    
    init() { }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text(
                """
                This window acts as a HUI host (ie: a DAW) and connects to the HUI surface.
                
                To test the HUI surface with an actual DAW instead (Pro Tools, Logic, Cubase, etc.), close this window. The HUI Surface window can be used as a standalone HUI device.
                """
            )
            
            surfaceStatus
            
            hostBody
            
            HStack {
                Toggle("Log Events", isOn: $huiHostHelper.logEvents)
                Spacer()
                Toggle("Log Pings", isOn: $huiHostHelper.logPing)
            }
            .controlSize(.small)
        }
        .multilineTextAlignment(.center)
        .toggleStyle(.switch)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task {
            await huiHostHelper.setup(midiManager: midiHelper.midiManager)
            await huiHostHelper.startConnections()
        }
        .onDisappear { huiHostHelper.stopConnections() }
    }
    
    var surfaceStatus: some View {
        HStack {
            Circle()
                .fill(huiHostHelper.isRemotePresent ? .green : .red)
                .frame(width: 15, height: 15)
            Text("Surface")
        }
    }
    
    var hostBody: some View {
        GroupBox("Channel Strip 1") {
            VStack {
                Button("Send Random Meter Level") {
                    Task { await transmitRandomMeterLevel() }
                }
                
                GroupBox("V-Pot") {
                    Picker("Style", selection: $vPotDisplayFormat) {
                        Text("Off").tag(VPotDisplayFormat.allOff)
                        Text("Position").tag(VPotDisplayFormat.single)
                        Text("Left Anchor (Send Level)").tag(VPotDisplayFormat.leftTo)
                        Text("Center Anchor (Pan)").tag(VPotDisplayFormat.centerTo)
                        Text("Center Radius (Width)").tag(VPotDisplayFormat.centerRadius)
                    }
                    .pickerStyle(.menu)
                    .onChange(of: vPotDisplayFormat) { _, _ in
                        Task { await transmitVPot() }
                    }
                    
                    HStack {
                        if vPotDisplayFormat != .allOff {
                            Ribbon(position: $huiHostHelper.model.bank0.channel0.pan)
                                .foregroundColor(.secondary)
                                .backgroundColor(Color(nsColor: .controlBackgroundColor))
                                .indicatorWidth(15)
                                .frame(height: 20)
                                .onChange(
                                    of: huiHostHelper.model.bank0.channel0.pan
                                ) { oldValue, newValue in
                                    Task { await transmitVPot(value: newValue) }
                                }
                        }
                        Toggle("Low", isOn: $huiHostHelper.model.bank0.channel0.vPotLowerLED)
                            .onChange(
                                of: huiHostHelper.model.bank0.channel0.vPotLowerLED
                            ) { oldValue, newValue in
                                Task { await transmitVPot(lowerLED: newValue) }
                            }
                    }
                }
                
                Toggle("Solo", isOn: $huiHostHelper.model.bank0.channel0.solo)
                    .onChange(of: huiHostHelper.model.bank0.channel0.solo) { oldValue, newValue in
                        Task { await transmitSolo(state: newValue) }
                    }
                
                Toggle("Mute", isOn: $huiHostHelper.model.bank0.channel0.mute)
                    .onChange(of: huiHostHelper.model.bank0.channel0.mute) { oldValue, newValue in
                        Task { await transmitMute(state: newValue) }
                    }
                
                GroupBox("4-Character LCD") {
                    LiveFormattedTextField(
                        value: $huiHostHelper.model.bank0.channel0.name,
                        formatter: MaxLengthFormatter(maxCharLength: 4)
                    )
                    .frame(width: 100)
                    .onChange(of: huiHostHelper.model.bank0.channel0.name) { oldValue, newValue in
                        Task { await transmitSmallDisplay(text: newValue) }
                    }
                }
                
                Toggle("Selected", isOn: $huiHostHelper.model.bank0.channel0.selected)
                    .onChange(of: huiHostHelper.model.bank0.channel0.selected) { oldValue, newValue in
                        Task { await transmitSelected(state: newValue) }
                    }
                
                GroupBox("Fader") {
                    Ribbon(position: $huiHostHelper.model.bank0.channel0.faderLevel)
                        .foregroundColor(
                            huiHostHelper.model.bank0.channel0.faderTouched
                                ? .green
                                : .secondary
                        )
                        .backgroundColor(Color(nsColor: .controlBackgroundColor))
                        .indicatorWidth(15)
                        .frame(height: 20)
                        .disabled(huiHostHelper.model.bank0.channel0.faderTouched)
                        .onChange(
                            of: huiHostHelper.model.bank0.channel0.faderLevel
                        ) { oldValue, newValue in
                            Task { await transmitFader(level: newValue) }
                        }
                }
            }
            .toggleStyle(.switch)
            .controlSize(.small)
            .frame(width: 250, height: 300)
        }
    }
    
    func ledState(_ value: Float) -> HUIVPotDisplay.LEDState {
        switch vPotDisplayFormat {
        case .allOff: .allOff
        case .single: .single(unitInterval: Double(value))
        case .leftTo: .left(toUnitInterval: Double(value))
        case .centerTo: .center(toUnitInterval: Double(value))
        case .centerRadius: .centerRadius(unitInterval: Double(value))
        }
    }
}

// MARK: - ViewModel

extension HUIHostView {
    private func transmitRandomMeterLevel() async {
        await huiBank0?.transmitLevelMeter(
            channel: 0,
            side: .left,
            level: HUISurfaceModelState.StereoLevelMeterSide.levelRange.randomElement()!
        )
        await huiBank0?.transmitLevelMeter(
            channel: 0,
            side: .right,
            level: HUISurfaceModelState.StereoLevelMeterSide.levelRange.randomElement()!
        )
    }
    
    private func transmitSolo(state: Bool) async {
        await huiBank0?.transmitSwitch(.channelStrip(0, .solo), state: state)
    }
    
    private func transmitMute(state: Bool) async {
        await huiBank0?.transmitSwitch(.channelStrip(0, .mute), state: state)
    }
    
    private func transmitSelected(state: Bool) async {
        await huiBank0?.transmitSwitch(.channelStrip(0, .select), state: state)
    }
    
    private func transmitVPot(value: Float? = nil, lowerLED: Bool? = nil) async {
        await huiBank0?.transmitVPot(
            .channel(0),
            display: .init(
                leds: ledState(value ?? huiHostHelper.model.bank0.channel0.pan),
                lowerLED: lowerLED ?? huiHostHelper.model.bank0.channel0.vPotLowerLED
            )
        )
    }
    
    private func transmitSmallDisplay(text: String) async {
        await huiBank0?.transmitSmallDisplay(.channel(0), text: .init(lossy: text))
    }
    
    private func transmitFader(level: Float) async {
        let scaledLevel = UInt14(level * Float(UInt14.max))
        await huiBank0?.transmitFader(level: scaledLevel, channel: 0)
    }
}

// MARK: - Types

extension HUIHostView {
    private enum VPotDisplayFormat: Equatable, Hashable, CaseIterable {
        case allOff
        case single
        case leftTo
        case centerTo
        case centerRadius
    }
}
