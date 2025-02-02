//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

@Observable final class MIDIHelper {
    private weak var midiManager: ObservableMIDIManager?
    
    public init() { }
    
    public func setup(midiManager: ObservableMIDIManager) {
        self.midiManager = midiManager
        
        midiManager.notificationHandler = { notification in
            print("Core MIDI notification:", notification)
        }
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            logger.error("Error starting MIDI services: \(error.localizedDescription)")
        }
        
        createVirtualEndpoints()
        createConnections()
    }
    
    // MARK: - MIDI Connections
    
    public var midiInputConnection: MIDIInputConnection? {
        midiManager?.managedInputConnections[ConnectionTags.inputConnectionTag]
    }
    
    public var midiOutputConnection: MIDIOutputConnection? {
        midiManager?.managedOutputConnections[ConnectionTags.outputConnectionTag]
    }
    
    private func createConnections() {
        do {
            if midiInputConnection == nil {
                logger.debug("Adding MIDI input connection to the manager.")
                
                try midiManager?.addInputConnection(
                    to: .none,
                    tag: ConnectionTags.inputConnectionTag,
                    receiver: .eventsLogging(options: [
                        .bundleRPNAndNRPNDataEntryLSB,
                        .filterActiveSensingAndClock
                    ])
                )
            }
        } catch {
            logger.error("\(error.localizedDescription)")
        }
        
        do {
            if midiOutputConnection == nil {
                logger.debug("Adding MIDI output connection to the manager.")
                
                try midiManager?.addOutputConnection(
                    to: .none,
                    tag: ConnectionTags.outputConnectionTag
                )
            }
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    // MARK: - Virtual Endpoints
    
    public var midiInput: MIDIInput? {
        midiManager?.managedInputs[ConnectionTags.inputTag]
    }
    
    public var midiOutput: MIDIOutput? {
        midiManager?.managedOutputs[ConnectionTags.outputTag]
    }
    
    private func createVirtualEndpoints() {
        do {
            if midiInput == nil {
                logger.debug("Adding virtual MIDI input port to the manager.")
                
                try midiManager?.addInput(
                    name: ConnectionTags.inputName,
                    tag: ConnectionTags.inputTag,
                    uniqueID: .userDefaultsManaged(key: ConnectionTags.inputTag),
                    receiver: .eventsLogging(options: [
                        .bundleRPNAndNRPNDataEntryLSB,
                        .filterActiveSensingAndClock
                    ])
                )
            }
        } catch {
            logger.error("\(error.localizedDescription)")
        }
        
        do {
            if midiOutput == nil {
                logger.debug("Adding virtual MIDI output port to the manager.")
                
                try midiManager?.addOutput(
                    name: ConnectionTags.outputName,
                    tag: ConnectionTags.outputTag,
                    uniqueID: .userDefaultsManaged(key: ConnectionTags.outputTag)
                )
            }
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    public func destroyVirtualEndpoints() {
        midiManager?.remove(.input, .all)
        midiManager?.remove(.output, .all)
    }
    
    public var virtualEndpointsExist: Bool {
        midiInput != nil &&
            midiOutput != nil
    }
}
