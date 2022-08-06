//
//  ChanVoiceType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event {
    /// Declarative Channel Voice MIDI Event types used in event filters.
    public enum ChanVoiceTypes {
        /// Return only Channel Voice events.
        case only
        /// Return only Channel Voice events matching a certain event type.
        case onlyType(ChanVoiceType)
        /// Return only Channel Voice events matching certain event type(s).
        case onlyTypes(Set<ChanVoiceType>)
        /// Return only Channel Voice events matching a certain channel.
        case onlyChannel(MIDI.UInt4)
        /// Return only Channel Voice events matching certain channel(s).
        case onlyChannels([MIDI.UInt4])
        /// Return only Control Change (CC) events matching a certain controller number.
        case onlyCC(MIDI.Event.CC.Controller)
        /// Return only Control Change (CC) events matching certain controller number(s).
        case onlyCCs([MIDI.Event.CC.Controller])
        /// Return only noteOn/noteOff events within a certain number range.
        case onlyNotesInRange(ClosedRange<MIDI.UInt7>)
        /// Return only noteOn/noteOff events within certain note number range(s).
        case onlyNotesInRanges([ClosedRange<MIDI.UInt7>])
        
        /// Retain Channel Voice events only with a certain type,
        /// while retaining all non-Channel Voice events.
        case keepType(ChanVoiceType)
        /// Retain Channel Voice events only with certain type(s),
        /// while retaining all non-Channel Voice events.
        case keepTypes(Set<ChanVoiceType>)
        /// Retain Channel Voice events only with a certain channel,
        /// while retaining all non-Channel Voice events.
        case keepChannel(MIDI.UInt4)
        /// Retain Channel Voice events only with certain channel(s),
        /// while retaining all non-Channel Voice events.
        case keepChannels([MIDI.UInt4])
        /// Retain only CC events with a certain controller,
        /// while retaining all non-Channel Voice events.
        case keepCC(MIDI.Event.CC.Controller)
        /// Retain only CC events with certain controller(s),
        /// while retaining all non-Channel Voice events.
        case keepCCs([MIDI.Event.CC.Controller])
        /// Retains only noteOn/noteOff events within a certain note range,
        /// while retaining all non-Channel Voice events.
        case keepNotesInRange(ClosedRange<MIDI.UInt7>)
        /// Retains only noteOn/noteOff events within certain note ranges(s),
        /// while retaining all non-Channel Voice events.
        case keepNotesInRanges([ClosedRange<MIDI.UInt7>])
        
        /// Drop all Channel Voice events,
        /// while retaining all non-Channel Voice events.
        case drop
        /// Drop any Channel Voice events matching a certain event type,
        /// while retaining all non-Channel Voice events.
        case dropType(ChanVoiceType)
        /// Drop any Channel Voice events matching certain event type(s),
        /// while retaining all non-Channel Voice events.
        case dropTypes(Set<ChanVoiceType>)
        /// Drop any Channel Voice events matching a certain channel,
        /// while retaining all non-Channel Voice events.
        case dropChannel(MIDI.UInt4)
        /// Drop any Channel Voice events matching certain channel(s),
        /// while retaining all non-Channel Voice events.
        case dropChannels([MIDI.UInt4])
        /// Drop any Control Change (CC) events matching a certain controller,
        /// while retaining all non-Channel Voice events.
        case dropCC(MIDI.Event.CC.Controller)
        /// Drop any Control Change (CC) events matching certain controller(s),
        /// while retaining all non-Channel Voice events.
        case dropCCs([MIDI.Event.CC.Controller])
        /// Drop any noteOn/noteOff events within a certain note range,
        /// while retaining all non-Channel Voice events.
        case dropNotesInRange(ClosedRange<MIDI.UInt7>)
        /// Drop any noteOn/noteOff events within certain note range(s),
        /// while retaining all non-Channel Voice events.
        case dropNotesInRanges([ClosedRange<MIDI.UInt7>])
    }
    
    /// Channel Voice MIDI Event types.
    public enum ChanVoiceType: Equatable, Hashable {
        case noteOn
        case noteOff
        case noteCC
        case notePitchBend
        case notePressure
        case noteManagement
        case cc
        case programChange
        case pressure
        case pitchBend
    }
}

// MARK: - Convenience Static Constructors

extension MIDI.Event.ChanVoiceTypes {
    // MARK: Only
    
    /// Return only Control Change (CC) events matching a certain controller number.
    @_disfavoredOverload
    public static func onlyCC(_ cc: MIDI.UInt7) -> Self {
        .onlyCC(.init(number: cc))
    }
    
    /// Return only Control Change (CC) events matching certain controller number(s).
    @_disfavoredOverload
    public static func onlyCCs(_ ccs: [MIDI.UInt7]) -> Self {
        .onlyCCs(ccs.map { .init(number: $0) })
    }
    
    // MARK: Keep
    
    /// Retain only CC events with a certain controller,
    /// while retaining all non-Channel Voice events.
    @_disfavoredOverload
    public static func keepCC(_ cc: MIDI.UInt7) -> Self {
        .keepCC(.init(number: cc))
    }

    /// Retain only CC events with certain controller(s),
    /// while retaining all non-Channel Voice events.
    @_disfavoredOverload
    public static func keepCCs(_ ccs: [MIDI.UInt7]) -> Self {
        .keepCCs(ccs.map { .init(number: $0) })
    }
    
    // MARK: Drop
    
    /// Drop any Control Change (CC) events matching a certain controller,
    /// while retaining all non-Channel Voice events.
    @_disfavoredOverload
    public static func dropCC(_ cc: MIDI.UInt7) -> Self {
        .dropCC(.init(number: cc))
    }

    /// Drop any Control Change (CC) events matching certain controller(s),
    /// while retaining all non-Channel Voice events.
    @_disfavoredOverload
    public static func dropCCs(_ ccs: [MIDI.UInt7]) -> Self {
        .dropCCs(ccs.map { .init(number: $0) })
    }
}
