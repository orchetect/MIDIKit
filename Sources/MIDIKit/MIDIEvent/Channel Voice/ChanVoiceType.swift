//
//  ChanVoiceType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Declarative Channel Voice MIDI Event types used in event filters.
    public enum ChanVoiceTypes {
        /// Return only Channel Voice events.
        case only
        /// Return only Channel Voice events matching a certain event type.
        case onlyType(ChanVoiceType)
        /// Return only Channel Voice events matching certain event type(s).
        case onlyTypes(Set<ChanVoiceType>)
        /// Return only Channel Voice events matching a certain channel.
        case onlyChannel(UInt4)
        /// Return only Channel Voice events matching certain channel(s).
        case onlyChannels([UInt4])
        /// Return only Control Change (CC) events matching a certain controller number.
        case onlyCC(MIDIEvent.CC.Controller)
        /// Return only Control Change (CC) events matching certain controller number(s).
        case onlyCCs([MIDIEvent.CC.Controller])
        /// Return only noteOn/noteOff events within a certain number range.
        case onlyNotesInRange(ClosedRange<UInt7>)
        /// Return only noteOn/noteOff events within certain note number range(s).
        case onlyNotesInRanges([ClosedRange<UInt7>])
        
        /// Retain Channel Voice events only with a certain type,
        /// while retaining all non-Channel Voice events.
        case keepType(ChanVoiceType)
        /// Retain Channel Voice events only with certain type(s),
        /// while retaining all non-Channel Voice events.
        case keepTypes(Set<ChanVoiceType>)
        /// Retain Channel Voice events only with a certain channel,
        /// while retaining all non-Channel Voice events.
        case keepChannel(UInt4)
        /// Retain Channel Voice events only with certain channel(s),
        /// while retaining all non-Channel Voice events.
        case keepChannels([UInt4])
        /// Retain only CC events with a certain controller,
        /// while retaining all non-Channel Voice events.
        case keepCC(MIDIEvent.CC.Controller)
        /// Retain only CC events with certain controller(s),
        /// while retaining all non-Channel Voice events.
        case keepCCs([MIDIEvent.CC.Controller])
        /// Retains only noteOn/noteOff events within a certain note range,
        /// while retaining all non-Channel Voice events.
        case keepNotesInRange(ClosedRange<UInt7>)
        /// Retains only noteOn/noteOff events within certain note ranges(s),
        /// while retaining all non-Channel Voice events.
        case keepNotesInRanges([ClosedRange<UInt7>])
        
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
        case dropChannel(UInt4)
        /// Drop any Channel Voice events matching certain channel(s),
        /// while retaining all non-Channel Voice events.
        case dropChannels([UInt4])
        /// Drop any Control Change (CC) events matching a certain controller,
        /// while retaining all non-Channel Voice events.
        case dropCC(MIDIEvent.CC.Controller)
        /// Drop any Control Change (CC) events matching certain controller(s),
        /// while retaining all non-Channel Voice events.
        case dropCCs([MIDIEvent.CC.Controller])
        /// Drop any noteOn/noteOff events within a certain note range,
        /// while retaining all non-Channel Voice events.
        case dropNotesInRange(ClosedRange<UInt7>)
        /// Drop any noteOn/noteOff events within certain note range(s),
        /// while retaining all non-Channel Voice events.
        case dropNotesInRanges([ClosedRange<UInt7>])
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

extension MIDIEvent.ChanVoiceTypes {
    // MARK: Only
    
    /// Return only Control Change (CC) events matching a certain controller number.
    @_disfavoredOverload
    public static func onlyCC(_ cc: UInt7) -> Self {
        .onlyCC(.init(number: cc))
    }
    
    /// Return only Control Change (CC) events matching certain controller number(s).
    @_disfavoredOverload
    public static func onlyCCs(_ ccs: [UInt7]) -> Self {
        .onlyCCs(ccs.map { .init(number: $0) })
    }
    
    // MARK: Keep
    
    /// Retain only CC events with a certain controller,
    /// while retaining all non-Channel Voice events.
    @_disfavoredOverload
    public static func keepCC(_ cc: UInt7) -> Self {
        .keepCC(.init(number: cc))
    }

    /// Retain only CC events with certain controller(s),
    /// while retaining all non-Channel Voice events.
    @_disfavoredOverload
    public static func keepCCs(_ ccs: [UInt7]) -> Self {
        .keepCCs(ccs.map { .init(number: $0) })
    }
    
    // MARK: Drop
    
    /// Drop any Control Change (CC) events matching a certain controller,
    /// while retaining all non-Channel Voice events.
    @_disfavoredOverload
    public static func dropCC(_ cc: UInt7) -> Self {
        .dropCC(.init(number: cc))
    }

    /// Drop any Control Change (CC) events matching certain controller(s),
    /// while retaining all non-Channel Voice events.
    @_disfavoredOverload
    public static func dropCCs(_ ccs: [UInt7]) -> Self {
        .dropCCs(ccs.map { .init(number: $0) })
    }
}
