//
//  State Edit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the Edit section
    public struct Edit: Equatable, Hashable {
        
        public var capture = false
        public var cut = false
        public var paste = false
        public var separate = false
        public var copy = false
        public var delete = false
        
    }
    
}

extension MIDI.HUI.Surface.State.Edit: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter.Edit

    public func state(of param: Enum) -> Bool {
        
        switch param {
        
        case .capture:  return capture
        case .cut:      return cut
        case .paste:    return paste
        case .separate: return separate
        case .copy:     return copy
        case .delete:   return delete
            
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        
        case .capture:  capture = state
        case .cut:      cut = state
        case .paste:    paste = state
        case .separate: separate = state
        case .copy:     copy = state
        case .delete:   delete = state
        
        }
        
    }
    
}
