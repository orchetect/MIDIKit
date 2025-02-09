//
//  MTCRecHost.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import MIDIKitIO
import MIDIKitSync
import SwiftUI

@Observable @MainActor class MTCRecHost {
    @ObservationIgnored
    var mtcRec: MTCReceiver?
    
    // MARK: - State
    
    private(set) var receiverTC = "--:--:--:--"
    private(set) var receiverFR: MTCFrameRate?
    private(set) var receiverState: MTCReceiver.State = .idle
    
    // MARK: - Internal State
    
    @ObservationIgnored
    private var scheduledLock: Cancellable? = nil
    private var lastSeconds = 0
    
    init() {
        let rec = receiverFactory()
        mtcRec = rec
        
        rec.setTimecodeChangedHandler { [weak self] timecode, event, direction, isFrameChanged in
            Task { @MainActor [weak self] in
                guard let self else { return }
                
                self.receiverTC = timecode.stringValue()
                self.receiverFR = self.mtcRec?.mtcFrameRate
                
                // don't update UI if only subframes have changed
                guard isFrameChanged else { return }
                
                // play a sound when seconds value changes - rudimentary, but works for our needs
                if timecode.seconds != self.lastSeconds {
                    playClickB()
                    self.lastSeconds = timecode.seconds
                }
            }
        }
        
        rec.setStateChangedHandler { [weak self] state in
            Task { @MainActor [weak self] in
                guard let self else { return }
                
                self.receiverState = state
                logger.log("MTC Receiver state: \(self.receiverState)")
                
                self.scheduledLock?.cancel()
                self.scheduledLock = nil
                
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
                    
                    self.scheduledLock = scheduled
                    
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
