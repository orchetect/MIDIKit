//
//  LegacyDetailsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import MIDIKit
import SwiftUI

/// Legacy details view for systems prior to macOS 12 / iOS 16.
struct LegacyDetailsView: View, DetailsContent {
    public var object: AnyMIDIIOObject?
    @Binding public var showAll: Bool
    
    @State var properties: [Property] = []
    @State var selection: Set<Property.ID> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            List(selection: $selection) {
                Section {
                    ForEach(properties) {
                        Row(property: $0).tag($0)
                    }
                } header: {
                    Row(property: Property(key: "Property", value: "Value"))
                        .font(.headline)
                } footer: {
                    // empty
                }
            }
            #if os(macOS)
            .onCopyCommand {
                selectedItemsProviders()
            }
            #endif
        }
        .onAppear {
            refreshProperties()
        }
        .onReceive(Just(showAll)) { _ in // workaround since we can't use onChange {}
            refreshProperties()
        }
    }
}

extension LegacyDetailsView {
    private struct Row: View, Identifiable {
        let property: Property
        
        var id: Property.ID { property.id }
        
        var body: some View {
            HStack(alignment: .top) {
                Text(property.key)
                    .frame(width: 220, alignment: .leading)
                Text(property.value)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
