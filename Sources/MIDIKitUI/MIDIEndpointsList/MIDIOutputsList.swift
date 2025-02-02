//
//  MIDIOutputsList.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import MIDIKitIO
import SwiftUI

/// SwiftUI `List` view for selecting MIDI output endpoints.
///
/// This view requires that an <doc://MIDIKitUI/MIDIKitIO/ObservableMIDIManager> instance exists in the environment.
///
/// ```swift
/// MIDIOutputsList( ... )
///     .environment(midiManager)
/// ```
///
/// Optionally supply a tag to auto-update an input connection in MIDIManager.
///
/// ```swift
/// MIDIOutputsList( ... )
///     .environment(midiManager)
///     .updatingInputConnection(withTag: "MyConnection")
/// ```
@available(macOS 14.0, iOS 17.0, *)
public struct MIDIOutputsList: View, _MIDIOutputsSelectable {
    @Environment(ObservableMIDIManager.self) private var midiManager
    
    @Binding private var selectionID: MIDIIdentifier?
    @Binding private var selectionDisplayName: String?
    private var showIcons: Bool
    private var hideOwned: Bool
    
    var updatingInputConnectionWithTag: String?
    
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
            endpoints: midiManager.endpoints.outputs,
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
        updateInputConnection(
            selectedUniqueID: id,
            selectedDisplayName: selectionDisplayName,
            midiManager: midiManager
        )
    }
}

#endif
