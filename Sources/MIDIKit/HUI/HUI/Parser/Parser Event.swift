//
//  Parser Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.HUI.Parser {
    
    /// HUI Parser Event
    public enum Event: Hashable {
        
        case pingReceived
        
        case levelMeters(channelStrip: Int,
                         side: MIDI.HUI.Surface.State.StereoLevelMeter.Side,
                         level: Int)
        
        case faderLevel(channelStrip: Int,
                        level: MIDI.UInt14)
        
        case vPot(channelStrip: Int,
                  value: MIDI.UInt7)
        
        case largeDisplayText(components: [String])
        
        case timeDisplayText(components: [String])
        
        case selectAssignText(text: String)
        
        case channelName(channelStrip: Int,
                         text: String)
        
        case `switch`(zone: MIDI.Byte,
                      port: MIDI.UInt4,
                      state: Bool)
        
    }
    
}
