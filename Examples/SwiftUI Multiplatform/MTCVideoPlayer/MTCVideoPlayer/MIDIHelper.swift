//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKit
import SwiftUI

class MIDIHelper: ObservableObject {
    public weak var midiManager: MIDIManager?
    
    @Published private(set) var timecode: Timecode?
    @Published var localFrameRate: TimecodeFrameRate = .fps24
    
    let virtualInputName = "MTC Video Player"
    
    public init() { }
    
    /// Run once after setting the local ``midiManager`` property.
    public func initialSetup() {
        guard let midiManager else {
            print("MIDIManager is missing.")
            return
        }
    
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    
        do {
            print("Creating virtual MIDI input.")
            try midiManager.addInput(
                name: virtualInputName,
                tag: virtualInputName,
                uniqueID: .userDefaultsManaged(key: virtualInputName),
                receiver: .object(mtcReceiver, held: .weakly)
            )
        } catch {
            print("Error creating virtual MIDI input:", error.localizedDescription)
        }
        
        setupMTCReceiver()
    }
    
    // MARK: - MTC Receive
    
    let mtcReceiver = MTCReceiver(
        name: "MTC Receiver",
        initialLocalFrameRate: .fps24,
        syncPolicy: nil
    )
    
    private func setupMTCReceiver() {
        mtcReceiver
            .timecodeChangedHandler = { [weak self] timecode, event, direction, displayNeedsUpdate in
                guard displayNeedsUpdate else { return }
                self?.timecode = timecode
            }
        
        mtcReceiver.stateChangedHandler = { state in
            switch state {
            case .idle:
                break
            case .freewheeling:
                break
            case .incompatibleFrameRate:
                break
            case let .preSync(predictedLockTime, lockTimecode):
                break
            case .sync:
                break
            }
        }
    }
}
