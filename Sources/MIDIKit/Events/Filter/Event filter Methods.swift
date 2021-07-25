//
//  Event Filter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - Event Classification

extension Collection where Element == MIDI.Event {
    
    /// Returns only Channel Voice events.
    @inlinable public func filterChannelVoice() -> [Element] {
        filter { $0.isChannelVoice }
    }
    
    /// Returns only System Exclusive events.
    @inlinable public func filterSystemExclusive() -> [Element] {
        filter { $0.isSystemExclusive }
    }
    
    /// Returns only System Common events.
    @inlinable public func filterSystemCommon() -> [Element] {
        filter { $0.isSystemCommon }
    }
    
    /// Returns only System Real Time events.
    @inlinable public func filterSystemRealTime() -> [Element] {
        filter { $0.isSystemRealTime }
    }
    
}

// MARK: - Channel

extension Collection where Element == MIDI.Event {
    
    /// Returns only Channel Voice events matching the given channel number.
    @inlinable public func filterChannelVoice(channel isIncluded: MIDI.UInt4) -> [Element] {
        filter { $0.channel == isIncluded }
    }
    
    /// Returns only Channel Voice events matching the given channel numbers.
    @inlinable public func filterChannelVoice(channels isIncluded: [MIDI.UInt4]) -> [Element] {
        filter {
            guard let channel = $0.channel else { return false }
            return isIncluded.contains(channel)
        }
    }
    
    /// Returns all events, with the exception where if an event is a Channel Voice event then it will only be included if its channel matches the given channel number.
    @inlinable public func filter(channel isIncluded: MIDI.UInt4) -> [Element] {
        filter {
            guard let channel = $0.channel else { return true }
            return channel == isIncluded
        }
    }
    
    /// Returns all events, with the exception where if an event is a Channel Voice event then it will only be included if its channel matches one of the given channel numbers.
    @inlinable public func filter(channels isIncluded: [MIDI.UInt4]) -> [Element] {
        filter {
            guard let channel = $0.channel else { return true }
            return isIncluded.contains(channel)
        }
    }
    
}

// MARK: - Channel Voice Types

extension Collection where Element == MIDI.Event {
    
    /// Returns all events, with the exception where if an event is a Channel Voice event then it will only be included if its type matches the given type.
    @inlinable public func filterChannelVoice(type isIncluded: MIDI.Event.ChanVoice) -> [Element] {
        filter { $0.isChannelVoice(ofType: isIncluded) }
    }
    
    /// Returns all events, with the exception where if an event is a Channel Voice event then it will only be included if its type matches one of the given type.
    @inlinable public func filter(chanVoiceType isIncluded: MIDI.Event.ChanVoice) -> [Element] {
        filter {
            guard let channel = $0.channel else { return true }
            return $0.isChannelVoice(ofType: isIncluded)
        }
    }
    
}

// MARK: - CCs

extension Collection where Element == MIDI.Event {
    
    /// Returns only Controller Change events matching the given controller.
    @inlinable public func filter(cc isIncluded: MIDI.Event.CC) -> [Element] {
        filter {
            switch $0 {
            case .cc(controller: let controller, value: _, channel: _):
                return controller == isIncluded.controller
            default:
                return false
            }
        }
    }
    
    /// Returns only Controller Change events matching the given controllers.
    @inlinable public func filter(cc isIncluded: [MIDI.Event.CC]) -> [Element] {
        let isIncludedCCNumbers = isIncluded.map { $0.controller }
        
        return filter {
            switch $0 {
            case .cc(controller: let controller, value: _, channel: _):
                return isIncludedCCNumbers.contains(controller)
            default:
                return false
            }
        }
    }
    
}
