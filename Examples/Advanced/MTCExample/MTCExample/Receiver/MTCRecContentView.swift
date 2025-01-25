//
//  MTCRecContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import MIDIKitIO
import MIDIKitSync
import SwiftUI
import TimecodeKitCore

struct MTCRecContentView: View {
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    @State private var mtcRecHost = MTCRecHost()
    
    // MARK: - Prefs
    
    @AppStorage("mtcRec-receiveFromSelfGen")
    var receiveFromSelfGen: Bool = true
    
    // MARK: - UI state
    
    @State var localFrameRate: TimecodeFrameRate? = nil
    
    // MARK: - View
    
    var body: some View {
        mtcRecView
            .task {
                await setup()
            }
            .onChange(of: localFrameRate) { oldValue, newValue in
                Task {
                    if await mtcRecHost.mtcRec?.localFrameRate != newValue {
                        logger.log(
                            "Setting MTC receiver's local frame rate to \(newValue?.stringValue ?? "None")"
                        )
                        await mtcRecHost.mtcRec?.setLocalFrameRate(newValue)
                    }
                }
            }
            .onChange(of: receiveFromSelfGen) { oldValue, newValue in
                updateSelfGenListen(state: newValue)
            }
    }
    
    private func setup() async {
        mtcRecHost.addPort(to: midiManager)
        updateSelfGenListen(state: receiveFromSelfGen)
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
        .background(mtcRecHost.receiverState.stateColor)
    }
    
    private var options: some View {
        Toggle(isOn: $receiveFromSelfGen) {
            Text("Receive from MTC Generator Window")
        }
    }
    
    private var timecodeDisplay: some View {
        Text(mtcRecHost.receiverTC)
            .font(.system(size: 48, weight: .regular, design: .monospaced))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var mtcEncodedRateInfo: some View {
        Group {
            if mtcRecHost.receiverState != .idle {
                Text("MTC encoded rate: " + (mtcRecHost.receiverFR?.stringValue ?? "--") + " fps")
            } else {
                Text(" ")
            }
        }
        .font(.system(size: 24, weight: .regular, design: .default))
    }
    
    @ViewBuilder
    private var derivedFrameRatesInfo: some View {
        if mtcRecHost.receiverState != .idle,
           let receiverFR = mtcRecHost.receiverFR
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
            if mtcRecHost.receiverState != .idle,
               localFrameRate != nil
            {
                if mtcRecHost.receiverState == .incompatibleFrameRate {
                    Text("Can't scale frame rate because rates are incompatible.")
                } else if mtcRecHost.receiverFR?.directEquivalentFrameRate == localFrameRate {
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
        Text(mtcRecHost.receiverState.description)
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
            if let unwrappedLocalFrameRate = localFrameRate {
                VStack {
                    Text(
                        "Compatible remote frame rates (\(unwrappedLocalFrameRate.compatibleGroup.stringValue)):"
                    )
                    
                    HStack {
                        ForEach(unwrappedLocalFrameRate.compatibleGroupRates, id: \.self) {
                            Text($0.stringValue)
                                .foregroundColor($0 == unwrappedLocalFrameRate ? .blue : nil)
                                .padding(2)
                                .border(
                                    Color.white,
                                    width: $0 == mtcRecHost.receiverFR?.directEquivalentFrameRate ? 2 : 0
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
    
    private func updateSelfGenListen(state: Bool) {
        guard let mtcRec = mtcRecHost.mtcRec else { fatalError() }
        
        let tag = kMIDIPorts.MTCGenConnection.tag
        switch state {
        case true:
            try? midiManager.addInputConnection(
                to: .outputs(matching: [.name(kMIDIPorts.MTCGen.name)]),
                tag: tag,
                receiver: .weak(mtcRec)
            )
        case false:
            midiManager.remove(.inputConnection, .withTag(tag))
        }
    }
}

extension MTCReceiver.State {
    var stateColor: Color {
        switch self {
        case .idle: return .clear
        case .preSync: return .orange
        case .sync: return .green
        case .freewheeling: return .purple
        case .incompatibleFrameRate: return .red
        }
    }
}

struct MTCRecContentViewPreviews: PreviewProvider {
    private static let midiManager = ObservableMIDIManager(
        clientName: "Preview",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    static var previews: some View {
        MTCRecContentView()
            .environmentObject(midiManager)
    }
}
