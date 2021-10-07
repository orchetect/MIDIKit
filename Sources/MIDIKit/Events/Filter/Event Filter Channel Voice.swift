//
//  Event Filter Channel Voice.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Metadata properties

extension MIDI.Event {
    
    /// Returns true if the event is a Channel Voice message.
    @inlinable
    public var isChannelVoice: Bool {
        
        switch self {
        case .noteOn,
             .noteOff,
             .noteCC,
             .notePitchBend,
             .notePressure,
             .noteManagement,
             .cc,
             .programChange,
             .pitchBend,
             .pressure:
            return true
            
        default:
            return false
        }
        
    }
    
    /// Returns true if the event is a Channel Voice message of a specific type.
    @inlinable
    public func isChannelVoice(ofType chanVoiceType: ChanVoiceType) -> Bool {
        
        switch self {
        case .noteOn         : return chanVoiceType == .noteOn
        case .noteOff        : return chanVoiceType == .noteOff
        case .noteCC         : return chanVoiceType == .noteCC
        case .notePitchBend  : return chanVoiceType == .notePitchBend
        case .notePressure   : return chanVoiceType == .notePressure
        case .noteManagement : return chanVoiceType == .noteManagement
        case .cc             : return chanVoiceType == .cc
        case .programChange  : return chanVoiceType == .programChange
        case .pitchBend      : return chanVoiceType == .pitchBend
        case .pressure       : return chanVoiceType == .pressure
        default              : return false
        }
        
    }
    
    /// Returns true if the event is a Channel Voice message of a specific type.
    @inlinable
    public func isChannelVoice(ofTypes chanVoiceTypes: Set<ChanVoiceType>) -> Bool {
        
        for eventType in chanVoiceTypes {
            if self.isChannelVoice(ofType: eventType) { return true }
        }
        
        return false
        
    }
    
}

// MARK: - Filter

extension Collection where Element == MIDI.Event {
    
    /// Filter Channel Voice events.
    @inlinable
    public func filter(chanVoice types: MIDI.Event.ChanVoiceTypes) -> [Element] {
        
        switch types {
        case .only:
            return filter { $0.isChannelVoice }
            
        case .onlyType(let specificType):
            return filter { $0.isChannelVoice(ofType: specificType) }
            
        case .onlyTypes(let specificTypes):
            return filter { $0.isChannelVoice(ofTypes: specificTypes) }
            
        case .onlyChannel(let channel):
            return filter { $0.channel == channel }
            
        case .onlyChannels(let channels):
            return filter {
                guard let channel = $0.channel else { return false }
                return channels.contains(channel)
            }
            
        case .onlyCC(let cc):
            return filter {
                guard case .cc(let event) = $0
                else { return false }
                
                return event.controller == cc
            }
            
        case .onlyCCs(let ccs):
            return filter {
                guard case .cc(let event) = $0
                else { return false }
                
                return ccs.contains(event.controller)
            }
            
        case .onlyNotesInRange(let noteRange):
            return filter {
                switch $0 {
                case .noteOn(let noteOn):
                    return noteRange.contains(noteOn.note)
                    
                case .noteOff(let noteOff):
                    return noteRange.contains(noteOff.note)
                    
                default:
                    return false
                }
            }
            
        case .onlyNotesInRanges(let noteRanges):
            return filter {
                switch $0 {
                case .noteOn(let noteOn):
                    for noteRange in noteRanges {
                        if noteRange.contains(noteOn.note) { return true }
                    }
                    return false
                    
                case .noteOff(let noteOff):
                    for noteRange in noteRanges {
                        if noteRange.contains(noteOff.note) { return true }
                    }
                    return false
                    
                default:
                    return false
                }
            }
            
        case .keepChannel(let channel):
            return filter {
                guard let _ = $0.channel else { return true }
                return $0.channel == channel
            }
            
        case .keepChannels(let channels):
            return filter {
                guard let channel = $0.channel else { return true }
                return channels.contains(channel)
            }
            
        case .keepType(let specificType):
            return filter {
                guard $0.isChannelVoice else { return true }
                return $0.isChannelVoice(ofType: specificType)
            }
            
        case .keepTypes(let specificTypes):
            return filter {
                guard $0.isChannelVoice else { return true }
                return $0.isChannelVoice(ofTypes: specificTypes)
            }
            
        case .keepCC(let cc):
            return filter {
                guard $0.isChannelVoice else { return true }
                
                guard case .cc(let event) = $0
                else { return true }
                
                return event.controller == cc
            }
            
        case .keepCCs(let ccs):
            return filter {
                guard $0.isChannelVoice else { return true }
                
                guard case .cc(let event) = $0
                else { return true }
                
                return ccs.contains(event.controller)
            }
            
        case .keepNotesInRange(let noteRange):
            return filter {
                switch $0 {
                case .noteOn(let noteOn):
                    return noteRange.contains(noteOn.note)
                    
                case .noteOff(let noteOff):
                    return noteRange.contains(noteOff.note)
                    
                default:
                    return true
                }
            }
            
        case .keepNotesInRanges(let noteRanges):
            return filter {
                switch $0 {
                case .noteOn(let noteOn):
                    for noteRange in noteRanges {
                        if noteRange.contains(noteOn.note) { return true }
                    }
                    return false
                    
                case .noteOff(let noteOff):
                    for noteRange in noteRanges {
                        if noteRange.contains(noteOff.note) { return true }
                    }
                    return false
                    
                default:
                    return true
                }
            }
            
        case .drop:
            return filter { !$0.isChannelVoice }
            
        case .dropChannel(let channel):
            return filter { $0.channel != channel }
            
        case .dropChannels(let channels):
            return filter {
                guard let channel = $0.channel else { return true }
                return !channels.contains(channel)
            }
            
        case .dropType(let specificType):
            return filter {
                guard $0.isChannelVoice else { return true }
                return !$0.isChannelVoice(ofType: specificType)
            }
            
        case .dropTypes(let specificTypes):
            return filter {
                guard $0.isChannelVoice else { return true }
                return !$0.isChannelVoice(ofTypes: specificTypes)
            }
            
        case .dropCC(let cc):
            return filter {
                guard case .cc(let event) = $0
                else { return true }
                
                return event.controller != cc
            }
            
        case .dropCCs(let ccs):
            return filter {
                guard case .cc(let event) = $0
                else { return true }
                
                return !ccs.contains(event.controller)
            }
         
        case .dropNotesInRange(let noteRange):
            return filter {
                switch $0 {
                case .noteOn(let noteOn):
                    return !noteRange.contains(noteOn.note)
                    
                case .noteOff(let noteOff):
                    return !noteRange.contains(noteOff.note)
                    
                default:
                    return true
                }
            }
            
            
        case .dropNotesInRanges(let noteRanges):
            return filter {
                switch $0 {
                case .noteOn(let noteOn):
                    for noteRange in noteRanges {
                        if noteRange.contains(noteOn.note) { return false }
                    }
                    return true
                    
                case .noteOff(let noteOff):
                    for noteRange in noteRanges {
                        if noteRange.contains(noteOff.note) { return false }
                    }
                    return true
                    
                default:
                    return true
                }
            }
            
        }
        
    }
    
}
