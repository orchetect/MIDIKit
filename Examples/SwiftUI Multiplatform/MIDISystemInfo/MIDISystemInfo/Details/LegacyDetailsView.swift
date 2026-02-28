//
//  LegacyDetailsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import MIDIKitIO
import SwiftUI

/// Legacy details view for systems prior to macOS 12 / iOS 16.
struct LegacyDetailsView: View, DetailsContent {
    public var object: AnyMIDIIOObject
    @Binding public var isOnlySetPropertiesShown: Bool
    
    @State var properties: [Property] = []
    @State var selection: Set<Property.ID> = []
    
    init(object: AnyMIDIIOObject, isRelevantPropertiesOnlyShown: Binding<Bool>) {
        self.object = object
        _isOnlySetPropertiesShown = isRelevantPropertiesOnlyShown
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            List(selection: $selection) {
                Section {
                    ForEach(properties) {
                        Row(property: $0).tag($0)
                    }
                } header: {
                    Row(property: Property(key: "Property", value: "Value", status: nil))
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
        .onReceive(Just(isOnlySetPropertiesShown)) { _ in // workaround since we can't use `onChange {}` on macOS 10.15
            withAnimation { refreshProperties() }
        }
    }
}

extension LegacyDetailsView {
    private struct Row: View, Identifiable {
        nonisolated let property: Property
        
        nonisolated var id: Property.ID { property.id }
        
        var body: some View {
            HStack(alignment: .top) {
                Text(property.key)
                    #if os(macOS)
                    .frame(width: 220, alignment: .leading)
                    #elseif os(iOS)
                    .frame(width: 150, alignment: .leading)
                    #endif
                
                if let status = property.status {
                    status.view
                }
                
                Text(property.value)
                    .foregroundColor(property.color)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
