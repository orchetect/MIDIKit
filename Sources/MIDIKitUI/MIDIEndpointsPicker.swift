//
//  MIDIEndpointsPicker.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI)

import SwiftUI
import MIDIKitIO

@available(macOS 11.0, iOS 14.0, *)
internal struct MIDIEndpointsPicker<Endpoint>: View
where Endpoint: MIDIEndpoint & Hashable & Identifiable, Endpoint.ID == MIDIIdentifier {
    var title: String
    var endpoints: [Endpoint]
    @Binding var selection: MIDIIdentifier?
    @Binding var cachedSelectionName: String?
    let showIcons: Bool
    
    @State private var ids: [MIDIIdentifier] = []
    
    init(
        title: String,
        endpoints: [Endpoint],
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool
    ) {
        self.title = title
        self.endpoints = endpoints
        self._selection = selection
        self._cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
        self._ids = State(initialValue: generateIDs(endpoints: endpoints))
    }
    
    public var body: some View {
        Picker(title, selection: $selection) {
            Text("None")
                .tag(MIDIIdentifier?.none)
            
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
    
    private func generateIDs(endpoints: [Endpoint]) -> [MIDIIdentifier] {
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
                HStack {
#if os(macOS)
                    image(resampled: true)
                        .frame(width: 16, height: 16) // only works on macOS with inline picker style
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

@available(macOS 11.0, iOS 14.0, *)
public struct MIDIInputsPicker: View {
    @EnvironmentObject private var midiManager: MIDIManager
    
    public var title: String
    @Binding public var selection: MIDIIdentifier?
    @Binding public var cachedSelectionName: String?
    public let showIcons: Bool
    
    public init(
        title: String,
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool = true
    ) {
        self.title = title
        self._selection = selection
        self._cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
    }
    
    public var body: some View {
        MIDIEndpointsPicker<MIDIInputEndpoint>(
            title: title,
            endpoints: midiManager.endpoints.inputs,
            selection: $selection,
            cachedSelectionName: $cachedSelectionName,
            showIcons: showIcons
        )
    }
}

@available(macOS 11.0, iOS 14.0, *)
public struct MIDIOutputsPicker: View {
    @EnvironmentObject private var midiManager: MIDIManager
    
    public init(
        title: String,
        selection: Binding<MIDIIdentifier?>,
        cachedSelectionName: Binding<String?>,
        showIcons: Bool = true
    ) {
        self.title = title
        self._selection = selection
        self._cachedSelectionName = cachedSelectionName
        self.showIcons = showIcons
    }
    
    public var title: String
    @Binding public var selection: MIDIIdentifier?
    @Binding public var cachedSelectionName: String?
    public let showIcons: Bool
    
    public var body: some View {
        MIDIEndpointsPicker<MIDIOutputEndpoint>(
            title: title,
            endpoints: midiManager.endpoints.outputs,
            selection: $selection,
            cachedSelectionName: $cachedSelectionName,
            showIcons: showIcons
        )
    }
}

#endif
