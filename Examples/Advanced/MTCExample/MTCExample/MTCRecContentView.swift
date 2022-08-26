//
//  MTCRecContentView.swift
//  MIDIKitSync • https://github.com/orchetect/MIDIKitSync
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Combine
import SwiftUI
import MIDIKitIO
import MIDIKitSync
import TimecodeKit
import OTCore

struct MTCRecContentView: View {
    weak var midiManager: MIDIManager?
    
    init(midiManager: MIDIManager?) {
        // normally in SwiftUI we would pass midiManager in as an EnvironmentObject
        // but that only works on macOS 11.0+ and for sake of backwards compatibility
        // we will do it old-school weak delegate storage pattern
        self.midiManager = midiManager
    }
    
    // MARK: - MIDI state
    
    @State var mtcRec: MTCReceiver = .init(name: "dummy - will be set in .onAppear{} below")
    
    // MARK: - UI state
    
    @State var receiverTC = "--:--:--:--"
    
    @State var receiverFR: MTCFrameRate? = nil
    
    @State var receiverState: MTCReceiver.State = .idle {
        // Note: be aware didSet will trigger here on a @State var when the variable is imperatively set in code, but not when altered by a $receiverState binding in SwiftUI
        didSet {
            logger.default("MTC Receiver state:", receiverState)
        }
    }
    
    @State var localFrameRate: Timecode.FrameRate? = nil
    
    // MARK: - Internal State
    
    @State var scheduledLock: Cancellable? = nil
    
    @State private var lastSeconds = 0
    
    // MARK: - View
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
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
                    .tag(Timecode.FrameRate?.none)
                
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 3)
                
                ForEach(Timecode.FrameRate.allCases) { fRate in
                    Text(fRate.stringValue)
                        .tag(Timecode.FrameRate?.some(fRate))
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
                let udKey = "\(kMIDISources.MTCRec.tag) - Unique ID"
                
                try midiManager?.addInput(
                    name: kMIDISources.MTCRec.name,
                    tag: kMIDISources.MTCRec.tag,
                    uniqueID: .userDefaultsManaged(key: udKey),
                    receiver: .events { [weak mtcRec] midiEvents in
                        mtcRec?.midiIn(events: midiEvents)
                    }
                )
            } catch {
                logger.error(error)
            }
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
    }
}

extension MTCReceiver.State {
    var stateColor: Color {
        switch self {
        case .idle: return Color.clear
        case .preSync: return Color.orange
        case .sync: return Color.green
        case .freewheeling: return Color.purple
        case .incompatibleFrameRate: return Color.red
        }
    }
}

struct mtcRecContentView_Previews: PreviewProvider {
    static var previews: some View {
        MTCRecContentView(midiManager: nil)
    }
}
