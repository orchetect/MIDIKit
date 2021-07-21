//
//  State FunctionKey.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the Function Key section
    public struct FunctionKey: Equatable, Hashable {
        
        public var f1 = false
        public var f2 = false
        public var f3 = false
        public var f4 = false
        public var f5 = false
        public var f6 = false
        public var f7 = false
        public var f8OrEsc = false
        
    }
    
}

extension MIDI.HUI.Surface.State.FunctionKey: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter.FunctionKey

    public func state(of param: Enum) -> Bool {
        
        switch param {
        case .f1:         return f1
        case .f2:         return f2
        case .f3:         return f3
        case .f4:         return f4
        case .f5:         return f5
        case .f6:         return f6
        case .f7:         return f7
        case .f8OrEsc:    return f8OrEsc
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        case .f1:         f1 = state
        case .f2:         f2 = state
        case .f3:         f3 = state
        case .f4:         f4 = state
        case .f5:         f5 = state
        case .f6:         f6 = state
        case .f7:         f7 = state
        case .f8OrEsc:    f8OrEsc = state
        }
        
    }
    
}
