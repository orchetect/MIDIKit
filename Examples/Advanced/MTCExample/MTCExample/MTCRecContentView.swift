//
//  MTCRecContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Combine
import MIDIKitIO
import MIDIKitSync
import OTCore
import SwiftUI
import TimecodeKit

struct MTCRecContentView: View {
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    
    // MARK: - MIDI state
    
    @State var mtcRec: MTCReceiver = .init(name: "dummy - will be set in .onAppear{} below")
    
    // MARK: - UI state
    
    @AppStorage("mtcRec-receiveFromSelfGen")
    var receiveFromSelfGen: Bool = true
    
    @State var receiverTC = "--:--:--:--"
    @State var receiverFR: MTCFrameRate? = nil
    @State var receiverState: MTCReceiver.State = .idle
    @State var localFrameRate: TimecodeFrameRate? = nil
    
    // MARK: - Internal State
    
    @State var scheduledLock: Cancellable? = nil
    @State private var lastSeconds = 0
    
    // MARK: - View
    
    var body: some View {
        mtcRecView
            .onAppear {
                setup()
            }
        
            .onChange(of: localFrameRate) { _ in
                if mtcRec.localFrameRate != localFrameRate {
                    logger.default(
                        "Setting MTC receiver's local frame rate to",
                        localFrameRate?.stringValue ?? "None"
                    )
                    mtcRec.localFrameRate = localFrameRate
                }
            }
        
            .onChange(of: receiveFromSelfGen) { newValue in
                updateSelfGenListen(state: newValue)
            }
    }
    
    private func setup() {
        // set up new MTC receiver and configure it
        mtcRec = MTCReceiver(
            name: "main",
            initialLocalFrameRate: .fps24,
            syncPolicy: .init(
                lockFrames: 16,
                dropOutFrames: 10
            )
        ) { timecode, _, _, displayNeedsUpdate in
            receiverTC = timecode.stringValue()
            receiverFR = mtcRec.mtcFrameRate
            
            guard displayNeedsUpdate else { return }
            
            if timecode.seconds != lastSeconds {
                playClickB()
                lastSeconds = timecode.seconds
            }
            
        } stateChanged: { state in
            receiverState = state
            logger.default("MTC Receiver state:", receiverState)
            
            scheduledLock?.cancel()
            scheduledLock = nil
            
            switch state {
            case .idle:
                break
                
            case let .preSync(lockTime, timecode):
                let scheduled = DispatchQueue.main.schedule(
                    after: DispatchQueue.SchedulerTimeType(lockTime),
                    interval: .seconds(1),
                    tolerance: .zero,
                    options: .init(
                        qos: .userInitiated,
                        flags: [],
                        group: nil
                    )
                ) {
                    logger.default(">>> LOCAL SYNC: PLAYBACK START @", timecode)
                    scheduledLock?.cancel()
                    scheduledLock = nil
                }
                
                scheduledLock = scheduled
                
            case .sync:
                break
                
            case .freewheeling:
                break
                
            case .incompatibleFrameRate:
                break
            }
        }
        
        // create MTC reader MIDI endpoint
        do {
            let udKey = "\(kMIDIPorts.MTCRec.tag) - Unique ID"
            
            try midiManager.addInput(
                name: kMIDIPorts.MTCRec.name,
                tag: kMIDIPorts.MTCRec.tag,
                uniqueID: .userDefaultsManaged(key: udKey),
                receiver: .weak(mtcRec)
            )
        } catch {
            logger.error(error)
        }
        
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
        .background(receiverState.stateColor)
    }
    
    private var options: some View {
        Toggle(isOn: $receiveFromSelfGen) {
            Text("Receive from MTC Generator Window")
        }
    }
    
    private var timecodeDisplay: some View {
        Text(receiverTC)
            .font(.system(size: 48, weight: .regular, design: .monospaced))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var mtcEncodedRateInfo: some View {
        Group {
            if receiverState != .idle {
                Text("MTC encoded rate: " + (receiverFR?.stringValue ?? "--") + " fps")
            } else {
                Text(" ")
            }
        }
        .font(.system(size: 24, weight: .regular, design: .default))
    }
    
    @ViewBuilder
    private var derivedFrameRatesInfo: some View {
        if receiverState != .idle,
           let receiverFR
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
            if receiverState != .idle,
               localFrameRate != nil
            {
                if receiverState == .incompatibleFrameRate {
                    Text("Can't scale frame rate because rates are incompatible.")
                } else if receiverFR?.directEquivalentFrameRate == localFrameRate {
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
        Text(receiverState.description)
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
                                    width: $0 == receiverFR?.directEquivalentFrameRate ? 2 : 0
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
