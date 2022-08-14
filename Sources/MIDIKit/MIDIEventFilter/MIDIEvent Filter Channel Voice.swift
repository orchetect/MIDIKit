//
//  MIDIEvent Filter Channel Voice.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

// MARK: - Metadata properties

extension MIDIEvent {
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
        // swiftformat:disable spacearoundoperators
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
        // swiftformat:enable spacearoundoperators
    }
    
    /// Returns true if the event is a Channel Voice message of a specific type.
    @inlinable
    public func isChannelVoice(ofTypes chanVoiceTypes: Set<ChanVoiceType>) -> Bool {
        for eventType in chanVoiceTypes {
            if isChannelVoice(ofType: eventType) { return true }
        }
        
        return false
    }
}

// MARK: - Filter

extension Collection where Element == MIDIEvent {
    /// Filter Channel Voice events.
    @inlinable
    public func filter(chanVoice types: MIDIEvent.ChanVoiceTypes) -> [Element] {
        switch types {
        case .only:
            return filter { $0.isChannelVoice }
            
        case let .onlyType(specificType):
            return filter { $0.isChannelVoice(ofType: specificType) }
            
        case let .onlyTypes(specificTypes):
            return filter { $0.isChannelVoice(ofTypes: specificTypes) }
            
        case let .onlyChannel(channel):
            return filter { $0.channel == channel }
            
        case let .onlyChannels(channels):
            return filter {
                guard let channel = $0.channel else { return false }
                return channels.contains(channel)
            }
            
        case let .onlyCC(cc):
            return filter {
                guard case let .cc(event) = $0
                else { return false }
                
                return event.controller == cc
            }
            
        case let .onlyCCs(ccs):
            return filter {
                guard case let .cc(event) = $0
                else { return false }
                
                return ccs.contains(event.controller)
            }
            
        case let .onlyNotesInRange(noteRange):
            return filter {
                switch $0 {
                case let .noteOn(noteOn):
                    return noteRange.contains(noteOn.note.number)
                    
                case let .noteOff(noteOff):
                    return noteRange.contains(noteOff.note.number)
                    
                default:
                    return false
                }
            }
            
        case let .onlyNotesInRanges(noteRanges):
            return filter {
                switch $0 {
                case let .noteOn(noteOn):
                    for noteRange in noteRanges {
                        if noteRange.contains(noteOn.note.number) { return true }
                    }
                    return false
                    
                case let .noteOff(noteOff):
                    for noteRange in noteRanges {
                        if noteRange.contains(noteOff.note.number) { return true }
                    }
                    return false
                    
                default:
                    return false
                }
            }
            
        case let .keepChannel(channel):
            return filter {
                guard let _ = $0.channel else { return true }
                return $0.channel == channel
            }
            
        case let .keepChannels(channels):
            return filter {
                guard let channel = $0.channel else { return true }
                return channels.contains(channel)
            }
            
        case let .keepType(specificType):
            return filter {
                guard $0.isChannelVoice else { return true }
                return $0.isChannelVoice(ofType: specificType)
            }
            
        case let .keepTypes(specificTypes):
            return filter {
                guard $0.isChannelVoice else { return true }
                return $0.isChannelVoice(ofTypes: specificTypes)
            }
            
        case let .keepCC(cc):
            return filter {
                guard $0.isChannelVoice else { return true }
                
                guard case let .cc(event) = $0
                else { return true }
                
                return event.controller == cc
            }
            
        case let .keepCCs(ccs):
            return filter {
                guard $0.isChannelVoice else { return true }
                
                guard case let .cc(event) = $0
                else { return true }
                
                return ccs.contains(event.controller)
            }
            
        case let .keepNotesInRange(noteRange):
            return filter {
                switch $0 {
                case let .noteOn(noteOn):
                    return noteRange.contains(noteOn.note.number)
                    
                case let .noteOff(noteOff):
                    return noteRange.contains(noteOff.note.number)
                    
                default:
                    return true
                }
            }
            
        case let .keepNotesInRanges(noteRanges):
            return filter {
                switch $0 {
                case let .noteOn(noteOn):
                    for noteRange in noteRanges {
                        if noteRange.contains(noteOn.note.number) { return true }
                    }
                    return false
                    
                case let .noteOff(noteOff):
                    for noteRange in noteRanges {
                        if noteRange.contains(noteOff.note.number) { return true }
                    }
                    return false
                    
                default:
                    return true
                }
            }
            
        case .drop:
            return filter { !$0.isChannelVoice }
            
        case let .dropChannel(channel):
            return filter { $0.channel != channel }
            
        case let .dropChannels(channels):
            return filter {
                guard let channel = $0.channel else { return true }
                return !channels.contains(channel)
            }
            
        case let .dropType(specificType):
            return filter {
                guard $0.isChannelVoice else { return true }
                return !$0.isChannelVoice(ofType: specificType)
            }
            
        case let .dropTypes(specificTypes):
            return filter {
                guard $0.isChannelVoice else { return true }
                return !$0.isChannelVoice(ofTypes: specificTypes)
            }
            
        case let .dropCC(cc):
            return filter {
                guard case let .cc(event) = $0
                else { return true }
                
                return event.controller != cc
            }
            
        case let .dropCCs(ccs):
            return filter {
                guard case let .cc(event) = $0
                else { return true }
                
                return !ccs.contains(event.controller)
            }
         
        case let .dropNotesInRange(noteRange):
            return filter {
                switch $0 {
                case let .noteOn(noteOn):
                    return !noteRange.contains(noteOn.note.number)
                    
                case let .noteOff(noteOff):
                    return !noteRange.contains(noteOff.note.number)
                    
                default:
                    return true
                }
            }
            
        case let .dropNotesInRanges(noteRanges):
            return filter {
                switch $0 {
                case let .noteOn(noteOn):
                    for noteRange in noteRanges {
                        if noteRange.contains(noteOn.note.number) { return false }
                    }
                    return true
                    
                case let .noteOff(noteOff):
                    for noteRange in noteRanges {
                        if noteRange.contains(noteOff.note.number) { return false }
                    }
                    return true
                    
                default:
                    return true
                }
            }
        }
    }
}
