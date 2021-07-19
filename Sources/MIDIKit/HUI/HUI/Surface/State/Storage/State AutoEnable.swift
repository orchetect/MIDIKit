//
//  State AutoEnable.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the Auto Enable section
    public struct AutoEnable: Equatable, Hashable {
        
        public var fader = false
        public var pan = false
        public var plugin = false
        public var mute = false
        public var send = false
        public var sendMute = false
        
    }
    
}

extension MIDI.HUI.Surface.State.AutoEnable: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter.AutoEnable

    public func state(of param: Enum) -> Bool {
        
        switch param {
        
        case .fader:     return fader
        case .pan:       return pan
        case .plugin:    return plugin
        case .mute:      return mute
        case .send:      return send
        case .sendMute:  return sendMute
        
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        
        case .fader:     fader = state
        case .pan:       pan = state
        case .plugin:    plugin = state
        case .mute:      mute = state
        case .send:      send = state
        case .sendMute:  sendMute = state
        
        }
        
    }
    
}
