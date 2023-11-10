//
//  OtherInputsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

struct OtherInputsView<DetailsContent: View>: View {
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    
    let detailsContent: (
        _ object: AnyMIDIIOObject?,
        _ showAllBinding: Binding<Bool>
    ) -> DetailsContent
    
    var body: some View {
        Section(header: Text("Other Inputs")) {
            ForEach(otherInputs) { item in
                NavigationLink(destination: detailsView(item: item)) {
                    ItemIcon(item: item.asAnyMIDIIOObject(), default: Text("🎵"))
                    Text("\(item.name)")
                }
            }
        }
    }
    
    private func detailsView(item: MIDIInputEndpoint) -> some View {
        DetailsView(
            object: item.asAnyMIDIIOObject(),
            detailsContent: detailsContent
        )
    }
    
    private var otherInputs: [MIDIInputEndpoint] {
        // filter out endpoints that have an entity because
        // they are already being displayed in the Devices tree
        midiManager.observableEndpoints.inputs.sortedByName()
            .filter { $0.entity == nil }
    }
}
