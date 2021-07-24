//
//  Event Metadata.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

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
    
    @inlinable public func isChannelVoice(ofType chanVoiceType: ChanVoice) -> Bool {
        
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
    
    /// Returns true if the event is a System Common message.
    @inlinable public var isSystemExclusive: Bool {
        
        switch self {
        case .sysEx,
             .sysExUniversal:
            return true
            
        default:
            return false
        }
        
    }
    
    /// Returns true if the event is a System Common message.
    @inlinable public var isSystemCommon: Bool {
        
        switch self {
        case .timecodeQuarterFrame,
             .songPositionPointer,
             .songSelect,
             .unofficialBusSelect,
             .tuneRequest:
            return true
            
        default:
            return false
        }
        
    }
    
    /// Returns true if the event is a System Common message.
    @inlinable public var isSystemRealTime: Bool {
        
        switch self {
        case .timingClock,
             .start,
             .continue,
             .stop,
             .activeSensing,
             .systemReset:
            return true
            
        default:
            return false
        }
        
    }
    
}
