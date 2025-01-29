//
//  HUISurfaceModelState AutoEnable.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the Auto Enable section.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class AutoEnable {
        public var fader = false
        public var pan = false
        public var plugin = false
        public var mute = false
        public var send = false
        public var sendMute = false
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.AutoEnable: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.AutoEnable
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .fader:    return fader
        case .pan:      return pan
        case .plugin:   return plugin
        case .mute:     return mute
        case .send:     return send
        case .sendMute: return sendMute
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .fader:    fader = state
        case .pan:      pan = state
        case .plugin:   plugin = state
        case .mute:     mute = state
        case .send:     send = state
        case .sendMute: sendMute = state
        }
    }
}
