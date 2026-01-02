//
//  DetailsContent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

protocol DetailsContent where Self: View {
    var object: AnyMIDIIOObject { get set }
    var isRelevantPropertiesOnlyShown: Bool { get set }
    
    var properties: [Property] { get nonmutating set }
    var selection: Set<Property.ID> { get set }
    
    init(object: AnyMIDIIOObject, isRelevantPropertiesOnlyShown: Binding<Bool>)
}

extension DetailsContent {
    func refreshProperties() {
        properties = object.propertyStringValues(relevantOnly: isRelevantPropertiesOnlyShown)
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
        
        let provider = NSItemProvider(object: str as NSString)
        return [provider]
    }
}
