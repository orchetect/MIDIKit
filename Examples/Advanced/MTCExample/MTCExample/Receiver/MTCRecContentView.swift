//
//  MTCRecContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import MIDIKitIO
import MIDIKitSync
import SwiftUI
import SwiftTimecodeCore

struct MTCRecContentView: View {
    @Environment(MIDIHelper.self) private var midiHelper
    @State private var mtcReceiverHelper = MTCReceiverHelper()
    
    // MARK: - Prefs
    
    @AppStorage("mtcRec-receiveFromSelfGen")
    var receiveFromSelfGen: Bool = true
    
    // Note: @AppStorage doesn't work with an optional value
    //
    // @AppStorage("mtcRec-localFrameRate")
    // var localFrameRate: TimecodeFrameRate? = nil
    
    // MARK: - UI state
    
    @State var localFrameRate: TimecodeFrameRate? = nil
    
    // MARK: - View
    
    var body: some View {
        mtcRecView
            .task {
                await setup()
            }
            .onChange(of: localFrameRate) { oldValue, newValue in
                Task { await updateLocalFrameRate(to: newValue) }
            }
            .onChange(of: receiveFromSelfGen) { oldValue, newValue in
                Task { await mtcReceiverHelper.updateSelfGenListenConnection(state: newValue) }
            }
    }
    
    private func setup() async {
        await mtcReceiverHelper.bootstrap(midiManager: midiHelper.midiManager)
        await mtcReceiverHelper.updateSelfGenListenConnection(state: receiveFromSelfGen)
    }
    
    private func updateLocalFrameRate(to newValue: TimecodeFrameRate?) async {
        if await mtcReceiverHelper.localFrameRate != newValue {
            logger.log(
                "Setting MTC receiver's local frame rate to \(newValue?.stringValue ?? "None")"
            )
            mtcReceiverHelper.setLocalFrameRate(newValue)
        }
    }
    
    private var mtcRecView: some View {
        VStack(alignment: .center, spacing: 0) {
            options
                .padding(.top, 10)
            
            timecodeDisplay
            
            mtcEncodedRateInfo
            
            derivedFrameRatesInfo
            
            scalingInfo
            
            receiverStateDisplay
            
            localFrameRatePicker
            
            frameRateInfo
                .padding(.bottom, 10)
        }
        .background(mtcReceiverHelper.receiverState.stateColor)
    }
    
    private var options: some View {
        Toggle(isOn: $receiveFromSelfGen) {
            Text("Receive from MTC Generator Window")
        }
    }
    
    private var timecodeDisplay: some View {
        Text(mtcReceiverHelper.receiverTC)
            .font(.system(size: 48, weight: .regular, design: .monospaced))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var mtcEncodedRateInfo: some View {
        Group {
            if mtcReceiverHelper.receiverState != .idle {
                Text("MTC encoded rate: " + (mtcReceiverHelper.receiverFR?.stringValue ?? "--") + " fps")
            } else {
                Text(" ")
            }
        }
        .font(.system(size: 24, weight: .regular, design: .default))
    }
    
    @ViewBuilder
    private var derivedFrameRatesInfo: some View {
        if mtcReceiverHelper.receiverState != .idle,
           let receiverFR = mtcReceiverHelper.receiverFR
        {
            VStack {
                Text("Derived frame rates of \(receiverFR.stringValue):")
                
                HStack {
                    ForEach(receiverFR.derivedFrameRates, id: \.self) {
                        Text($0.stringValue)
                            .foregroundColor($0 == localFrameRate ? .blue : nil)
                            .padding(2)
                            .border(
                                Color.white,
                                width: $0 == receiverFR.directEquivalentFrameRate ? 2 : 0
                            )
                    }
                }
            }
        } else {
            VStack {
                Text(" ")
                Text(" ")
                    .padding(2)
            }
        }
    }
    
    private var scalingInfo: some View {
        Group {
            if mtcReceiverHelper.receiverState != .idle,
               localFrameRate != nil
            {
                if mtcReceiverHelper.receiverState == .incompatibleFrameRate {
                    Text("Can't scale frame rate because rates are incompatible.")
                } else if mtcReceiverHelper.receiverFR?.directEquivalentFrameRate == localFrameRate {
                    Text("Scaling not needed, rates are identical.")
                } else {
                    Text(
                        "Scaled to local rate: " + (localFrameRate?.stringValue ?? "--") +
                            " fps"
                    )
                }
                
            } else {
                Text(" ")
            }
        }
        .font(.system(size: 24, weight: .regular, design: .default))
    }
    
    private var receiverStateDisplay: some View {
        Text(mtcReceiverHelper.receiverState.description)
            .font(.system(size: 48, weight: .regular, design: .monospaced))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var localFrameRatePicker: some View {
        Picker(selection: $localFrameRate, label: Text("Local Frame Rate")) {
            Text("None")
                .tag(TimecodeFrameRate?.none)
            
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 3)
            
            ForEach(TimecodeFrameRate.allCases) { fRate in
                Text(fRate.stringValue)
                    .tag(TimecodeFrameRate?.some(fRate))
            }
        }
        .frame(width: 250)
    }
    
    private var frameRateInfo: some View {
        HStack {
            if let localFrameRate {
                VStack {
                    Text(
                        "Compatible remote frame rates (\(localFrameRate.compatibleGroup.stringValue)):"
                    )
                    
                    HStack {
                        ForEach(localFrameRate.compatibleGroupRates, id: \.self) {
                            Text($0.stringValue)
                                .foregroundColor($0 == localFrameRate ? .blue : nil)
                                .padding(2)
                                .border(
                                    Color.white,
                                    width: $0 == mtcReceiverHelper.receiverFR?.directEquivalentFrameRate ? 2 : 0
                                )
                        }
                    }
                }
            } else {
                VStack {
                    Text(" ")
                    Text(" ")
                        .padding(2)
                }
            }
        }
    }
}

extension MTCReceiver.State {
    var stateColor: Color {
        switch self {
        case .idle: .clear
        case .preSync: .orange
        case .sync: .green
        case .freewheeling: .purple
        case .incompatibleFrameRate: .red
        }
    }
}

#Preview {
    @Previewable @State var midiHelper = MIDIHelper(start: true)
    
    MTCRecContentView()
        .environment(midiHelper)
}
