//
//  Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI {
    
    /// MIDI Event
    public enum Event: Equatable, Hashable {
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        /// Channel Voice Message: Note On
        /// (MIDI 1.0 / 2.0)
        case noteOn(Note.On)
        
        /// Channel Voice Message: Note Off
        /// (MIDI 1.0 / 2.0)
        case noteOff(Note.Off)
        
        /// Channel Voice Message: Per-Note Control Change (CC)
        /// (MIDI 2.0)
        case noteCC(Note.CC)
        
        /// Channel Voice Message: Per-Note Pitch Bend
        /// (MIDI 2.0)
        case notePitchBend(Note.PitchBend)
        
        /// Channel Voice Message: Per-Note Aftertouch (Polyphonic Aftertouch)
        /// (MIDI 1.0 / 2.0)
        ///
        /// Also known as:
        /// - Pro Tools: "Polyphonic Aftertouch"
        /// - Logic Pro: "Polyphonic Aftertouch"
        /// - Cubase: "Poly Pressure"
        case notePressure(Note.Pressure)
        
        /// Channel Voice Message: Per-Note Management
        /// (MIDI 2.0)
        ///
        /// The MIDI 2.0 Protocol introduces a Per-Note Management message to enable independent control from Per- Note Controllers to multiple Notes on the same Note Number.
        case noteManagement(Note.Management)
        
        /// Channel Voice Message: Channel Control Change (CC)
        /// (MIDI 1.0 / 2.0)
        case cc(CC)
        
        /// Channel Voice Message: Channel Program Change
        /// (MIDI 1.0 / 2.0)
        case programChange(ProgramChange)
        
        /// Channel Voice Message: Channel Pitch Bend
        /// (MIDI 1.0 / 2.0)
        case pitchBend(PitchBend)
        
        /// Channel Voice Message: Channel Pressure (Aftertouch)
        /// (MIDI 1.0 / 2.0)
        ///
        /// Also known as:
        /// - Pro Tools: "Mono Aftertouch"
        /// - Logic Pro: "Aftertouch"
        /// - Cubase: "Aftertouch"
        case pressure(Pressure)
        
        
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
        /// System Exclusive: Manufacturer-specific (7-bit)
        /// (MIDI 1.0 / 2.0)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Receivers should ignore non-universal Exclusive messages with ID numbers that do not correspond to their own ID."
        ///
        /// "Any manufacturer of MIDI hardware or software may use the system exclusive codes of any existing product without the permission of the original manufacturer. However, they may not modify or extend it in any way that conflicts with the original specification published by the designer. Once published, an Exclusive format is treated like any other part of the instruments MIDI implementation — so long as the new instrument remains within the definitions of the published specification."
        case sysEx7(SysEx7)
        
        /// Universal System Exclusive (7-bit)
        /// (MIDI 1.0 / 2.0)
        ///
        /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See the official MIDI 1.0 and 2.0 specs for details.
        ///
        /// - `deviceID` of 0x7F indicates "All Devices".
        case universalSysEx7(UniversalSysEx7)
        
        /// System Exclusive: Manufacturer-specific (8-bit)
        /// (MIDI 2.0 only)
        ///
        /// - remark: MIDI 2.0 Spec:
        ///
        /// - "System Exclusive 8 messages have many similarities to the MIDI 1.0 Protocol’s original System Exclusive messages, but with the added advantage of allowing all 8 bits of each data byte to be used. By contrast, MIDI 1.0 Protocol System Exclusive requires a 0 in the high bit of every data byte, leaving only 7 bits to carry actual data. A System Exclusive 8 Message is carried in one or more 128-bit UMPs."
        case sysEx8(SysEx8)
        
        /// Universal System Exclusive (8-bit)
        /// (MIDI 2.0 only)
        ///
        /// - `deviceID` of 0x7F indicates "All Devices".
        case universalSysEx8(UniversalSysEx8)
        
        
        // -------------------
        // MARK: System Common
        // -------------------
        
        /// System Common: Timecode Quarter-Frame
        /// (MIDI 1.0 / 2.0)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "For device synchronization, MIDI Time Code uses two basic types of messages, described as Quarter Frame and Full. There is also a third, optional message for encoding SMPTE user bits. The Quarter Frame message communicates the Frame, Seconds, Minutes and Hours Count in an 8-message sequence. There is also an MTC FULL FRAME message which is a MIDI System Exclusive Message."
        case timecodeQuarterFrame(TimecodeQuarterFrame)
        
        /// System Common: Song Position Pointer
        /// (MIDI 1.0 / 2.0)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "A sequencer's Song Position (SP) is the number of MIDI beats (1 beat = 6 MIDI clocks) that have elapsed from the start of the song and is used to begin playback of a sequence from a position other than the beginning of the song."
        case songPositionPointer(SongPositionPointer)
        
        /// System Common: Song Select
        /// (MIDI 1.0 / 2.0)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Specifies which song or sequence is to be played upon receipt of a Start message in sequencers and drum machines capable of holding multiple songs or sequences. This message should be ignored if the receiver is not set to respond to incoming Real Time messages (MIDI Sync)."
        case songSelect(SongSelect)
        
        /// Unofficial Bus Select (Status `0xF5`)
        ///
        /// This command is not officially supported and some MIDI subsystems will ignore it entirely. It is provided purely for legacy support and its use is discouraged.
        ///
        /// "Some vendors have produced boxes with a single MIDI input, and multiple MIDI outputs. The Bus Select message specifies which of the outputs further data should be sent to. This is not an official message; the vendors in question should have used a SysEx command." -- [David Van Brink's MIDI Spec](https://www.cs.cmu.edu/~music/cmsip/readings/davids-midi-spec.htm)
        case unofficialBusSelect(UnofficialBusSelect)
        
        /// System Common: Tune Request
        /// (MIDI 1.0 / 2.0)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Used with analog synthesizers to request that all oscillators be tuned."
        case tuneRequest(TuneRequest)
        
        
        // ----------------------
        // MARK: System Real Time
        // ----------------------
        
        /// System Real Time: Timing Clock
        /// (MIDI 1.0 / 2.0)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Clock-based MIDI systems are synchronized with this message, which is sent at a rate of 24 per quarter note. If Timing Clocks (`0xF8`) are sent during idle time they should be sent at the current tempo setting of the transmitter even while it is not playing. Receivers which are synchronized to incoming Real Time messages (MIDI Sync mode) can thus phase lock their internal clocks while waiting for a Start (`0xFA`) or Continue (`0xFB`) command."
        case timingClock(TimingClock)
        
        /// System Real Time: Start
        /// (MIDI 1.0 / 2.0)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Start (`0xFA`) is sent when a PLAY button on the master (sequencer or drum machine) is pressed. This message commands all receivers which are synchronized to incoming Real Time messages (MIDI Sync mode) to start at the beginning of the song or sequence."
        case start(Start)
        
        /// System Real Time: Continue
        /// (MIDI 1.0 / 2.0)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Continue (`0xFB`) is sent when a CONTINUE button is hit. A sequence will continue from its current location upon receipt of the next Timing Clock (`0xF8`)."
        case `continue`(Continue)
        
        /// System Real Time: Stop
        /// (MIDI 1.0 / 2.0)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Stop (`0xFC`) is sent when a STOP button is hit. Playback in a receiver should stop immediately."
        case stop(Stop)
        
        /// System Real Time: Active Sensing
        /// (MIDI 1.0)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Use of Active Sensing is optional for either receivers or transmitters. This byte (`0xFE`) is sent every 300 ms (maximum) whenever there is no other MIDI data being transmitted. If a device never receives Active Sensing it should operate normally. However, once the receiver recognizes Active Sensing (`0xFE`), it then will expect to get a message of some kind every 300 milliseconds. If no messages are received within this time period the receiver will assume the MIDI cable has been disconnected for some reason and should turn off all voices and return to normal operation. It is recommended that transmitters transmit Active Sensing within 270ms and receivers judge at over 330ms leaving a margin of roughly 10%."
        ///
        /// - note: Use of Active Sensing in modern MIDI devices is uncommon and the use of this standard has been deprecated as of MIDI 2.0.
        case activeSensing(ActiveSensing)
        
        /// System Real Time: System Reset
        /// (MIDI 1.0 / 2.0)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "System Reset commands all devices in a system to return to their initialized, power-up condition. This message should be used sparingly, and should typically be sent by manual control only. It should not be sent automatically upon power-up and under no condition should this message be echoed."
        case systemReset(SystemReset)
        
        
        // -------------------------------
        // MARK: MIDI 2.0 Utility Messages
        // -------------------------------
        
        /// NOOP - No Operation
        /// (MIDI 2.0 Utility Messages)
        ///
        /// - remark: MIDI 2.0 Spec:
        ///
        /// "The UMP Format provides a set of Utility Messages. Utility Messages include but are not limited to NOOP and timestamps, and might in the future include UMP transport-related functions."
        case noOp(NoOp)
        
        /// JR Clock (Jitter-Reduction Clock)
        /// (MIDI 2.0 Utility Messages)
        ///
        /// - remark: MIDI 2.0 Spec:
        ///
        /// "The JR Clock message defines the current time of the Sender.
        ///
        /// A 16-bit time value in clock ticks of 1/31250 of one second (32 μsec, clock frequency of 1 MHz / 32).
        ///
        /// The time value is expected to wrap around every 2.09712 seconds.
        ///
        /// To avoid ambiguity of the 2.09712 seconds wrap, and to provide sufficient JR Clock messages for the Receiver, the Sender shall send a JR Clock message at least once every 250 milliseconds."
        case jrClock(JRClock)
        
        /// JR Timestamp (Jitter-Reduction Timestamp)
        /// (MIDI 2.0 Utility Messages)
        ///
        /// - remark: MIDI 2.0 Spec:
        ///
        /// "The JR Timestamp message defines the time of the following message(s). It is a complete message.
        ///
        /// A 16-bit time value in clock ticks of 1/31250 of one second (32 μsec, clock frequency of 1 MHz / 32)."
        case jrTimestamp(JRTimestamp)
    }
    
}
