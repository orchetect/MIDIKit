//
//  MIDIEvent Filter Channel Voice.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - Metadata properties

extension MIDIEvent {
    /// Returns `true` if the event is a Channel Voice message.
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
             .pressure,
             .rpn,
             .nrpn:
            true
    
        default:
            false
        }
    }
    
    /// Returns `true` if the event is a Channel Voice message of a specific type.
    public func isChannelVoice(ofType chanVoiceType: ChanVoiceType) -> Bool {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .noteOn:         chanVoiceType == .noteOn
        case .noteOff:        chanVoiceType == .noteOff
        case .noteCC:         chanVoiceType == .noteCC
        case .notePitchBend:  chanVoiceType == .notePitchBend
        case .notePressure:   chanVoiceType == .notePressure
        case .noteManagement: chanVoiceType == .noteManagement
        case .cc:             chanVoiceType == .cc
        case .programChange:  chanVoiceType == .programChange
        case .pitchBend:      chanVoiceType == .pitchBend
        case .pressure:       chanVoiceType == .pressure
        case .rpn:            chanVoiceType == .rpn
        case .nrpn:           chanVoiceType == .nrpn
        default:              false
        }
        // swiftformat:enable spacearoundoperators
    }
    
    /// Returns `true` if the event is a Channel Voice message of a specific type.
    public func isChannelVoice(ofTypes chanVoiceTypes: Set<ChanVoiceType>) -> Bool {
        for eventType in chanVoiceTypes {
            if isChannelVoice(ofType: eventType) { return true }
        }
    
        return false
    }
}

// MARK: - Filter

extension Collection<MIDIEvent> {
    /// Filter Channel Voice events.
    public func filter(chanVoice types: MIDIEvent.ChanVoiceTypes) -> [Element] {
        switch types {
        case .only:
            filter { $0.isChannelVoice }
    
        case let .onlyType(specificType):
            filter { $0.isChannelVoice(ofType: specificType) }
    
        case let .onlyTypes(specificTypes):
            filter { $0.isChannelVoice(ofTypes: specificTypes) }
    
        case let .onlyChannel(channel):
            filter { $0.channel == channel }
    
        case let .onlyChannels(channels):
            filter {
                guard let channel = $0.channel else { return false }
                return channels.contains(channel)
            }
    
        case let .onlyCC(cc):
            filter {
                guard case let .cc(event) = $0
                else { return false }
    
                return event.controller == cc
            }
    
        case let .onlyCCs(ccs):
            filter {
                guard case let .cc(event) = $0
                else { return false }
    
                return ccs.contains(event.controller)
            }
    
        case let .onlyNotesInRange(noteRange):
            filter {
                switch $0 {
                case let .noteOn(noteOn):
                    noteRange.contains(noteOn.note.number)
    
                case let .noteOff(noteOff):
                    noteRange.contains(noteOff.note.number)
    
                default:
                    false
                }
            }
    
        case let .onlyNotesInRanges(noteRanges):
            filter {
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
            filter {
                guard let _ = $0.channel else { return true }
                return $0.channel == channel
            }
    
        case let .keepChannels(channels):
            filter {
                guard let channel = $0.channel else { return true }
                return channels.contains(channel)
            }
    
        case let .keepType(specificType):
            filter {
                guard $0.isChannelVoice else { return true }
                return $0.isChannelVoice(ofType: specificType)
            }
    
        case let .keepTypes(specificTypes):
            filter {
                guard $0.isChannelVoice else { return true }
                return $0.isChannelVoice(ofTypes: specificTypes)
            }
    
        case let .keepCC(cc):
            filter {
                guard $0.isChannelVoice else { return true }
    
                guard case let .cc(event) = $0
                else { return true }
    
                return event.controller == cc
            }
    
        case let .keepCCs(ccs):
            filter {
                guard $0.isChannelVoice else { return true }
    
                guard case let .cc(event) = $0
                else { return true }
    
                return ccs.contains(event.controller)
            }
    
        case let .keepNotesInRange(noteRange):
            filter {
                switch $0 {
                case let .noteOn(noteOn):
                    noteRange.contains(noteOn.note.number)
    
                case let .noteOff(noteOff):
                    noteRange.contains(noteOff.note.number)
    
                default:
                    true
                }
            }
    
        case let .keepNotesInRanges(noteRanges):
            filter {
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
            filter { !$0.isChannelVoice }
    
        case let .dropChannel(channel):
            filter { $0.channel != channel }
    
        case let .dropChannels(channels):
            filter {
                guard let channel = $0.channel else { return true }
                return !channels.contains(channel)
            }
    
        case let .dropType(specificType):
            filter {
                guard $0.isChannelVoice else { return true }
                return !$0.isChannelVoice(ofType: specificType)
            }
    
        case let .dropTypes(specificTypes):
            filter {
                guard $0.isChannelVoice else { return true }
                return !$0.isChannelVoice(ofTypes: specificTypes)
            }
    
        case let .dropCC(cc):
            filter {
                guard case let .cc(event) = $0
                else { return true }
    
                return event.controller != cc
            }
    
        case let .dropCCs(ccs):
            filter {
                guard case let .cc(event) = $0
                else { return true }
    
                return !ccs.contains(event.controller)
            }
         
        case let .dropNotesInRange(noteRange):
            filter {
                switch $0 {
                case let .noteOn(noteOn):
                    !noteRange.contains(noteOn.note.number)
    
                case let .noteOff(noteOff):
                    !noteRange.contains(noteOff.note.number)
    
                default:
                    true
                }
            }
    
        case let .dropNotesInRanges(noteRanges):
            filter {
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
