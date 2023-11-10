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
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    
    let title: String
    var endpoints: [Endpoint]
    var maskedFilter: MIDIEndpointMaskedFilter?
    @Binding var selection: MIDIIdentifier?
    @Binding var cachedSelectionName: String?
    var showIcons: Bool
    
    @State private var ids: [MIDIIdentifier] = []
    
    init(
        title: String,
        endpoints: [Endpoint],
        maskedFilter: MIDIEndpointMaskedFilter?,
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool
    ) {
        self.title = title
        self.endpoints = endpoints
        self.maskedFilter = maskedFilter
        _selection = selection
        _cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
    }
    
    public var body: some View {
        Picker(title, selection: $selection) {
            Text("None")
                .tag(MIDIIdentifier?.none)
            
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
        .onChange(of: maskedFilter) { newValue in
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
        var endpointIDs: [MIDIIdentifier] = []
        if filtered, let maskedFilter = maskedFilter {
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
                ? cachedSelectionName ?? "Missing"
                : (cachedSelectionName ?? "") + " (Missing)"
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
    @Binding public var selection: MIDIIdentifier?
    @Binding public var cachedSelectionName: String?
    public var showIcons: Bool
    public var filterOwned: Bool
    
    public init(
        title: String,
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool = true,
        filterOwned: Bool = false
    ) {
        self.title = title
        _selection = selection
        _cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
        self.filterOwned = filterOwned
    }
    
    public var body: some View {
        MIDIEndpointsPicker<MIDIInputEndpoint>(
            title: title,
            endpoints: midiManager.observableEndpoints.inputs,
            maskedFilter: maskedFilter,
            selection: $selection,
            cachedSelectionName: $cachedSelectionName,
            showIcons: showIcons
        )
    }
    
    private var maskedFilter: MIDIEndpointMaskedFilter {
        .drop(filterOwned ? .owned() : .default())
    }
}

/// SwiftUI `Picker` view for selecting MIDI output endpoints.
@available(macOS 11.0, iOS 14.0, *)
public struct MIDIOutputsPicker: View {
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    
    public var title: String
    @Binding public var selection: MIDIIdentifier?
    @Binding public var cachedSelectionName: String?
    public var showIcons: Bool
    public var filterOwned: Bool
    
    public init(
        title: String,
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool = true,
        filterOwned: Bool = false
    ) {
        self.title = title
        _selection = selection
        _cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
        self.filterOwned = filterOwned
    }
    
    public var body: some View {
        MIDIEndpointsPicker<MIDIOutputEndpoint>(
            title: title,
            endpoints: midiManager.observableEndpoints.outputs,
            maskedFilter: maskedFilter,
            selection: $selection,
            cachedSelectionName: $cachedSelectionName,
            showIcons: showIcons
        )
    }
    
    private var maskedFilter: MIDIEndpointMaskedFilter {
        .drop(filterOwned ? .owned() : .default())
    }
}

#endif
