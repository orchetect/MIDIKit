//
//  MIDIInputsSelectable.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import SwiftUI
import MIDIKitIO

/// Protocol adopted by MIDIKitUI SwiftUI views that allow the user to select MIDI input endpoints.
@available(macOS 14.0, iOS 17.0, *)
public protocol MIDIInputsSelectable {
    func updatingOutputConnection(withTag tag: String?) -> Self
}

@available(macOS 14.0, iOS 17.0, *)
protocol _MIDIInputsSelectable: MIDIInputsSelectable {
    var updatingOutputConnectionWithTag: String? { get set }
}

@available(macOS 14.0, iOS 17.0, *)
extension _MIDIInputsSelectable {
    public func updatingOutputConnection(withTag tag: String?) -> Self {
        var copy = self
        copy.updatingOutputConnectionWithTag = tag
        return copy
    }
    
    func updateOutputConnection(
        selectedUniqueID: MIDIIdentifier?,
        selectedDisplayName: String?,
        midiManager: ObservableMIDIManager
    ) {
        guard let tag = updatingOutputConnectionWithTag,
              let midiOutputConnection = midiManager.managedOutputConnections[tag]
        else { return }
        
        guard let selectedUniqueID = selectedUniqueID,
              let selectedDisplayName = selectedDisplayName,
              selectedUniqueID != .invalidMIDIIdentifier
        else {
            midiOutputConnection.removeAllInputs()
            return
        }
        
        let criterium: MIDIEndpointIdentity = .uniqueIDWithFallback(
            id: selectedUniqueID, fallbackDisplayName: selectedDisplayName
        )
        if midiOutputConnection.inputsCriteria != [criterium] {
            midiOutputConnection.removeAllInputs()
            midiOutputConnection.add(inputs: [criterium])
        }
    }
}

#endif
