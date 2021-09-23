//
//  Event Filter Group.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Filter

extension Collection where Element == MIDI.Event {
    
    /// Filter events by UMP group.
    @inlinable public func filter(group: MIDI.UInt4) -> [Element] {
        
        filter { $0.group == group }
        
    }
    
    /// Filter events by UMP groups.
    @inlinable public func filter(groups: [MIDI.UInt4]) -> [Element] {
        
        filter { groups.contains($0.group) }
        
    }
    
}

// MARK: - Drop

extension Collection where Element == MIDI.Event {
    
    /// Drop all events with the specified UMP group.
    @inlinable public func drop(group: MIDI.UInt4) -> [Element] {
        
        filter { $0.group != group }
        
    }
    
    /// Drop all events with any of the specified UMP groups.
    @inlinable public func drop(groups: [MIDI.UInt4]) -> [Element] {
        
        filter { !groups.contains($0.group) }
        
    }
    
}
