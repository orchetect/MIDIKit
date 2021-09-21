//
//  Event Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Returns the event's channel, if one is associated with it.
    public var channel: MIDI.UInt4? {
        
        switch self {
        case .noteOn(let event):
            return event.channel
        
        case .noteOff(let event):
            return event.channel
        
        case .polyAftertouch(let event):
            return event.channel
        
        case .cc(let event):
            return event.channel
        
        case .programChange(let event):
            return event.channel
        
        case .chanAftertouch(let event):
            return event.channel
        
        case .pitchBend(let event):
            return event.channel
            
        default:
            return nil
            
        }
        
    }
    
}
