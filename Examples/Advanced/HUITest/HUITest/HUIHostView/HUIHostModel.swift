//
//  HUIHostModel.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitControlSurfaces

/// Host model. Can contain one or more banks.
/// Each bank corresponds to an entire HUI device (remote control surface).
@MainActor @Observable class HUIHostModel {
    public var bank0 = Bank()
}

extension HUIHostModel {
    @MainActor @Observable class Bank {
        public var channel0: ChannelStrip = .init()
        public var channel1: ChannelStrip = .init()
        public var channel2: ChannelStrip = .init()
        public var channel3: ChannelStrip = .init()
        public var channel4: ChannelStrip = .init()
        public var channel5: ChannelStrip = .init()
        public var channel6: ChannelStrip = .init()
        public var channel7: ChannelStrip = .init()
    }
}

extension HUIHostModel.Bank {
    @MainActor @Observable class ChannelStrip {
        public var pan: Float = 0.5
        public var vPotLowerLED: Bool = false
        public var solo: Bool = false
        public var mute: Bool = false
        public var name: String = ""
        public var selected: Bool = false
        public var faderTouched: Bool = false
        public var faderLevel: Float = 0.0
    }
}
