//
//  MTCRecContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Combine
import SwiftUI
import MIDIKitIO
import MIDIKitSync
import TimecodeKit
import OTCore

struct MTCRecContentView: View {
    @EnvironmentObject private var midiManager: MIDIManager
    
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
                // set up new MTC receiver and configure it
                mtcRec = MTCReceiver(
                    name: "main",
                    initialLocalFrameRate: ._24,
                    syncPolicy: .init(
                        lockFrames: 16,
                        dropOutFrames: 10
                    )
                ) { timecode, _, _, displayNeedsUpdate in
                    receiverTC = timecode.stringValue
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
                        receiver: .object(mtcRec, held: .weakly)
                    )
                } catch {
                    logger.error(error)
                }
            
                updateSelfGenListen(state: receiveFromSelfGen)
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
    
    private var mtcRecView: some View {
        VStack(alignment: .center, spacing: 0) {
            Toggle(isOn: $receiveFromSelfGen) {
                Text("Receive from MTC Generator Window")
            }
            .padding(.top, 10)
            
            Text(receiverTC)
                .font(.system(size: 48, weight: .regular, design: .monospaced))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Group {
                if receiverState != .idle {
                    Text("MTC encoded rate: " + (receiverFR?.stringValue ?? "--") + " fps")
                    
                } else {
                    Text(" ")
                }
            }
            .font(.system(size: 24, weight: .regular, design: .default))
            
            if receiverState != .idle,
               let receiverFR = receiverFR
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
            
            Text(receiverState.description)
                .font(.system(size: 48, weight: .regular, design: .monospaced))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
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
                                        width: $0 == receiverFR?.directEquivalentFrameRate
                                            ? 2
                                            : 0
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
            .padding(.bottom, 10)
        }
        .background(receiverState.stateColor)
    }
    
    private func updateSelfGenListen(state: Bool) {
        let tag = kMIDIPorts.MTCGenConnection.tag
        switch state {
        case true:
            try? midiManager.addInputConnection(
                toOutputs: [.name(kMIDIPorts.MTCGen.name)],
                tag: tag,
                receiver: .object(mtcRec, held: .weakly)
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

struct MTCRecContentView_Previews: PreviewProvider {
    private static let midiManager = MIDIManager(clientName: "Preview", model: "", manufacturer: "")
    
    static var previews: some View {
        MTCRecContentView()
            .environmentObject(midiManager)
    }
}
