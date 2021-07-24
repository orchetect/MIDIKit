//
//  Event Filter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    
    /// A MIDI event filter definition.
    public enum Filter {
        
        #warning("> add inline docs for each enum case")
        
        // filter
        
        case filterChannelVoice
        case filterSystemExclusive
        case filterSystemCommon
        case filterSystemRealTime
        
        case filterChannelVoiceChannel(channel: MIDI.UInt4)
        case filterChannelVoiceChannels(channels: [MIDI.UInt4])
        case filterChannel(channel: MIDI.UInt4)
        case filterChannels(channels: [MIDI.UInt4])
        
        // filter out
        
        case filterOutChannelVoice
        case filterOutSystemExclusive
        case filterOutSystemCommon
        case filterOutSystemRealTime
        
        case filterOutChannelVoiceChannel(channel: MIDI.UInt4)
        case filterOutChannelVoiceChannels(channels: [MIDI.UInt4])
        case filterOutChannel(channel: MIDI.UInt4)
        case filterOutChannels(channels: [MIDI.UInt4])
        
    }
    
}

extension MIDI.Event.Filter {
    
    /// Process MIDI events using this filter.
    public func apply(to events: [MIDI.Event]) -> [MIDI.Event] {
        
        switch self {
        
        // filter
        
        case .filterChannelVoice:
            return events.filterChannelVoice()
            
        case .filterSystemExclusive:
            return events.filterSystemExclusive()
            
        case .filterSystemCommon:
            return events.filterSystemCommon()
            
        case .filterSystemRealTime:
            return events.filterSystemRealTime()
            
        case .filterChannelVoiceChannel(channel: let channel):
            return events.filterChannelVoice(channel: channel)
            
        case .filterChannelVoiceChannels(channels: let channels):
            return events.filterChannelVoice(channels: channels)
            
        case .filterChannel(channel: let channel):
            return events.filter(channel: channel)
            
        case .filterChannels(channels: let channels):
            return events.filter(channels: channels)
            
        // filter out

        case .filterOutChannelVoice:
            return events.filterOutChannelVoice()
            
        case .filterOutSystemExclusive:
            return events.filterOutSystemExclusive()
            
        case .filterOutSystemCommon:
            return events.filterOutSystemCommon()
            
        case .filterOutSystemRealTime:
            return events.filterOutSystemRealTime()
            
        case .filterOutChannelVoiceChannel(channel: let channel):
            #warning("> finish this")
            return [] //events.filterOutChannelVoice(channel: channel)
            
        case .filterOutChannelVoiceChannels(channels: let channels):
            #warning("> finish this")
            return [] //events.filterOutChannelVoice(channels: channels)
            
        case .filterOutChannel(channel: let channel):
            return events.filterOut(channel: channel)
            
        case .filterOutChannels(channels: let channels):
            return events.filterOut(channels: channels)
            
        }
        
    }
    
}
