//
//  MIDIEndpointsList.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import MIDIKitIO
import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
struct MIDIEndpointsList<Endpoint>: View
where Endpoint: MIDIEndpoint & Hashable & Identifiable, Endpoint.ID == MIDIIdentifier {
    private weak var midiManager: ObservableMIDIManager?
    
    var endpoints: [Endpoint]
    var maskedFilter: MIDIEndpointMaskedFilter?
    @Binding var selection: MIDIIdentifier?
    @Binding var cachedSelectionName: String?
    let showIcons: Bool
    
    @State private var ids: [MIDIIdentifier] = []
    
    init(
        endpoints: [Endpoint],
        maskedFilter: MIDIEndpointMaskedFilter?,
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool,
        midiManager: ObservableMIDIManager?
    ) {
        self.endpoints = endpoints
        self.maskedFilter = maskedFilter
        _selection = selection
        _cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
        self.midiManager = midiManager
        
        // pre-populate IDs
        _ids = State(initialValue: generateIDs(endpoints: endpoints, maskedFilter: maskedFilter))
    }
    
    public var body: some View {
        List(selection: $selection) {
            ForEach(ids, id: \.self) {
                EndpointRow(
                    endpoint: endpoint(for: $0),
                    cachedSelectionName: $cachedSelectionName,
                    showIcon: showIcons
                )
                .tag($0 as MIDIIdentifier?)
            }
        }
        .onAppear {
            updateIDs(endpoints: endpoints, maskedFilter: maskedFilter)
        }
        .onChange(of: maskedFilter) { newValue in
            updateIDs(endpoints: endpoints, maskedFilter: newValue)
        }
        .onChange(of: endpoints) { newValue in
            updateIDs(endpoints: newValue, maskedFilter: maskedFilter)
        }
        .onChange(of: selection) { newValue in
            updateIDs(endpoints: endpoints, maskedFilter: maskedFilter)
            guard let selection = newValue else {
                cachedSelectionName = nil
                return
            }
            if let dn = endpoint(for: selection)?.displayName {
                cachedSelectionName = dn
            }
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
        
        if let selection, !endpointIDs.contains(selection) {
            return [selection] + endpointIDs
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
        @Binding var cachedSelectionName: String?
        let showIcon: Bool
        
        var body: some View {
            if showIcon {
                Label {
                    text
                } icon: {
                    image
                        .frame(width: 20, height: 20)
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
                ? cachedSelectionName ?? "Missing"
                : (cachedSelectionName ?? "") + " (Missing)"
        }
        
        @ViewBuilder
        private var image: some View {
            if let endpoint {
                if let img = endpoint.image {
                    img
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "pianokeys")
                    #if os(macOS)
                        .foregroundColor(.primary) // needed otherwise it uses accent color
                    #endif
                }
            } else {
                Image(systemName: "exclamationmark.triangle.fill")
                #if os(macOS)
                    .foregroundColor(.primary) // needed otherwise it uses accent color
                #endif
            }
        }
    }
}

/// SwiftUI `List` view for selecting MIDI input endpoints.
@available(macOS 11.0, iOS 14.0, *)
public struct MIDIInputsList: View {
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    
    @Binding public var selection: MIDIIdentifier?
    @Binding public var cachedSelectionName: String?
    public var showIcons: Bool
    public var hideOwned: Bool
    
    public init(
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool = true,
        hideOwned: Bool = false
    ) {
        _selection = selection
        _cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
        self.hideOwned = hideOwned
    }
    
    public var body: some View {
        MIDIEndpointsList<MIDIInputEndpoint>(
            endpoints: midiManager.observableEndpoints.inputs,
            maskedFilter: maskedFilter,
            selection: $selection,
            cachedSelectionName: $cachedSelectionName,
            showIcons: showIcons,
            midiManager: midiManager
        )
        Text("Selected: \(cachedSelectionName ?? "None")")
    }
    
    private var maskedFilter: MIDIEndpointMaskedFilter? {
        hideOwned ? .drop(.owned()) : nil
    }
}

/// SwiftUI `List` view for selecting MIDI output endpoints.
@available(macOS 11.0, iOS 14.0, *)
public struct MIDIOutputsList: View {
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    
    @Binding public var selection: MIDIIdentifier?
    @Binding public var cachedSelectionName: String?
    public var showIcons: Bool
    public var hideOwned: Bool
    
    public init(
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool = true,
        hideOwned: Bool = false
    ) {
        _selection = selection
        _cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
        self.hideOwned = hideOwned
    }
    
    public var body: some View {
        MIDIEndpointsList<MIDIOutputEndpoint>(
            endpoints: midiManager.observableEndpoints.outputs,
            maskedFilter: maskedFilter,
            selection: $selection,
            cachedSelectionName: $cachedSelectionName,
            showIcons: showIcons,
            midiManager: midiManager
        )
        Text("Selected: \(cachedSelectionName ?? "None")")
    }
    
    private var maskedFilter: MIDIEndpointMaskedFilter? {
        hideOwned ? .drop(.owned()) : nil
    }
}

#endif
