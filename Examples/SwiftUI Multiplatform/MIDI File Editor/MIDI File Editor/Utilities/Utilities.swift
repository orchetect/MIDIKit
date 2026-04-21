//
//  Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension RandomAccessCollection where Element: Identifiable {
    func index(ofID id: Element.ID) -> Index? {
        firstIndex(where: { $0.id == id })
    }
    
    subscript(id: Element.ID) -> Element? {
        first(where: { $0.id == id })
    }
    
    func indexAfterOrBefore(index i: Index) -> Index? {
        if let afterIndex = index(i, offsetBy: 1, limitedBy: endIndex),
           indices.contains(afterIndex)
        {
            return afterIndex
        }
        
        if let beforeIndex = index(i, offsetBy: -1, limitedBy: startIndex),
           indices.contains(beforeIndex)
        {
            return beforeIndex
        }
        
        return nil
    }
    
    func idAfterOrBefore(id: Element.ID) -> Element.ID? {
        guard let index = index(ofID: id),
              let newIndex = indexAfterOrBefore(index: index)
        else { return nil }
        
        return self[newIndex].id
    }
}
