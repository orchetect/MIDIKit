//
//  State ParameterEdit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the Parameter Edit section
    public struct ParameterEdit: Equatable, Hashable {
        
        public var assign = false
        public var compare = false
        public var bypass = false
        public var select1 = false
        public var select2 = false
        public var select3 = false
        public var select4 = false
        
        /// Toggle: Insert (off) / Param (on)
        public var insertOrParam = false
        
    }
    
}

extension MIDI.HUI.Surface.State.ParameterEdit: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter.ParameterEdit

    public func state(of param: Enum) -> Bool {
        
        switch param {
        case .assign:         return assign
        case .compare:        return compare
        case .bypass:         return bypass
        case .select1:        return select1
        case .select2:        return select2
        case .select3:        return select3
        case .select4:        return select4
        case .insertOrParam:  return insertOrParam
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        case .assign:         assign = state
        case .compare:        compare = state
        case .bypass:         bypass = state
        case .select1:        select1 = state
        case .select2:        select2 = state
        case .select3:        select3 = state
        case .select4:        select4 = state
        case .insertOrParam:  insertOrParam = state
        }
        
    }
    
}
