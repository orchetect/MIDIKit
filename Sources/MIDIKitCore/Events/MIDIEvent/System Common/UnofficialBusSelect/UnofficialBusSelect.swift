//
//  UnofficialBusSelect.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Unofficial Bus Select (Status `0xF5`)
    ///
    /// > Warning: This command is not officially supported and some MIDI subsystems will ignore it
    /// > entirely. It is provided purely for legacy support and its use is discouraged. It will
    /// > be removed in a future release of MIDIKit.
    ///
    /// > Reference:
    /// >
    /// > Some vendors have produced boxes with a single MIDI input, and multiple MIDI outputs. The
    /// > Bus Select message specifies which of the outputs further data should be sent to. This is
    /// > not an official message; the vendors in question should have used a SysEx command." --
    /// > [David Van Brink's MIDI
    /// > Spec](https://www.cs.cmu.edu/~music/cmsip/readings/davids-midi-spec.htm)
    public struct UnofficialBusSelect: Equatable, Hashable {
        /// Bus Number
        public var bus: UInt7 = 0
        
        /// UMP Group (`0x0 ... 0xF`)
        public var group: UInt4 = 0x0
        
        @available(*, deprecated, message: "Bus Select is not supported by Core MIDI and will be removed in the future.")
        public init(
            bus: UInt7 = 0,
            group: UInt4 = 0x0
        ) {
            self.bus = bus
            self.group = group
        }
    }
    
    /// Unofficial Bus Select (Status `0xF5`)
    ///
    /// > Warning: This command is not officially supported and some MIDI subsystems will ignore it
    /// > entirely. It is provided purely for legacy support and its use is discouraged. It will
    /// > be removed in a future release of MIDIKit.
    ///
    /// > Reference:
    /// >
    /// > Some vendors have produced boxes with a single MIDI input, and multiple MIDI outputs. The
    /// > Bus Select message specifies which of the outputs further data should be sent to. This is
    /// > not an official message; the vendors in question should have used a SysEx command." --
    /// > [David Van Brink's MIDI
    /// > Spec](https://www.cs.cmu.edu/~music/cmsip/readings/davids-midi-spec.htm)
    ///
    /// - Parameters:
    ///   - bus: Bus Number (0x00...0x7F)
    ///   - group: UMP Group (`0x0 ... 0xF`)
    @available(*, deprecated, message: "Bus Select is not supported by Core MIDI and will be removed in the future.")
    public static func unofficialBusSelect(
        bus: UInt7,
        group: UInt4 = 0x0
    ) -> Self {
        .unofficialBusSelect(
            .init(
                bus: bus,
                group: group
            )
        )
    }
}

extension MIDIEvent.UnofficialBusSelect {
    /// Returns the raw MIDI 1.0 status byte for the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawStatusByte() -> UInt8 {
        0xF5
    }
    
    /// Returns the raw MIDI 1.0 data bytes for the event (excluding status byte).
    public func midi1RawDataBytes() -> UInt8 {
        bus.uInt8Value
    }
    
    /// Returns the complete raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes() -> [UInt8] {
        [midi1RawStatusByte(), midi1RawDataBytes()]
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
            midi1RawStatusByte(),
            midi1RawDataBytes(),
            0x00
        ) // pad empty bytes to fill 4 bytes
    
        return [word]
    }
}
