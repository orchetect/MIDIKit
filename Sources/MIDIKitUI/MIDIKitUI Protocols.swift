//
//  MIDIKitUI Protocols.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitIO

// MARK: - MIDIEndpointsSelectable

@available(macOS 11.0, iOS 14.0, *)
public protocol MIDIEndpointsSelectable where Self: View, Endpoint.ID == MIDIIdentifier {
    associatedtype Endpoint: MIDIEndpoint & Hashable & Identifiable
    
    var endpoints: [Endpoint] { get set }
    var maskedFilter: MIDIEndpointMaskedFilter? { get set }
    var selectionID: MIDIIdentifier? { get set }
    var selectionDisplayName: String? { get set }
    
    var ids: [MIDIIdentifier] { get set }
}

@available(macOS 11.0, iOS 14.0, *)
extension MIDIEndpointsSelectable {
    /// Returns non-nil if properties require updating.
    func updatedID(endpoints: [Endpoint]) -> (id: MIDIIdentifier?, displayName: String?)? {
        if selectionID == .invalidMIDIIdentifier {
            return (id: nil, displayName: nil)
        }
        
        if let selectionID = selectionID,
           let selectionDisplayName = selectionDisplayName,
           let found = endpoints.first(
            whereUniqueID: selectionID,
            fallbackDisplayName: selectionDisplayName
           )
        {
            return (id: found.uniqueID, displayName: found.displayName)
        }
        
        return nil
    }
    
    func generateIDs(
        endpoints: [Endpoint],
        maskedFilter: MIDIEndpointMaskedFilter?,
        midiManager: ObservableMIDIManager?
    ) -> [MIDIIdentifier] {
        var endpointIDs: [MIDIIdentifier] = []
        if let maskedFilter = maskedFilter, let midiManager = midiManager {
            endpointIDs = endpoints
                .filter(maskedFilter, in: midiManager)
                .map(\.id)
        } else {
            endpointIDs = endpoints
                .map(\.id)
        }
        
        if let selectionID, !endpointIDs.contains(selectionID) {
            return [selectionID] + endpointIDs
        } else {
            return endpointIDs
        }
    }
    
    func endpoint(for id: MIDIIdentifier) -> Endpoint? {
        endpoints.first(whereUniqueID: id)
    }
}

// MARK: - MIDIInputsSelectable

@available(macOS 11.0, iOS 14.0, *)
public protocol MIDIInputsSelectable {
    func updatingOutputConnection(withTag tag: String?) -> Self
}

@available(macOS 11.0, iOS 14.0, *)
protocol _MIDIInputsSelectable: MIDIInputsSelectable {
    var updatingOutputConnectionWithTag: String? { get set }
}

@available(macOS 11.0, iOS 14.0, *)
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


// MARK: - MIDIOutputsSelectable

@available(macOS 11.0, iOS 14.0, *)
public protocol MIDIOutputsSelectable { 
    func updatingInputConnection(withTag tag: String?) -> Self
}

@available(macOS 11.0, iOS 14.0, *)
protocol _MIDIOutputsSelectable: MIDIOutputsSelectable {
    var updatingInputConnectionWithTag: String? { get set }
}

@available(macOS 11.0, iOS 14.0, *)
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
        
        guard let selectedUniqueID = selectedUniqueID,
              let selectedDisplayName = selectedDisplayName,
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
