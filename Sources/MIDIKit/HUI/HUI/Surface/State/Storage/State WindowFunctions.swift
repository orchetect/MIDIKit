//
//  State WindowFunctions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing Window Functions
    public struct WindowFunctions: Equatable, Hashable {
        
        public var mix = false
        public var edit = false
        public var transport = false
        public var memLoc = false
        public var status = false
        public var alt = false
        
    }
    
}

extension MIDI.HUI.Surface.State.WindowFunctions: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter.WindowFunction

    public func state(of param: Enum) -> Bool {
        
        switch param {
        case .mix:        return mix
        case .edit:       return edit
        case .transport:  return transport
        case .memLoc:     return memLoc
        case .status:     return status
        case .alt:        return alt
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        case .mix:        mix = state
        case .edit:       edit = state
        case .transport:  transport = state
        case .memLoc:     memLoc = state
        case .status:     status = state
        case .alt:        alt = state
        }
        
    }
    
}
