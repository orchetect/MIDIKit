//
//  MIDIOutputsPicker.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import MIDIKitIO
import SwiftUI

/// SwiftUI `Picker` view for selecting MIDI output endpoints.
///
/// This view requires that an <doc://MIDIKitUI/MIDIKitIO/ObservableMIDIManager> instance exists in the environment.
///
/// ```swift
/// MIDIOutputsPicker( ... )
///     .environment(midiManager)
/// ```
///
/// Optionally supply a tag to auto-update an input connection in MIDIManager.
///
/// ```swift
/// MIDIOutputsPicker( ... )
///     .updatingInputConnection(withTag: "MyConnection")
/// ```
@available(macOS 14.0, iOS 17.0, *)
public struct MIDIOutputsPicker: View, _MIDIOutputsSelectable {
    @Environment(ObservableMIDIManager.self) private var midiManager
    
    private var title: String
    @Binding private var selectionID: MIDIIdentifier?
    @Binding private var selectionDisplayName: String?
    private var showIcons: Bool
    private var hideOwned: Bool
    
    var updatingInputConnectionWithTag: String?
    
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
        updateInputConnection(selectedUniqueID: id,
                              selectedDisplayName: selectionDisplayName,
                              midiManager: midiManager)
    }
}

#endif
