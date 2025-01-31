//
//  MIDIEndpointsSelectable.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import SwiftUI
import MIDIKitIO

/// Protocol adopted by MIDIKitUI SwiftUI views that allow the user to select MIDI endpoints.
@available(macOS 14.0, iOS 17.0, *)
public protocol MIDIEndpointsSelectable where Self: View, Endpoint.ID == MIDIIdentifier {
    associatedtype Endpoint: MIDIEndpoint & Hashable & Identifiable
    
    var endpoints: [Endpoint] { get set }
    var maskedFilter: MIDIEndpointMaskedFilter? { get set }
    var selectionID: MIDIIdentifier? { get set }
    var selectionDisplayName: String? { get set }
    
    var ids: [MIDIIdentifier] { get set }
}

@available(macOS 14.0, iOS 17.0, *)
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

#endif
