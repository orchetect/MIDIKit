//
//  SongPositionPointer.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDIEvent {
    /// System Common: Song Position Pointer
    /// (MIDI 1.0 / 2.0)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "A sequencer's Song Position (SP) is the number of MIDI beats (1 beat = 6 MIDI clocks) that have elapsed from the start and is used to begin playback of a sequence from a position other than the beginning of the song."
    public struct SongPositionPointer: Equatable, Hashable {
        /// The number of MIDI beats (1 beat = 6 MIDI clocks) that have elapsed from the start.
        public var midiBeat: UInt14
        
        /// UMP Group (0x0...0xF)
        public var group: UInt4 = 0x0
        
        public init(
            midiBeat: UInt14,
            group: UInt4 = 0x0
        ) {
            self.midiBeat = midiBeat
            self.group = group
        }
    }
    
    /// System Common: Song Position Pointer
    /// (MIDI 1.0 / 2.0)
    ///
    /// - remark: MIDI 1.0 Spec:
    ///
    /// "A sequencer's Song Position (SP) is the number of MIDI beats (1 beat = 6 MIDI clocks) that have elapsed from the start of the song and is used to begin playback of a sequence from a position other than the beginning of the song."
    ///
    /// - Parameters:
    ///   - midiBeat: MIDI beat number elapsed from the start
    ///   - group: UMP Group (0x0...0xF)
    @inline(__always)
    public static func songPositionPointer(
        midiBeat: UInt14,
        group: UInt4 = 0x0
    ) -> Self {
        .songPositionPointer(
            .init(
                midiBeat: midiBeat,
                group: group
            )
        )
    }
}

extension MIDIEvent.SongPositionPointer {
    /// Returns the raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func midi1RawBytes() -> [Byte] {
        let bytePair = midiBeat.bytePair
        return [0xF2, bytePair.lsb, bytePair.msb]
    }
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage of MIDIKit, but is provided publicly for introspection and debugging purposes.
    @inline(__always)
    public func umpRawWords() -> [UMPWord] {
        let umpMessageType: UniversalMIDIPacketData
            .MessageType = .systemRealTimeAndCommon
        
        let mtAndGroup = (umpMessageType.rawValue.uInt8Value << 4) + group
        
        let bytePair = midiBeat.bytePair
        
        let word = UMPWord(
            mtAndGroup,
            0xF2,
            bytePair.lsb,
            bytePair.msb
        )
        
        return [word]
    }
}
