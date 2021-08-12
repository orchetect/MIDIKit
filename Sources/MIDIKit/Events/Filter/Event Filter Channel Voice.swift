//
//  Event Filter Channel Voice.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#warning("> These are incomplete, will be finished in a future release")

// MARK: - Metadata properties

extension MIDI.Event {
    
    /// Returns true if the event is a Channel Voice message.
    @inlinable public var isChannelVoice: Bool {
        
        switch self {
        case .noteOn,
                .noteOff,
                .polyAftertouch,
                .cc,
                .programChange,
                .chanAftertouch,
                .pitchBend:
            return true
            
        default:
            return false
        }
        
    }
    
    /// Returns true if the event is a Channel Voice message of a specific type.
    @inlinable public func isChannelVoice(ofType chanVoiceType: ChanVoiceType) -> Bool {
        
        switch self {
        case .noteOn         : return chanVoiceType == .noteOn
        case .noteOff        : return chanVoiceType == .noteOff
        case .polyAftertouch : return chanVoiceType == .polyAftertouch
        case .cc             : return chanVoiceType == .cc
        case .programChange  : return chanVoiceType == .programChange
        case .chanAftertouch : return chanVoiceType == .chanAftertouch
        case .pitchBend      : return chanVoiceType == .pitchBend
        default              : return false
        }
        
    }
    
    /// Returns true if the event is a Channel Voice message of a specific type.
    @inlinable public func isChannelVoice(ofTypes chanVoiceTypes: Set<ChanVoiceType>) -> Bool {
        
        for eventType in chanVoiceTypes {
            if self.isChannelVoice(ofType: eventType) { return true }
        }
        
        return false
        
    }
    
}

// MARK: - Filter

extension Collection where Element == MIDI.Event {
    
    /// Filter Channel Voice events.
    @inlinable public func filter(chanVoice types: MIDI.Event.ChanVoiceTypes) -> [Element] {
        
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
                guard case .cc(controller: let controller,
                               value: _,
                               channel: _,
                               group: _) = $0
                else { return false }
                
                return controller == cc.controller
            }
            
        case .onlyCCs(let ccs):
            let isIncludedCCNumbers = ccs.map { $0.controller }
            
            return filter {
                guard case .cc(controller: let controller,
                               value: _,
                               channel: _,
                               group: _) = $0
                else { return false }
                
                return isIncludedCCNumbers.contains(controller)
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
                
                guard case .cc(controller: let controller,
                               value: _,
                               channel: _,
                               group: _) = $0
                else { return true }
                
                return controller == cc.controller
            }
            
        case .keepCCs(let ccs):
            let isIncludedCCNumbers = ccs.map { $0.controller }
            
            return filter {
                guard $0.isChannelVoice else { return true }
                
                guard case .cc(controller: let controller,
                               value: _,
                               channel: _,
                               group: _) = $0
                else { return true }
                
                return isIncludedCCNumbers.contains(controller)
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
                guard case .cc(controller: let controller,
                               value: _,
                               channel: _,
                               group: _) = $0
                else { return true }
                
                return controller != cc.controller
            }
            
        case .dropCCs(let ccs):
            let isIncludedCCNumbers = ccs.map { $0.controller }
            
            return filter {
                guard case .cc(controller: let controller,
                               value: _,
                               channel: _,
                               group: _) = $0
                else { return true }
                
                return !isIncludedCCNumbers.contains(controller)
            }
            
        }
        
    }
    
}
