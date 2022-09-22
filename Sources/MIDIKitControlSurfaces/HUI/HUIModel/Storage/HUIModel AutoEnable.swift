//
//  HUIModel AutoEnable.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIModel {
    /// State storage representing the Auto Enable section.
    public struct AutoEnable: Equatable, Hashable {
        public var fader = false
        public var pan = false
        public var plugin = false
        public var mute = false
        public var send = false
        public var sendMute = false
    }
}

extension HUIModel.AutoEnable: HUISurfaceStateProtocol {
    public typealias Switch = HUISwitch.AutoEnable

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .fader:     return fader
        case .pan:       return pan
        case .plugin:    return plugin
        case .mute:      return mute
        case .send:      return send
        case .sendMute:  return sendMute
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .fader:     fader = state
        case .pan:       pan = state
        case .plugin:    plugin = state
        case .mute:      mute = state
        case .send:      send = state
        case .sendMute:  sendMute = state
        }
    }
}
