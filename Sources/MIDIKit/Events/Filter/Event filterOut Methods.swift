//
//  Event FilterOut.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Event Classification

extension Collection where Element == MIDI.Event {
    
    /// Returns events filtering out Channel Voice events.
    @inlinable public func filterOutChannelVoice() -> [Element] {
        filter { !$0.isChannelVoice }
    }
    
    /// Returns events filtering out System Exclusive events.
    @inlinable public func filterOutSystemExclusive() -> [Element] {
        filter { !$0.isSystemExclusive }
    }
    
    /// Returns events filtering out System Common events.
    @inlinable public func filterOutSystemCommon() -> [Element] {
        filter { !$0.isSystemCommon }
    }
    
    /// Returns events filtering out System Real Time events.
    @inlinable public func filterOutSystemRealTime() -> [Element] {
        filter { !$0.isSystemRealTime }
    }
    
}

// MARK: - Channel

extension Collection where Element == MIDI.Event {
    
    /// Returns events filtering out Channel Voice events matching the given channel number.
    @inlinable public func filterOut(channel isExcluded: MIDI.UInt4) -> [Element] {
        filter { $0.channel != isExcluded }
    }
    
    /// Returns events filtering out Channel Voice events matching the given channel numbers.
    @inlinable public func filterOut(channels isIncluded: [MIDI.UInt4]) -> [Element] {
        filter {
            guard let channel = $0.channel else { return true }
            return !isIncluded.contains(channel)
        }
    }
    
}

// MARK: - Channel Voice Types

extension Collection where Element == MIDI.Event {
    
    /// Returns all events, with the exception where if an event is a Channel Voice event then it will only be included if its type matches the given type.
    @inlinable public func filterOutChannelVoice(type isExcluded: MIDI.Event.ChanVoice) -> [Element] {
        filter { $0.isChannelVoice(ofType: isExcluded) }
    }
    
    /// Returns all events, with the exception where if an event is a Channel Voice event then it will only be included if its type matches one of the given type.
    @inlinable public func filterOut(chanVoiceType isExcluded: MIDI.Event.ChanVoice) -> [Element] {
        filter {
            guard let channel = $0.channel else { return true }
            return $0.isChannelVoice(ofType: isExcluded)
        }
    }
    
}

// MARK: - CCs

extension Collection where Element == MIDI.Event {
    
    /// Returns events filtering out Controller Change events matching the given controller.
    @inlinable public func filterOut(cc isIncluded: MIDI.Event.CC) -> [Element] {
        filter {
            switch $0 {
            case .cc(controller: let controller, value: _, channel: _):
                return controller != isIncluded.controller
            default:
                return true
            }
        }
    }
    
    /// Returns events filtering out Controller Change events matching the given controllers.
    @inlinable public func filterOut(cc isIncluded: [MIDI.Event.CC]) -> [Element] {
        let isIncludedCCNumbers = isIncluded.map { $0.controller }
        
        return filter {
            switch $0 {
            case .cc(controller: let controller, value: _, channel: _):
                return !isIncludedCCNumbers.contains(controller)
            default:
                return true
            }
        }
    }
    
}
