//
//  MIDIEndpointsList.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitIO

internal struct MIDIEndpointsList<Endpoint>: View
where Endpoint: MIDIEndpoint & Hashable & Identifiable, Endpoint.ID == MIDIIdentifier {
    var endpoints: [Endpoint]
    @Binding var selection: MIDIIdentifier?
    @Binding var cachedSelectionName: String?
    let showIcons: Bool
    
    @State private var ids: [MIDIIdentifier] = []
    
    init(
        endpoints: [Endpoint],
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool
    ) {
        self.endpoints = endpoints
        self._selection = selection
        self._cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
        self._ids = State(initialValue: generateIDs(endpoints: endpoints))
    }
    
    public var body: some View {
        List(selection: $selection) {
            ForEach(ids, id: \.self) {
                EndpointRow(endpoint: endpoint(for: $0), cachedSelectionName: $cachedSelectionName, showIcon: showIcons)
                    .tag($0 as MIDIIdentifier?)
            }
        }
        .onAppear {
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
    
    private func generateIDs(endpoints: [Endpoint]) -> [MIDIIdentifier]{
        let endpointIDs = endpoints.map(\.id)
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
    
    private struct EndpointRow<Endpoint: MIDIEndpoint>: View {
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

public struct MIDIInputsList: View {
    @EnvironmentObject private var midiManager: MIDIManager
    
    @Binding public var selection: MIDIIdentifier?
    @Binding public var cachedSelectionName: String?
    public let showIcons: Bool
    
    public init(
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool = true
    ) {
        self._selection = selection
        self._cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
    }
    
    public var body: some View {
        MIDIEndpointsList<MIDIInputEndpoint>(
            endpoints: midiManager.endpoints.inputs,
            selection: $selection,
            cachedSelectionName: $cachedSelectionName,
            showIcons: showIcons
        )
    }
}

public struct MIDIOutputsList: View {
    @EnvironmentObject private var midiManager: MIDIManager
    
    @Binding public var selection: MIDIIdentifier?
    @Binding public var cachedSelectionName: String?
    public let showIcons: Bool
    
    public init(
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool = true
    ) {
        self._selection = selection
        self._cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
    }
    
    public var body: some View {
        MIDIEndpointsList<MIDIOutputEndpoint>(
            endpoints: midiManager.endpoints.outputs,
            selection: $selection,
            cachedSelectionName: $cachedSelectionName,
            showIcons: showIcons
        )
    }
}
