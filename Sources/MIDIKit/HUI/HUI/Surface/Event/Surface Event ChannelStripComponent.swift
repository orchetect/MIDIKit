//
//  Surface Event ChannelStripComponent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.HUI.Surface.Event {
    
    /// A discrete component of a HUI channel strip and its state/value.
    public enum ChannelStripComponent: Equatable, Hashable {
        
        case levelMeter(side: MIDI.HUI.Surface.State.StereoLevelMeter.Side, level: Int)
        case recordReady(Bool)
        case insert(Bool)
        case vPotSelect(Bool)
        case vPot(MIDI.UInt7)
        case auto(Bool)
        case solo(Bool)
        case mute(Bool)
        case nameTextDisplay(String)
        case select(Bool)
        case faderTouched(Bool)
        case faderLevel(MIDI.UInt14)
        
    }
    
}
