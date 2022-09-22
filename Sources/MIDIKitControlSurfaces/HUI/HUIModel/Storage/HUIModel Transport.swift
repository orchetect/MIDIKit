//
//  HUIModel Transport.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUIModel {
    /// State storage representing the Transport section.
    public struct Transport: Equatable, Hashable {
        public var rewind = false
        public var stop = false
        public var play = false
        public var fastFwd = false
        public var record = false
        
        public var talkback = false
        
        public var punch_audition = false
        public var punch_pre = false
        public var punch_in = false
        public var punch_out = false
        public var punch_post = false
        public var rtz = false
        public var end = false
        public var online = false
        public var loop = false
        public var quickPunch = false
    }
}

extension HUIModel.Transport: HUISurfaceStateProtocol {
    public typealias Switch = HUISwitch.Transport

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .talkback:        return talkback
        case .rewind:          return rewind
        case .fastFwd:         return fastFwd
        case .stop:            return stop
        case .play:            return play
        case .record:          return record
        case .punchAudition:   return punch_audition
        case .punchPre:        return punch_pre
        case .punchIn:         return punch_in
        case .punchOut:        return punch_out
        case .punchPost:       return punch_post
        case .rtz:             return rtz
        case .end:             return end
        case .online:          return online
        case .loop:            return loop
        case .quickPunch:      return quickPunch
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .talkback:        talkback = state
        case .rewind:          rewind = state
        case .fastFwd:         fastFwd = state
        case .stop:            stop = state
        case .play:            play = state
        case .record:          record = state
        case .punchAudition:   punch_audition = state
        case .punchPre:        punch_pre = state
        case .punchIn:         punch_in = state
        case .punchOut:        punch_out = state
        case .punchPost:       punch_post = state
        case .rtz:             rtz = state
        case .end:             end = state
        case .online:          online = state
        case .loop:            loop = state
        case .quickPunch:      quickPunch = state
        }
    }
}
