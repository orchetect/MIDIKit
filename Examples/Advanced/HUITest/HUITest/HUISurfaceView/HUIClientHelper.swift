//
//  HUIClientHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitControlSurfaces
import MIDIKitInternals // only for utils
import MIDIKitIO

@Observable final class HUIClientHelper: Sendable {
    @ObservationIgnored nonisolated(unsafe) weak var midiManager: ObservableMIDIManager? = nil
    @MainActor var huiSurface: HUISurface = HUISurface()
    
    init() { }
    
    deinit {
        stopVirtualPorts()
    }
}

// MARK: - Lifecycle

extension HUIClientHelper {
    func setup(midiManager: ObservableMIDIManager?) async {
        guard let midiManager else { return }
        
        self.midiManager = midiManager
        await setupHUISurface()
    }
}

// MARK: - Static

extension HUIClientHelper {
    nonisolated static let kHUIInputName = "MIDIKit HUI Input"
    nonisolated static let kHUIOutputName = "MIDIKit HUI Output"
}

// MARK: - Lifecycle

extension HUIClientHelper {
    private func setupHUISurface() async {
        // set up HUI Surface object
        
        await huiSurface.modelNotificationHandler = { notification in
            // logger.debug(notification)
        }
        
        await huiSurface.midiOutHandler = { [weak midiManager] midiEvents in
            guard let midiManager else { return }
            guard let output = midiManager.managedOutputs[Self.kHUIOutputName]
            else {
                logger.debug("MIDI output missing.")
                return
            }
            
            do {
                try output.send(events: midiEvents)
            } catch {
                logger.debug("\(error.localizedDescription)")
            }
        }
    }
}

// MARK: - MIDI I/O

extension HUIClientHelper {
    public func startVirtualPorts() async {
        guard let midiManager else { return }
        
        let huiSurface = await huiSurface
        
        do {
            if midiManager.managedInputs.isEmpty {
                try midiManager.addInput(
                    name: Self.kHUIInputName,
                    tag: Self.kHUIInputName,
                    uniqueID: .userDefaultsManaged(key: Self.kHUIInputName),
                    receiver: .weak(huiSurface)
                )
            }
            if midiManager.managedOutputs.isEmpty {
                try midiManager.addOutput(
                    name: Self.kHUIOutputName,
                    tag: Self.kHUIOutputName,
                    uniqueID: .userDefaultsManaged(key: Self.kHUIOutputName)
                )
            }
        } catch {
            logger.debug("Error setting up MIDI.")
        }
    }
    
    public nonisolated func stopVirtualPorts() {
        guard let midiManager else { return }
        midiManager.remove(.input, .withTag(Self.kHUIInputName))
        midiManager.remove(.output, .withTag(Self.kHUIOutputName))
    }
}
