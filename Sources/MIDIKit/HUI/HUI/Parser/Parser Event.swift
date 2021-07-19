//
//  Parser Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.HUI.Parser {
    
    /// HUI Parser Event
    public enum Event: Hashable {
        
        case pingReceived
        
        case levelMeters(channel: MIDI.UInt4,
                         side: MIDI.HUI.Surface.State.StereoLevelMeter.Side,
                         level: Int)
        
        case faderLevel(channel: MIDI.UInt4,
                        level: Int)
        
        case vPot(channel: MIDI.UInt4,
                  value: Int)
        
        case largeDisplayText(components: [String])
        
        case timeDisplayText(components: [String])
        
        case selectAssignText(text: String)
        
        case channelText(channel: MIDI.UInt4,
                         text: String)
        
        case `switch`(zone: MIDI.Byte,
                      port: MIDI.UInt4,
                      state: Bool)
        
    }
    
}
