//
//  TableDetailsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

/// Modern details view.
@available(macOS 12.0, iOS 16.0, *)
struct TableDetailsView: View, DetailsContent {
    #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var isCompact: Bool { horizontalSizeClass == .compact }
    #else
    private let isCompact = false
    #endif
    
    public var object: AnyMIDIIOObject?
    @Binding public var showAll: Bool
    
    @State var properties: [Property] = []
    @State var selection: Set<Property.ID> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            table
            .onAppear {
                refreshProperties()
            }
            .onChange(of: showAll) { _ in
                refreshProperties()
            }
            #if os(macOS)
            .tableStyle(.inset(alternatesRowBackgrounds: true))
            .onCopyCommand {
                selectedItemsProviders()
            }
            #elseif os(iOS)
            .tableStyle(InsetTableStyle())
            #endif
        }
    }
    
    @ViewBuilder
    private var table: some View {
        if isCompact {
            Table(properties, selection: $selection) {
                TableColumn("Property") { property in
                    HStack {
                        Text(property.key)
                        Spacer()
                        Text(property.value)
                            .foregroundColor(.secondary)
                    }
                }
            }
        } else {
            Table(properties, selection: $selection) {
                TableColumn("Property", value: \.key)
                    .width(min: 50, ideal: 120, max: 250)
                TableColumn("Value", value: \.value)
            }
        }
    }
}
