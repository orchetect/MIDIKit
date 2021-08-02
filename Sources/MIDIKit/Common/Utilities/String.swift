//
//  String.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension String {
    
    /// Wraps a string with double-quotes (`"`)
    @inlinable internal var quoted: Self {
        
        "\"\(self)\""
        
    }
    
}
