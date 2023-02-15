//
//  DetailsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Combine
import SwiftUI
import MIDIKit

// MARK: - Empty Details Views

struct EmptyDetailsView: View {
    var body: some View {
        VStack {
            if #available(macOS 11.0, *) {
                Image(systemName: "pianokeys")
                    .resizable()
                    .foregroundColor(.secondary)
                    .frame(width: 200, height: 200)
                Spacer().frame(height: 50)
            }
            Text("Make a selection from the sidebar.")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Surrogate Details View

struct DetailsView<Content: View>: View {
    let object: AnyMIDIIOObject?
    let detailsContent: (_ object: AnyMIDIIOObject?,
                         _ showAllBinding: Binding<Bool>) -> Content
    
    @State private var showAll: Bool = false
    
    var body: some View {
        if let unwrappedObject = object {
            detailsContent(unwrappedObject, $showAll)
            
            Group {
                if showAll {
                    Button("Show Relevant Properties") {
                        showAll.toggle()
                    }
                } else {
                    Button("Show All") {
                        showAll.toggle()
                    }
                }
            }
            .padding(.all, 10)
            
        } else {
            EmptyDetailsView()
        }
    }
}

// MARK: - Per-Platform Details Views

protocol DetailsContent where Self: View {
    var object: AnyMIDIIOObject? { get set }
    var showAll: Bool { get set }
    
    var properties: [Property] { get nonmutating set }
    var selection: Set<Property.ID> { get set }
}

struct Property: Identifiable, Hashable {
    let key: String
    let value: String
    
    var id: String { key }
}

extension DetailsContent {
    func refreshProperties() {
        guard let unwrappedObject = object else { return }
        properties = unwrappedObject.propertyStringValues(relevantOnly: !showAll)
            .map { Property(key: $0.key, value: $0.value) }
    }
    
    func selectedItemsProviders() -> [NSItemProvider] {
        let str: String
        
        switch selection.count {
        case 0:
            return []
            
        case 1: // single
            // just return value
            str = properties
                .first { $0.id == selection.first! }?
                .value ?? ""
            
        default: // multiple
            // return key/value pairs, one per line
            str = properties
                .filter { selection.contains($0.key) }
                .map { "\($0.key): \($0.value)" }
                .joined(separator: "\n")
        }
        
        let provider: NSItemProvider = .init(object: str as NSString)
        return [provider]
    }
}

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
    
    struct Row: View, Identifiable {
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

/// Modern details view.
@available(macOS 12.0, iOS 16.0, *)
struct TableDetailsView: View, DetailsContent {
    public var object: AnyMIDIIOObject?
    @Binding public var showAll: Bool
    
    @State var properties: [Property] = []
    @State var selection: Set<Property.ID> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Table(properties, selection: $selection) {
                TableColumn("Property", value: \.key).width(min: 50, ideal: 120, max: 250)
                TableColumn("Value", value: \.value)
            }
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
}
