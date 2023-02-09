//
//  MIDIThruConnectionProxy.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI
import MIDIKitCore

/// Internal class.
/// Used as a stand-in replacement for Core MIDI's `MIDIThruConnectionCreate` on macOS versions that are affected by the thru-connection bug.
final class MIDIThruConnectionProxy {
    private var inputConnection: MIDIInputConnection!
    private var outputConnection: MIDIOutputConnection!
    
    internal init(
        outputs: [MIDIOutputEndpoint],
        inputs: [MIDIInputEndpoint],
        midiManager: MIDIManager,
        api: CoreMIDIAPIVersion = .bestForPlatform()
    ) throws {
        outputConnection = MIDIOutputConnection(
            criteria: Set(inputs.asIdentities()),
            mode: .definedEndpoints,
            filter: .default(),
            midiManager: midiManager,
            api: api
        )
        
        inputConnection = MIDIInputConnection(
            criteria: Set(outputs.asIdentities()),
            mode: .definedEndpoints,
            filter: .default(),
            receiver: .events(translateMIDI1NoteOnZeroVelocityToNoteOff: false, { [weak self] events in
                try? self?.outputConnection.send(events: events)
            }),
            midiManager: midiManager,
            api: api
        )
        
        try outputConnection.setupOutput(in: midiManager)
        try outputConnection.resolveEndpoints(in: midiManager)
        
        try inputConnection.listen(in: midiManager)
        try inputConnection.connect(in: midiManager)
    }
}

extension MIDIThruConnectionProxy {
    internal func notification(_ internalNotification: MIDIIOInternalNotification) {
        inputConnection.notification(internalNotification)
        outputConnection.notification(internalNotification)
    }
}

#endif
