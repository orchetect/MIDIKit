//
//  OtherInputsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

extension ContentView {
    struct OtherInputsView: View {
        @EnvironmentObject private var midiManager: ObservableObjectMIDIManager
        
        @Binding var showRelevantProperties: Bool
        
        var body: some View {
            Section(header: Text("Other Inputs")) {
                ForEach(otherInputs) { item in
                    navLink(item: item)
                }
            }
        }
        
        private func navLink(item: MIDIInputEndpoint) -> some View {
            NavigationLink(destination: detailsView(item: item)) {
                HStack {
                    ItemIcon(item: item.asAnyMIDIIOObject(), default: Text("🎵"))
                    Text("\(item.name)")
                    Spacer()
                }
            }
        }
        
        private func detailsView(item: MIDIInputEndpoint) -> some View {
            DetailsView(
                object: item.asAnyMIDIIOObject(),
                isRelevantPropertiesOnlyShown: $showRelevantProperties
            )
        }
        
        private var otherInputs: [MIDIInputEndpoint] {
            // filter out endpoints that have an entity because
            // they are already being displayed in the Devices tree
            midiManager.endpoints.inputs.sortedByName()
                .filter { $0.entity == nil }
        }
    }
}
