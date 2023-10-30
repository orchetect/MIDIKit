//
//  MIDIThruConnectionProxy.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@_implementationOnly import CoreMIDI
import Foundation
import MIDIKitCore

/// Internal class.
/// Used as a stand-in replacement for Core MIDI's `MIDIThruConnectionCreate` on macOS versions that
/// are affected by the thru-connection bug.
final class MIDIThruConnectionProxy {
    private var inputConnection: MIDIInputConnection!
    private var outputConnection: MIDIOutputConnection!
    
    init(
        outputs: [MIDIOutputEndpoint],
        inputs: [MIDIInputEndpoint],
        midiManager: MIDIManager,
        api: CoreMIDIAPIVersion = .bestForPlatform()
    ) throws {
        outputConnection = MIDIOutputConnection(
            mode: .inputs(matching: Set(inputs.asIdentities())),
            filter: .default(),
            midiManager: midiManager,
            api: api
        )
        
        inputConnection = MIDIInputConnection(
            mode: .outputs(matching: Set(outputs.asIdentities())),
            filter: .default(),
            receiver: .events { [weak self] events in
                try? self?.outputConnection.send(events: events)
            },
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
    func notification(_ internalNotification: MIDIIOInternalNotification) {
        inputConnection.notification(internalNotification)
        outputConnection.notification(internalNotification)
    }
}

#endif
