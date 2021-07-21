//
//  State StatusAndGroup.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the Status/Group section
    public struct StatusAndGroup: Equatable, Hashable {
        
        public var auto = false
        public var monitor = false
        public var phase = false
        public var group = false
        public var create = false
        public var suspend = false
        
    }
    
}

extension MIDI.HUI.Surface.State.StatusAndGroup: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter.StatusAndGroup

    public func state(of param: Enum) -> Bool {
        
        switch param {
        case .auto:     return auto
        case .monitor:  return monitor
        case .phase:    return phase
        case .group:    return group
        case .create:   return create
        case .suspend:  return suspend
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        case .auto:     auto = state
        case .monitor:  monitor = state
        case .phase:    phase = state
        case .group:    group = state
        case .create:   create = state
        case .suspend:  suspend = state
        }
        
    }
    
}
