//
//  State AutoMode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the Auto Mode section
    public struct AutoMode: Equatable, Hashable {
        
        public var read = false
        public var latch = false
        public var trim = false
        public var touch = false
        public var write = false
        public var off = false
        
    }
    
}

extension MIDI.HUI.Surface.State.AutoMode: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter.AutoMode

    public func state(of param: Enum) -> Bool {
        
        switch param {
        case .read:   return read
        case .latch:  return latch
        case .trim:   return trim
        case .touch:  return touch
        case .write:  return write
        case .off:    return off
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        case .read:   read = state
        case .latch:  latch = state
        case .trim:   trim = state
        case .touch:  touch = state
        case .write:  write = state
        case .off:    off = state
        }
        
    }
    
}
