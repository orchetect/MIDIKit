//
//  HUIHostView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitIO
import MIDIKitControlSurfaces
import Controls

struct HUIHostView: View {
    weak var midiManager: MIDIManager?
    
    @ObservedObject var huiHostHelper: HUIHostHelper
    
    /// Convenience accessor for first HUI bank.
    private var huiBank0: HUIHostBank? { huiHostHelper.huiHost.banks.first }
    
    init(midiManager: MIDIManager?) {
        self.midiManager = midiManager
        
        // set up HUI Host object
        huiHostHelper = HUIHostHelper(midiManager: midiManager)
    }
    
    @State private var vPotDisplayFormat: VPotDisplayFormat = .single
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("This window acts as a HUI host (ie: a DAW) and connects to the HUI surface.")
            Text(
                "To test the HUI surface with an actual DAW instead (Pro Tools, Logic, Cubase, etc.), close this window. The HUI Surface window can be used as a standalone HUI device."
            )
            
            HStack {
                Circle()
                    .fill(huiHostHelper.isRemotePresent ? .green : .red)
                    .frame(width: 15, height: 15)
                Text("Surface")
            }
            
            GroupBox(label: Text("Channel Strip 1")) {
                VStack {
                    GroupBox(label: Text("V-Pot")) {
                        Picker("Style", selection: $vPotDisplayFormat) {
                            Text("Off").tag(VPotDisplayFormat.allOff)
                            Text("Position").tag(VPotDisplayFormat.single)
                            Text("Left Anchor (Send Level)").tag(VPotDisplayFormat.leftTo)
                            Text("Center Anchor (Pan)").tag(VPotDisplayFormat.centerTo)
                            Text("Center Radius (Width)").tag(VPotDisplayFormat.centerRadius)
                        }
                        .pickerStyle(.menu)
                        .onChange(of: vPotDisplayFormat) { _ in
                            transmitVPot()
                        }
                        HStack {
                            if vPotDisplayFormat != .allOff {
                                Ribbon(position: $huiHostHelper.model.bank0.channel0.pan)
                                    .foregroundColor(.secondary)
                                    .backgroundColor(Color(nsColor: .controlBackgroundColor))
                                    .indicatorWidth(15)
                                    .frame(height: 20)
                                    .onChange(of: huiHostHelper.model.bank0.channel0.pan) { newValue in
                                        transmitVPot(value: newValue)
                                    }
                            }
                            Toggle("Low", isOn: $huiHostHelper.model.bank0.channel0.vPotLowerLED)
                                .onChange(of: huiHostHelper.model.bank0.channel0.vPotLowerLED) { newValue in
                                    transmitVPot(lowerLED: newValue)
                                }
                        }
                    }
                    Toggle("Solo", isOn: $huiHostHelper.model.bank0.channel0.solo)
                        .onChange(of: huiHostHelper.model.bank0.channel0.solo) { newValue in
                            huiBank0?.transmitSwitch(.channelStrip(0, .solo), state: newValue)
                        }
                    Toggle("Mute", isOn: $huiHostHelper.model.bank0.channel0.mute)
                        .onChange(of: huiHostHelper.model.bank0.channel0.mute) { newValue in
                            huiBank0?.transmitSwitch(.channelStrip(0, .mute), state: newValue)
                        }
                    GroupBox(label: Text("4-Character LCD")) {
                        LiveFormattedTextField(
                            value: $huiHostHelper.model.bank0.channel0.name,
                            formatter: ChanTextFormatter()
                        )
                        .frame(width: 100)
                        .onChange(of: huiHostHelper.model.bank0.channel0.name) { newValue in
                            huiBank0?.transmitSmallDisplay(
                                .channel(0),
                                text: .init(lossy: newValue)
                            )
                        }
                    }
                    Toggle("Selected", isOn: $huiHostHelper.model.bank0.channel0.selected)
                        .onChange(of: huiHostHelper.model.bank0.channel0.selected) { newValue in
                            huiBank0?.transmitSwitch(.channelStrip(0, .select), state: newValue)
                        }
                    GroupBox(label: Text("Fader")) {
                        Ribbon(position: $huiHostHelper.model.bank0.channel0.faderLevel)
                            .foregroundColor(huiHostHelper.model.bank0.channel0.faderTouched ? .green : .secondary)
                            .backgroundColor(Color(nsColor: .controlBackgroundColor))
                            .indicatorWidth(15)
                            .frame(height: 20)
                            .onChange(of: huiHostHelper.model.bank0.channel0.faderLevel) { newValue in
                                let scaledLevel = UInt14(newValue * Float(UInt14.max))
                                huiBank0?.transmitFader(level: scaledLevel, channel: 0)
                            }
                            .disabled(huiHostHelper.model.bank0.channel0.faderTouched)
                    }
                }
                .frame(width: 250, height: 260)
            }
            
            Toggle("Log Pings", isOn: $huiHostHelper.logPing)
        }
        .multilineTextAlignment(.center)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func ledState(_ value: Float) -> HUIVPotDisplay.LEDState {
        switch vPotDisplayFormat {
        case .allOff:
            return .allOff
        case .single:
            return .single(unitInterval: Double(value))
        case .leftTo:
            return .left(toUnitInterval: Double(value))
        case .centerTo:
            return .center(toUnitInterval: Double(value))
        case .centerRadius:
            return .centerRadius(unitInterval: Double(value))
        }
    }
    
    func transmitVPot(value: Float? = nil, lowerLED: Bool? = nil) {
        huiBank0?.transmitVPot(
            .channel(0),
            display: .init(
                leds: ledState(value ?? huiHostHelper.model.bank0.channel0.pan),
                lowerLED: lowerLED ?? huiHostHelper.model.bank0.channel0.vPotLowerLED
            )
        )
    }
}

private enum VPotDisplayFormat: Equatable, Hashable, CaseIterable {
    case allOff
    case single
    case leftTo
    case centerTo
    case centerRadius
}

private class ChanTextFormatter: Formatter {
    override func string(for obj: Any?) -> String? {
        guard let obj = obj as? String else { return nil }
        
        return String(obj.prefix(4))
    }
    
    override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        obj?.pointee = string as NSString
        return true
    }
    
    override func isPartialStringValid(
        _ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>,
        proposedSelectedRange proposedSelRangePtr: NSRangePointer?,
        originalString origString: String,
        originalSelectedRange origSelRange: NSRange,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        let partialString = partialStringPtr.pointee as String
        return partialString.count <= 4
    }
    
    override func isPartialStringValid(
        _ partialString: String,
        newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        partialString.count <= 4
    }
}

/// Hacky workaround to make a live-formatted SwiftUI TextField possible.
struct LiveFormattedTextField: View {
    var titleKey: LocalizedStringKey
    @Binding var value: String
    let formatter: Formatter
    
    @State private var liveText: String
    
    init(
        _ titleKey: LocalizedStringKey = "",
        value: Binding<String>,
        formatter: Formatter
    ) {
        self.titleKey = titleKey
        _value = value
        self.formatter = formatter
        _liveText = State(wrappedValue: value.wrappedValue)
    }
    
    var body: some View {
        TextField(titleKey, text: $liveText)
            .onChange(of: liveText) { newValue in
                let formatted = formatter.string(for: newValue) ?? ""
                liveText = formatted
                value = formatted
            }
    }
}
