//
//  FormDetailsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

/// Modern details view.
@available(macOS 13.0, iOS 16.0, *)
struct FormDetailsView: View, DetailsContent {
    public var object: AnyMIDIIOObject
    @Binding public var isRelevantPropertiesOnlyShown: Bool
    
    @State var properties: [Property] = []
    @State var selection: Set<Property.ID> = []
    
    init(object: AnyMIDIIOObject, isRelevantPropertiesOnlyShown: Binding<Bool>) {
        self.object = object
        _isRelevantPropertiesOnlyShown = isRelevantPropertiesOnlyShown
    }
    
    var body: some View {
        VStack {
            if let image = try? object.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 100)
                    .padding([.top], 20)
            }
            
            form
        }
        .onAppear {
            refreshProperties()
        }
        .onChange(of: isRelevantPropertiesOnlyShown) { _ in
            withAnimation { refreshProperties() }
        }
        #if os(macOS)
        .navigationSubtitle(object.name)
        #elseif os(iOS)
        .navigationTitle(object.name)
        #endif
    }
    
    @ViewBuilder
    private var form: some View {
        Form {
            ForEach(properties) { property in
                PropertyRowView(property: property)
            }
        }
        .formStyle(.grouped)
    }
    
    struct PropertyRowView: View {
        var property: Property
        
        var body: some View {
            LabeledContent(property.key, value: property.value)
        }
    }
}
