//
//  Parser Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.HUI.Parser {
    
    /// HUI Parser Event
    public enum Event: Hashable {
        
        case pingReceived
        
        case levelMeters(channel: Int, leftSide: Bool, level: Int)
        case faderLevel(channel: Int, level: Int)
        case vPot(channel: Int, value: Int)
        
        case largeDisplayText(components: [String])
        case timeDisplayText(components: [String])
        case selectAssignText(text: String)
        case channelText(text: String, channel: Int)
        
        case `switch`(zone: Int, port: Int, state: Bool)
        
    }
    
}
