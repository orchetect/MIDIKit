//
//  DetailsContent.swift
//  MIDISystemInfo
//
//  Created by Steffan Andrews on 2023-11-10.
//

import MIDIKitIO
import SwiftUI

protocol DetailsContent where Self: View {
    var object: AnyMIDIIOObject? { get set }
    var showAll: Bool { get set }
    
    var properties: [Property] { get nonmutating set }
    var selection: Set<Property.ID> { get set }
}

extension DetailsContent {
    func refreshProperties() {
        guard let object else { return }
        
        properties = object.propertyStringValues(relevantOnly: !showAll)
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
