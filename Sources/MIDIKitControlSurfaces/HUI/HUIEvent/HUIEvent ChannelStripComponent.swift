//
//  HUIEvent ChannelStripComponent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUIEvent {
    /// A discrete component of a HUI channel strip and its state change.
    public enum ChannelStripComponent: Equatable, Hashable {
        case levelMeter(side: HUISurface.State.StereoLevelMeter.Side, level: Int)
        case recordReady(state: Bool)
        case insert(state: Bool)
        case vPotSelect(state: Bool)
        case vPot(delta: UInt7)
        case auto(state: Bool)
        case solo(state: Bool)
        case mute(state: Bool)
        case nameTextDisplay(text: HUISmallDisplayString)
        case select(state: Bool)
        case faderTouched(state: Bool)
        case faderLevel(level: UInt14)
    }
}
