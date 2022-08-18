//
//  HUISurface Event ChannelStripComponent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension HUISurface.Event {
    /// A discrete component of a HUI channel strip and its state/value.
    public enum ChannelStripComponent: Equatable, Hashable {
        case levelMeter(side: HUISurface.State.StereoLevelMeter.Side, level: Int)
        case recordReady(Bool)
        case insert(Bool)
        case vPotSelect(Bool)
        case vPot(UInt7)
        case auto(Bool)
        case solo(Bool)
        case mute(Bool)
        case nameTextDisplay(String)
        case select(Bool)
        case faderTouched(Bool)
        case faderLevel(UInt14)
    }
}
