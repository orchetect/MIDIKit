//
//  MIDIInputsList.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import MIDIKitIO
import SwiftUI

/// SwiftUI `List` view for selecting MIDI input endpoints.
///
/// This view requires that an <doc://MIDIKitUI/MIDIKitIO/ObservableMIDIManager> instance exists in the environment.
///
/// ```swift
/// MIDIInputsList( ... )
///     .environment(midiManager)
/// ```
///
/// Optionally supply a tag to auto-update an output connection in MIDIManager.
///
/// ```swift
/// MIDIInputsList( ... )
///     .environment(midiManager)
///     .updatingOutputConnection(withTag: "MyConnection")
/// ```
@available(macOS 14.0, iOS 17.0, *)
public struct MIDIInputsList: View, _MIDIInputsSelectable {
    @Environment(ObservableMIDIManager.self) private var midiManager
    
    @Binding private var selectionID: MIDIIdentifier?
    @Binding private var selectionDisplayName: String?
    private var showIcons: Bool
    private var hideOwned: Bool
    
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
            endpoints: midiManager.endpoints.inputs,
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

#endif
