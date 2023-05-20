//
//  TimecodeQuarterFrame.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// System Common: Timecode Quarter-Frame
    /// (MIDI 1.0 / 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > For device synchronization, MIDI Time Code uses two basic types of messages, described as
    /// > Quarter Frame and Full. There is also a third, optional message for encoding SMPTE user
    /// > bits. The Quarter Frame message communicates the Frame, Seconds, Minutes and Hours Count
    /// > in an 8-message sequence. There is also an MTC FULL FRAME message which is a MIDI System
    /// > Exclusive Message.
    public struct TimecodeQuarterFrame: Equatable, Hashable {
        /// Data Byte containing quarter-frame bits
        public var dataByte: UInt7
    
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
    
        public init(
            dataByte: UInt7,
            group: UInt4 = 0x0
        ) {
            self.dataByte = dataByte
            self.group = group
        }
    }
    
    /// System Common: Timecode Quarter-Frame
    /// (MIDI 1.0 / 2.0)
    ///
    /// > MIDI 1.0 Spec:
    /// >
    /// > For device synchronization, MIDI Time Code uses two basic types of messages, described as
    /// > Quarter Frame and Full. There is also a third, optional message for encoding SMPTE user
    /// > bits. The Quarter Frame message communicates the Frame, Seconds, Minutes and Hours Count
    /// > in an 8-message sequence. There is also an MTC FULL FRAME message which is a MIDI System
    /// > Exclusive Message.
    ///
    /// - Parameters:
    ///   - dataByte: Data Byte containing quarter-frame bits
    ///   - group: UMP Group (`0x0 ... 0xF`)
    public static func timecodeQuarterFrame(
        dataByte: UInt7,
        group: UInt4 = 0x0
    ) -> Self {
        .timecodeQuarterFrame(
            .init(
                dataByte: dataByte,
                group: group
            )
        )
    }
}

extension MIDIEvent.TimecodeQuarterFrame {
    /// Returns the raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        [0xF1, dataByte.uInt8Value]
    }
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords() -> [UMPWord] {
        let umpMessageType: MIDIUMPMessageType = .systemRealTimeAndCommon
    
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group.uInt8Value
    
        let word = UMPWord(
            mtAndGroup,
            0xF1,
            dataByte.uInt8Value,
            0x00
        ) // pad an empty byte to fill 4 bytes
    
        return [word]
    }
}
