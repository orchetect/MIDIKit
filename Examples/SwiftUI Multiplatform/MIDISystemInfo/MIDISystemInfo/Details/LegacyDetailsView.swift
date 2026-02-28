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
    @Binding public var isRelevantPropertiesOnlyShown: Bool
    
    @State var properties: [Property] = []
    @State var selection: Set<Property.ID> = []
    
    init(object: AnyMIDIIOObject, isRelevantPropertiesOnlyShown: Binding<Bool>) {
        self.object = object
        _isRelevantPropertiesOnlyShown = isRelevantPropertiesOnlyShown
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            List(selection: $selection) {
                Section {
                    ForEach(properties) {
                        Row(property: $0).tag($0)
                    }
                } header: {
                    Row(property: Property(key: "Property", value: "Value", isError: false))
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
        .onReceive(Just(isRelevantPropertiesOnlyShown)) { _ in // workaround since we can't use `onChange {}` on macOS 10.15
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
                    .frame(width: 220, alignment: .leading)
                HStack {
                    if property.isError {
                        if #available(macOS 11.0, iOS 13.0, *) {
                            Image(systemName: "exclamationmark.triangle.fill")
                        } else {
                            Text("⚠️")
                        }
                    }
                    Text(property.value)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}
