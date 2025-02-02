//
//  MIDIOutputsSelectable.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import MIDIKitIO
import SwiftUI

/// Protocol adopted by MIDIKitUI SwiftUI views that allow the user to select MIDI output endpoints.
@available(macOS 14.0, iOS 17.0, *)
public protocol MIDIOutputsSelectable {
    func updatingInputConnection(withTag tag: String?) -> Self
}

@available(macOS 14.0, iOS 17.0, *)
protocol _MIDIOutputsSelectable: MIDIOutputsSelectable {
    var updatingInputConnectionWithTag: String? { get set }
}

@available(macOS 14.0, iOS 17.0, *)
extension _MIDIOutputsSelectable {
    public func updatingInputConnection(withTag tag: String?) -> Self {
        var copy = self
        copy.updatingInputConnectionWithTag = tag
        return copy
    }
    
    func updateInputConnection(
        selectedUniqueID: MIDIIdentifier?,
        selectedDisplayName: String?,
        midiManager: ObservableMIDIManager
    ) {
        guard let tag = updatingInputConnectionWithTag,
              let midiInputConnection = midiManager.managedInputConnections[tag]
        else { return }
        
        guard let selectedUniqueID,
              let selectedDisplayName,
              selectedUniqueID != .invalidMIDIIdentifier
        else {
            midiInputConnection.removeAllOutputs()
            return
        }
        
        let criterium: MIDIEndpointIdentity = .uniqueIDWithFallback(
            id: selectedUniqueID, fallbackDisplayName: selectedDisplayName
        )
        if midiInputConnection.outputsCriteria != [criterium] {
            midiInputConnection.removeAllOutputs()
            midiInputConnection.add(outputs: [criterium])
        }
    }
}

#endif
