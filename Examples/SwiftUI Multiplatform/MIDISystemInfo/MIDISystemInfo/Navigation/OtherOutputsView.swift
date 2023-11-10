//
//  OtherOutputsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

struct OtherOutputsView<DetailsContent: View>: View {
    @EnvironmentObject private var midiManager: MIDIManager
    
    let detailsContent: (
        _ object: AnyMIDIIOObject?,
        _ showAllBinding: Binding<Bool>
    ) -> DetailsContent
    
    var body: some View {
        Section(header: Text("Other Outputs")) {
            ForEach(otherOutputs) { item in
                NavigationLink(destination: detailsView(item: item)) {
                    ItemIcon(item: item.asAnyMIDIIOObject(), default: Text("🎵"))
                    Text("\(item.name)")
                }
            }
        }
    }
    
    private func detailsView(item: MIDIOutputEndpoint) -> some View {
        DetailsView(
            object: item.asAnyMIDIIOObject(),
            detailsContent: detailsContent
        )
    }
    
    private var otherOutputs: [MIDIOutputEndpoint] {
        // filter out endpoints that have an entity because
        // they are already being displayed in the Devices tree
        midiManager.endpoints.outputs.sortedByName()
            .filter { $0.entity == nil }
    }
}
