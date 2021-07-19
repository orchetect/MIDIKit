//
//  State InternalUse.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the Parameter Edit section
    public struct InternalUse: Equatable, Hashable {
        
        public var footswitchRelay1 = false
        public var footswitchRelay2 = false
        public var click = false
        public var beep = false
        
    }
    
}

extension MIDI.HUI.Surface.State.InternalUse: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter.InternalUse

    public func state(of param: Enum) -> Bool {
        
        switch param {
        
        case .footswitchRelay1:  return footswitchRelay1
        case .footswitchRelay2:  return footswitchRelay2
        case .click:             return click
        case .beep:              return beep
            
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        
        case .footswitchRelay1:  footswitchRelay1 = state
        case .footswitchRelay2:  footswitchRelay2 = state
        case .click:             click = state
        case .beep:              beep = state
        
        }
        
    }
    
}
