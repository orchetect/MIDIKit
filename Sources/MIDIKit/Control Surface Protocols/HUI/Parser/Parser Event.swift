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

extension MIDI.HUI.Parser.Event: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        case .pingReceived:
            return ".pingReceived"
        
        case .levelMeters(channelStrip: let channelStrip,
                          side: let side,
                          level: let level):
            return ".levelMeters(channelStrip: \(channelStrip), side: \(side), level: \(level))"
            
        case .faderLevel(channelStrip: let channelStrip,
                         level: let level):
            return ".faderLevel(channelStrip: \(channelStrip), level: \(level))"
            
        case .vPot(channelStrip: let channelStrip,
                   value: let value):
            return ".vPot(channelStrip: \(channelStrip), value: \(value))"
            
        case .largeDisplayText(components: let components):
            return ".largeDisplayText(components: \(components))"
            
        case .timeDisplayText(components: let components):
            return ".timeDisplayText(components: \(components))"
            
        case .selectAssignText(text: let text):
            return ".selectAssignText(text: \(text))"
            
        case .channelName(channelStrip: let channelStrip,
                          text: let text):
            return ".channelName(channelStrip: \(channelStrip), text: \(text))"
            
        case .switch(zone: let zone,
                     port: let port,
                     state: let state):
            return ".switch(zone: \(zone), port: \(port), state: \(state ? "on" : "off"))"
            
        }
        
    }
    
}
