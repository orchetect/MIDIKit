//
//  MIDIEndpointsList.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import MIDIKitIO
import SwiftUI

@available(macOS 11.0, iOS 14.0, *)
struct MIDIEndpointsList<Endpoint>: View, MIDIEndpointsSelectable
where Endpoint: MIDIEndpoint & Hashable & Identifiable, 
      Endpoint.ID == MIDIIdentifier 
{
    private weak var midiManager: ObservableMIDIManager?
    
    var endpoints: [Endpoint]
    var maskedFilter: MIDIEndpointMaskedFilter?
    @Binding var selectionID: MIDIIdentifier?
    @Binding var selectionDisplayName: String?
    let showIcons: Bool
    
    @State var ids: [MIDIIdentifier] = []
    
    init(
        endpoints: [Endpoint],
        maskedFilter: MIDIEndpointMaskedFilter?,
        selectionID: Binding<MIDIIdentifier?>,
        selectionDisplayName: Binding<String?>,
        showIcons: Bool,
        midiManager: ObservableMIDIManager?
    ) {
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
        List(selection: $selectionID) {
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
        
        self.selectionDisplayName = updatedDetails.displayName
        // update ID in case it changed
        if self.selectionID != updatedDetails.id { self.selectionID = updatedDetails.id }
    }
    
    private struct EndpointRow: View {
        let endpoint: Endpoint?
        @Binding var selectionDisplayName: String?
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
                ? selectionDisplayName ?? "Missing"
                : (selectionDisplayName ?? "") + " (Missing)"
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
///
/// Optionally supply a tag to auto-update an output connection in MIDIManager.
///
/// ```swift
/// MIDIInputsList( ... )
///     .updatingOutputConnection(withTag: "MyConnection")
/// ```
@available(macOS 11.0, iOS 14.0, *)
public struct MIDIInputsList: View, _MIDIInputsSelectable {
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    
    @Binding public var selectionID: MIDIIdentifier?
    @Binding public var selectionDisplayName: String?
    public var showIcons: Bool
    public var hideOwned: Bool
    
    internal var updatingOutputConnectionWithTag: String?
    
    public init(
        selectionID: Binding<MIDIIdentifier?>,
        selectionDisplayName: Binding<String?>,
        showIcons: Bool = true,
        hideOwned: Bool = false
    ) {
        _selectionID = selectionID
        _selectionDisplayName = selectionDisplayName
        self.showIcons = showIcons
        self.hideOwned = hideOwned
    }
    
    public var body: some View {
        MIDIEndpointsList<MIDIInputEndpoint>(
            endpoints: midiManager.observableEndpoints.inputs,
            maskedFilter: maskedFilter,
            selectionID: $selectionID,
            selectionDisplayName: $selectionDisplayName,
            showIcons: showIcons,
            midiManager: midiManager
        )
        .onAppear {
            updateOutputConnection(id: selectionID)
        }
        .onChange(of: selectionID) { newValue in
            updateOutputConnection(id: newValue)
        }
    }
    
    private var maskedFilter: MIDIEndpointMaskedFilter? {
        hideOwned ? .drop(.owned()) : nil
    }
    
    private func updateOutputConnection(id: MIDIIdentifier?) {
        updateOutputConnection(selectedUniqueID: id,
                               selectedDisplayName: selectionDisplayName,
                               midiManager: midiManager)
    }
}

/// SwiftUI `List` view for selecting MIDI output endpoints.
///
/// Optionally supply a tag to auto-update an input connection in MIDIManager.
///
/// ```swift
/// MIDIOutputsList( ... )
///     .updatingInputConnection(withTag: "MyConnection")
/// ```
@available(macOS 11.0, iOS 14.0, *)
public struct MIDIOutputsList: View, _MIDIOutputsSelectable {
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    
    @Binding public var selectionID: MIDIIdentifier?
    @Binding public var selectionDisplayName: String?
    public var showIcons: Bool
    public var hideOwned: Bool
    
    internal var updatingInputConnectionWithTag: String?
    
    public init(
        selectionID: Binding<MIDIIdentifier?>,
        selectionDisplayName: Binding<String?>,
        showIcons: Bool = true,
        hideOwned: Bool = false
    ) {
        _selectionID = selectionID
        _selectionDisplayName = selectionDisplayName
        self.showIcons = showIcons
        self.hideOwned = hideOwned
    }
    
    public var body: some View {
        MIDIEndpointsList<MIDIOutputEndpoint>(
            endpoints: midiManager.observableEndpoints.outputs,
            maskedFilter: maskedFilter,
            selectionID: $selectionID,
            selectionDisplayName: $selectionDisplayName,
            showIcons: showIcons,
            midiManager: midiManager
        )
        .onAppear {
            updateInputConnection(id: selectionID)
        }
        .onChange(of: selectionID) { newValue in
            updateInputConnection(id: newValue)
        }
    }
    
    private var maskedFilter: MIDIEndpointMaskedFilter? {
        hideOwned ? .drop(.owned()) : nil
    }
    
    private func updateInputConnection(id: MIDIIdentifier?) {
        updateInputConnection(selectedUniqueID: id,
                              selectedDisplayName: selectionDisplayName,
                              midiManager: midiManager)
    }
}

#endif
