//
//  MIDIEndpointsList.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import SwiftUI
import MIDIKitIO

@available(macOS 11.0, iOS 14.0, *)
internal struct MIDIEndpointsList<Endpoint>: View
where Endpoint: MIDIEndpoint & Hashable & Identifiable, Endpoint.ID == MIDIIdentifier {
    @EnvironmentObject private var midiManager: MIDIManager
    
    var endpoints: [Endpoint]
    @State var filter: MIDIEndpointFilter
    @Binding var selection: MIDIIdentifier?
    @Binding var cachedSelectionName: String?
    let showIcons: Bool
    
    @State private var ids: [MIDIIdentifier] = []
    
    init(
        endpoints: [Endpoint],
        filter: MIDIEndpointFilter,
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool
    ) {
        self.endpoints = endpoints
        self._filter = State(initialValue: filter)
        self._selection = selection
        self._cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
        // set up initial data, but skip filter because midiManager is not available yet
        self._ids = State(initialValue: generateIDs(endpoints: endpoints, filtered: false))
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
            updateIDs(endpoints: endpoints)
        }
        .onChange(of: filter) { newValue in
            updateIDs(endpoints: endpoints)
        }
        .onChange(of: endpoints) { newValue in
            updateIDs(endpoints: newValue)
        }
        .onChange(of: selection) { newValue in
            updateIDs(endpoints: endpoints)
            guard let selection else {
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
        filtered: Bool = true
    ) -> [MIDIIdentifier] {
        let endpointIDs = {
            filtered ? endpoints.filter(using: filter, in: midiManager) : endpoints
        }()
        .map(\.id)
        
        if let selection, !endpointIDs.contains(selection) {
            return [selection] + endpointIDs
        }
        else {
            return endpointIDs
        }
    }
    
    /// (Don't run from init.)
    private func updateIDs(endpoints: [Endpoint]) {
        ids = generateIDs(endpoints: endpoints)
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
    @EnvironmentObject private var midiManager: MIDIManager
    
    @Binding public var selection: MIDIIdentifier?
    @Binding public var cachedSelectionName: String?
    public let showIcons: Bool
    public let filterOwned: Bool
    
    public init(
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool = true,
        filterOwned: Bool = false
    ) {
        self._selection = selection
        self._cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
        self.filterOwned = filterOwned
    }
    
    public var body: some View {
        MIDIEndpointsList<MIDIInputEndpoint>(
            endpoints: midiManager.endpoints.inputs,
            filter: filterOwned ? .owned() : .default(),
            selection: $selection,
            cachedSelectionName: $cachedSelectionName,
            showIcons: showIcons
        )
        Text("Selected: \(cachedSelectionName ?? "None")")
    }
}

/// SwiftUI `List` view for selecting MIDI output endpoints.
@available(macOS 11.0, iOS 14.0, *)
public struct MIDIOutputsList: View {
    @EnvironmentObject private var midiManager: MIDIManager
    
    @Binding public var selection: MIDIIdentifier?
    @Binding public var cachedSelectionName: String?
    public let showIcons: Bool
    public let filterOwned: Bool
    
    public init(
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool = true,
        filterOwned: Bool = false
    ) {
        self._selection = selection
        self._cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
        self.filterOwned = filterOwned
    }
    
    public var body: some View {
        MIDIEndpointsList<MIDIOutputEndpoint>(
            endpoints: midiManager.endpoints.outputs,
            filter: filterOwned ? .owned() : .default(),
            selection: $selection,
            cachedSelectionName: $cachedSelectionName,
            showIcons: showIcons
        )
        Text("Selected: \(cachedSelectionName ?? "None")")
    }
}

#endif
