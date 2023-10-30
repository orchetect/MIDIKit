//
//  ProgramChange Bank.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.ProgramChange {
    /// Bank Select
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// When receiving a Program Change event, if a bank number is present then the Bank Select
    /// event should be processed prior to the Program Change event.
    ///
    /// **MIDI 1.0**
    ///
    /// For MIDI 1.0, this results in 3 messages being transmitted in this order:
    ///  - Bank Select MSB (CC 0)
    ///  - Bank Select LSB (CC 32)
    ///  - Program Change
    ///
    /// Bank numbers in MIDI 1.0 are expressed as two 7-bit bytes (MSB/"coarse" and LSB/"fine").
    ///
    /// In some implementations, manufacturers have chosen to only use the MSB/"coarse" adjust (CC
    /// 0) switch banks since many devices don't have more than 128 banks (of 128 programs each).
    ///
    /// **MIDI 2.0**
    ///
    /// For MIDI 2.0, Program Change and Bank Select information is all contained within a single
    /// UMP (Universal MIDI Packet).
    ///
    /// Bank numbers in MIDI 2.0 are expressed by combining the two MIDI 1.0 7-bit bytes into a
    /// 14-bit number (`0 ... 16383`). They correlate exactly to MIDI 1.0 bank numbers.
    public enum Bank: Equatable, Hashable {
        /// No Bank Select operation will occur; only a Program Change event will happen.
        /// (MIDI 1.0 / 2.0)
        case noBankSelect
    
        /// Transmit a Bank Select operation prior to Program Change event.
        /// (MIDI 1.0 / 2.0)
        ///
        /// **MIDI 1.0**
        ///
        /// For MIDI 1.0, this results in 3 messages being transmitted in this order:
        ///  - Bank Select MSB (CC 0)
        ///  - Bank Select LSB (CC 32)
        ///  - Program Change
        ///
        /// Bank numbers in MIDI 1.0 are expressed as two 7-bit bytes (MSB/"coarse" and LSB/"fine").
        ///
        /// In some implementations, manufacturers have chosen to only use the MSB/"coarse" adjust
        /// (CC 0) switch banks since many devices don't have more than 128 banks (of 128 programs
        /// each).
        ///
        /// **MIDI 2.0**
        ///
        /// For MIDI 2.0, Program Change and Bank Select information is all contained within a
        /// single UMP (Universal MIDI Packet).
        ///
        /// Bank numbers in MIDI 2.0 are expressed by combining the two MIDI 1.0 7-bit bytes into a
        /// 14-bit number (`0 ... 16383`). They correlate exactly to MIDI 1.0 bank numbers.
        case bankSelect(UInt14)
    }
}

extension MIDIEvent.ProgramChange.Bank: Sendable { }

extension MIDIEvent.ProgramChange.Bank {
    /// Transmit a Bank Select operation prior to Program Change event.
    /// (MIDI 1.0 / 2.0)
    ///
    /// **MIDI 1.0**
    ///
    /// For MIDI 1.0, this results in 3 messages being transmitted in this order:
    ///  - Bank Select MSB (CC 0)
    ///  - Bank Select LSB (CC 32)
    ///  - Program Change
    ///
    /// Bank numbers in MIDI 1.0 are expressed as two 7-bit bytes (MSB/"coarse" and LSB/"fine").
    ///
    /// In some implementations, manufacturers have chosen to only use the MSB/"coarse" adjust (CC
    /// 0) switch banks since many devices don't have more than 128 banks (of 128 programs each).
    ///
    /// **MIDI 2.0**
    ///
    /// For MIDI 2.0, Program Change and Bank Select information is all contained within a single
    /// UMP (Universal MIDI Packet).
    ///
    /// Bank numbers in MIDI 2.0 are expressed by combining the two MIDI 1.0 7-bit bytes into a
    /// 14-bit number (`0 ... 16383`). They correlate exactly to MIDI 1.0 bank numbers.
    public static func bankSelect(
        msb: UInt7,
        lsb: UInt7
    ) -> Self {
        let uInt7Pair = UInt7Pair(msb: msb, lsb: lsb)
    
        return .bankSelect(UInt14(uInt7Pair: uInt7Pair))
    }
}
