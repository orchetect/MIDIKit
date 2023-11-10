//
//  MIDIEndpointsPicker.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import MIDIKitIO
import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
struct MIDIEndpointsPicker<Endpoint>: View
where Endpoint: MIDIEndpoint & Hashable & Identifiable, Endpoint.ID == MIDIIdentifier {
    private weak var midiManager: ObservableMIDIManager?
    
    let title: String
    var endpoints: [Endpoint]
    var maskedFilter: MIDIEndpointMaskedFilter?
    @Binding var selectionID: MIDIIdentifier?
    @Binding var selectionDisplayName: String?
    var showIcons: Bool
    
    @State private var ids: [MIDIIdentifier] = []
    
    init(
        title: String,
        endpoints: [Endpoint],
        maskedFilter: MIDIEndpointMaskedFilter?,
        selectionID: Binding<MIDIIdentifier?>,
        selectionDisplayName: Binding<String?>,
        showIcons: Bool,
        midiManager: ObservableMIDIManager?
    ) {
        self.title = title
        self.endpoints = endpoints
        self.maskedFilter = maskedFilter
        _selectionID = selectionID
        _selectionDisplayName = selectionDisplayName
        self.showIcons = showIcons
        self.midiManager = midiManager
        
        // pre-populate IDs
        _ids = State(initialValue: generateIDs(endpoints: endpoints, maskedFilter: maskedFilter))
    }
    
    public var body: some View {
        Picker(title, selection: $selectionID) {
            Text("None")
                .tag(MIDIIdentifier?.none)
            
            ForEach(ids, id: \.self) {
                EndpointRow(
                    endpoint: endpoint(for: $0),
                    selectionDisplayName: $selectionDisplayName,
                    showIcon: showIcons
                )
                .tag($0 as MIDIIdentifier?)
            }
        }
        .onAppear {
            updateID(endpoints: endpoints)
            updateIDs(endpoints: endpoints, maskedFilter: maskedFilter)
        }
        .onChange(of: maskedFilter) { newValue in
            updateIDs(endpoints: endpoints, maskedFilter: newValue)
        }
        .onChange(of: endpoints) { newValue in
            updateID(endpoints: newValue)
            updateIDs(endpoints: newValue, maskedFilter: maskedFilter)
        }
        .onChange(of: selectionID) { newValue in
            updateIDs(endpoints: endpoints, maskedFilter: maskedFilter)
            guard let selectionID = newValue else {
                selectionDisplayName = nil
                return
            }
            if let dn = endpoint(for: selectionID)?.displayName {
                selectionDisplayName = dn
            }
        }
    }
    
    private func updateID(endpoints: [Endpoint]) {
        if selectionID == .invalidMIDIIdentifier {
            selectionID = nil
            selectionDisplayName = nil
            return
        }
        
        if let selectionID = selectionID,
           let selectionDisplayName = selectionDisplayName,
           let found = endpoints.first(
               whereUniqueID: selectionID,
               fallbackDisplayName: selectionDisplayName
           )
        {
            self.selectionDisplayName = found.displayName
            // update ID in case it changed
            if self.selectionID != found.uniqueID { self.selectionID = found.uniqueID }
        }
    }
    
    private func generateIDs(
        endpoints: [Endpoint],
        maskedFilter: MIDIEndpointMaskedFilter?
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
    
    /// (Don't run from init.)
    private func updateIDs(
        endpoints: [Endpoint],
        maskedFilter: MIDIEndpointMaskedFilter?
    ) {
        ids = generateIDs(endpoints: endpoints, maskedFilter: maskedFilter)
    }
    
    private func endpoint(for id: MIDIIdentifier) -> Endpoint? {
        endpoints.first(whereUniqueID: id)
    }
    
    private struct EndpointRow: View {
        let endpoint: Endpoint?
        @Binding var selectionDisplayName: String?
        let showIcon: Bool
        
        var body: some View {
            if showIcon {
                HStack {
                    #if os(macOS)
                    image(resampled: true)
                        .frame(
                            width: 16,
                            height: 16
                        ) // only works on macOS with inline picker style
                    #elseif os(iOS)
                    image(resampled: false)
                    #else
                    image(resampled: false)
                    #endif
                    text
                }
            } else {
                text
            }
        }
        
        @ViewBuilder
        private var text: some View {
            if let endpoint {
                Text(endpoint.displayName)
            } else {
                Text(missingText)
                    .foregroundColor(.secondary)
            }
        }
        
        private var missingText: String {
            showIcon
                ? selectionDisplayName ?? "Missing"
                : (selectionDisplayName ?? "") + " (Missing)"
        }
        
        @ViewBuilder
        private func image(resampled: Bool) -> some View {
            if let endpoint {
                let img = resampled
                    ? endpoint.image(resizedTo: .init(width: 16, height: 16))
                    : endpoint.image
                
                if let img {
                    img
                } else {
                    Image(systemName: "pianokeys")
                }
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
            }
        }
    }
}

/// SwiftUI `Picker` view for selecting MIDI input endpoints.
@available(macOS 11.0, iOS 14.0, *)
public struct MIDIInputsPicker: View {
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    
    public var title: String
    @Binding public var selectionID: MIDIIdentifier?
    @Binding public var selectionDisplayName: String?
    public var showIcons: Bool
    public var hideOwned: Bool
    
    public init(
        title: String,
        selectionID: Binding<MIDIIdentifier?>,
        selectionDisplayName: Binding<String?>,
        showIcons: Bool = true,
        hideOwned: Bool = false
    ) {
        self.title = title
        _selectionID = selectionID
        _selectionDisplayName = selectionDisplayName
        self.showIcons = showIcons
        self.hideOwned = hideOwned
    }
    
    public var body: some View {
        MIDIEndpointsPicker<MIDIInputEndpoint>(
            title: title,
            endpoints: midiManager.observableEndpoints.inputs,
            maskedFilter: maskedFilter,
            selectionID: $selectionID,
            selectionDisplayName: $selectionDisplayName,
            showIcons: showIcons,
            midiManager: midiManager
        )
    }
    
    private var maskedFilter: MIDIEndpointMaskedFilter? {
        hideOwned ? .drop(.owned()) : nil
    }
}

/// SwiftUI `Picker` view for selecting MIDI output endpoints.
@available(macOS 11.0, iOS 14.0, *)
public struct MIDIOutputsPicker: View {
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    
    public var title: String
    @Binding public var selectionID: MIDIIdentifier?
    @Binding public var selectionDisplayName: String?
    public var showIcons: Bool
    public var hideOwned: Bool
    
    public init(
        title: String,
        selectionID: Binding<MIDIIdentifier?>,
        selectionDisplayName: Binding<String?>,
        showIcons: Bool = true,
        hideOwned: Bool = false
    ) {
        self.title = title
        _selectionID = selectionID
        _selectionDisplayName = selectionDisplayName
        self.showIcons = showIcons
        self.hideOwned = hideOwned
    }
    
    public var body: some View {
        MIDIEndpointsPicker<MIDIOutputEndpoint>(
            title: title,
            endpoints: midiManager.observableEndpoints.outputs,
            maskedFilter: maskedFilter,
            selectionID: $selectionID,
            selectionDisplayName: $selectionDisplayName,
            showIcons: showIcons,
            midiManager: midiManager
        )
    }
    
    private var maskedFilter: MIDIEndpointMaskedFilter? {
        hideOwned ? .drop(.owned()) : nil
    }
}

#endif
