//
//  HUISurfaceModelState Transport.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing the Transport section.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class Transport {
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

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.Transport: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.Transport
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .talkback:      talkback
        case .rewind:        rewind
        case .fastFwd:       fastFwd
        case .stop:          stop
        case .play:          play
        case .record:        record
        case .punchAudition: punch_audition
        case .punchPre:      punch_pre
        case .punchIn:       punch_in
        case .punchOut:      punch_out
        case .punchPost:     punch_post
        case .rtz:           rtz
        case .end:           end
        case .online:        online
        case .loop:          loop
        case .quickPunch:    quickPunch
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .talkback:      talkback = state
        case .rewind:        rewind = state
        case .fastFwd:       fastFwd = state
        case .stop:          stop = state
        case .play:          play = state
        case .record:        record = state
        case .punchAudition: punch_audition = state
        case .punchPre:      punch_pre = state
        case .punchIn:       punch_in = state
        case .punchOut:      punch_out = state
        case .punchPost:     punch_post = state
        case .rtz:           rtz = state
        case .end:           end = state
        case .online:        online = state
        case .loop:          loop = state
        case .quickPunch:    quickPunch = state
        }
    }
}
