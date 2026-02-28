//
//  MIDIEndpointsPicker.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import MIDIKitIO
import SwiftUI

/// Internal generic MIDI endpoints SwiftUI picker view that can be specialized for either inputs or outputs.
@available(macOS 14.0, iOS 17.0, *)
struct MIDIEndpointsPicker<Endpoint>: View, MIDIEndpointsSelectable
    where Endpoint: MIDIEndpoint & Hashable & Identifiable,
    Endpoint.ID == MIDIIdentifier
{
    private weak var midiManager: ObservableMIDIManager?
    
    let title: String
    var endpoints: [Endpoint]
    var maskedFilter: MIDIEndpointMaskedFilter?
    @Binding var selectionID: MIDIIdentifier?
    @Binding var selectionDisplayName: String?
    var showIcons: Bool
    
    @State var ids: [MIDIIdentifier] = []
    
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
        _ids = State(initialValue: generateIDs(endpoints: endpoints, maskedFilter: maskedFilter, midiManager: midiManager))
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
            ids = generateIDs(endpoints: endpoints, maskedFilter: maskedFilter, midiManager: midiManager)
        }
        .onChange(of: maskedFilter) { newValue in
            ids = generateIDs(endpoints: endpoints, maskedFilter: newValue, midiManager: midiManager)
        }
        .onChange(of: endpoints) { newValue in
            updateID(endpoints: newValue)
            ids = generateIDs(endpoints: newValue, maskedFilter: maskedFilter, midiManager: midiManager)
        }
        .onChange(of: selectionID) { newValue in
            ids = generateIDs(endpoints: endpoints, maskedFilter: maskedFilter, midiManager: midiManager)
            guard let selectionID = newValue else {
                selectionDisplayName = nil
                return
            }
            if let displayName = endpoint(for: selectionID)?.displayName {
                selectionDisplayName = displayName
            }
        }
    }
    
    private func updateID(endpoints: [Endpoint]) {
        guard let updatedDetails = updatedID(endpoints: endpoints) else {
            return
        }
        
        selectionDisplayName = updatedDetails.displayName
        // update ID in case it changed
        if selectionID != updatedDetails.id { selectionID = updatedDetails.id }
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
                let img = try? resampled
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

#endif
