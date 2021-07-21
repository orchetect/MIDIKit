//
//  State BankMove.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing bank and channel navigation
    public struct BankMove: Equatable, Hashable {
        
        public var channelLeft = false
        public var channelRight = false
        public var bankLeft = false
        public var bankRight = false
        
    }
    
}

extension MIDI.HUI.Surface.State.BankMove: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter.BankMove

    public func state(of param: Enum) -> Bool {
        
        switch param {
        case .channelLeft:   return channelLeft
        case .channelRight:  return channelRight
        case .bankLeft:      return bankLeft
        case .bankRight:     return bankRight
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        case .channelLeft:   channelLeft = state
        case .channelRight:  channelRight = state
        case .bankLeft:      bankLeft = state
        case .bankRight:     bankRight = state
        }
        
    }
    
}
