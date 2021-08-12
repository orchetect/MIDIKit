//
//  Event Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// Returns the event's channel, if one is associated with it.
    public var channel: MIDI.UInt4? {
        
        switch self {
        case .noteOn(note: _, velocity: _, channel: let channel, group: _):
            return channel
        
        case .noteOff(note: _, velocity: _, channel: let channel, group: _):
            return channel
        
        case .polyAftertouch(note: _, pressure: _, channel: let channel, group: _):
            return channel
        
        case .cc(controller: _, value: _, channel: let channel, group: _):
            return channel
        
        case .programChange(program: _, channel: let channel, group: _):
            return channel
        
        case .chanAftertouch(pressure: _, channel: let channel, group: _):
            return channel
        
        case .pitchBend(value: _, channel: let channel, group: _):
            return channel
            
        default:
            return nil
            
        }
        
    }
    
}
