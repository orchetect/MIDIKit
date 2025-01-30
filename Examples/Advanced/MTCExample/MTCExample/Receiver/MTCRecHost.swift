//
//  MTCRecHost.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import MIDIKitIO
import MIDIKitSync
import SwiftUI

@Observable class MTCRecHost {
    @ObservationIgnored
    var mtcRec: MTCReceiver?
    
    // MARK: - State
    
    private(set) var receiverTC = "--:--:--:--"
    private(set) var receiverFR: MTCFrameRate? = nil
    private(set) var receiverState: MTCReceiver.State = .idle
    
    // MARK: - Internal State
    
    @ObservationIgnored
    private var scheduledLock: Cancellable? = nil
    private var lastSeconds = 0
    
    init() {
        let rec = receiverFactory()
        mtcRec = rec
        
        rec.setTimecodeChangedHandler { timecode, event, direction, displayNeedsUpdate in
            Task { @MainActor [weak self] in
                guard let self else { return }
                
                receiverTC = timecode.stringValue()
                receiverFR = mtcRec?.mtcFrameRate
                
                guard displayNeedsUpdate else { return }
                
                if timecode.seconds != lastSeconds {
                    playClickB()
                    lastSeconds = timecode.seconds
                }
            }
        }
        
        rec.setStateChangedHandler { state in
            Task { @MainActor [weak self] in
                guard let self else { return }
                
                receiverState = state
                logger.log("MTC Receiver state: \(receiverState)")
                
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
                        options: DispatchQueue.SchedulerOptions(
                            qos: .userInitiated,
                            flags: [],
                            group: nil
                        )
                    ) { [weak self] in
                        logger.log(">>> LOCAL SYNC: PLAYBACK START @\(timecode)")
                        self?.scheduledLock?.cancel()
                        self?.scheduledLock = nil
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
        }
    }
    
    private func receiverFactory() -> MTCReceiver {
        MTCReceiver(
            name: "main",
            initialLocalFrameRate: .fps24,
            syncPolicy: MTCReceiver.SyncPolicy(
                lockFrames: 16,
                dropOutFrames: 10
            )
        )
    }
    
    func addPort(to midiManager: ObservableMIDIManager) {
        guard let mtcRec else { fatalError() }
        
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
            logger.error("\(error.localizedDescription)")
        }
    }
}
