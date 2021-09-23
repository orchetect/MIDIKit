//
//  Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI {
    
    /// MIDI Event
    public enum Event: Equatable, Hashable {
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        /// Channel Voice Message: Note On
        case noteOn(Note.On)
        
        /// Channel Voice Message: Note Off
        case noteOff(Note.Off)
        
        /// Channel Voice Message: Polyphonic Aftertouch
        ///
        /// DAWs have slightly different terminology for this:
        /// - Pro Tools: "Polyphonic Aftertouch"
        /// - Logic Pro: "Polyphonic Aftertouch"
        /// - Cubase: "Poly Pressure"
        case polyAftertouch(PolyAftertouch)
        
        /// Channel Voice Message: Controller Change (CC)
        case cc(CC)
        
        /// Channel Voice Message: Program Change
        case programChange(ProgramChange)
        
        /// Channel Voice Message: Channel Aftertouch
        ///
        /// DAWs have slightly different terminology for this:
        /// - Pro Tools: "Mono Aftertouch"
        /// - Logic Pro: "Aftertouch"
        /// - Cubase: "Aftertouch"
        case chanAftertouch(ChanAftertouch)
        
        /// Channel Voice Message: Pitch Bend
        case pitchBend(PitchBend)
        
        
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
        /// System Exclusive: Manufacturer-specific
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Receivers should ignore non-universal Exclusive messages with ID numbers that do not correspond to their own ID."
        ///
        /// "Any manufacturer of MIDI hardware or software may use the system exclusive codes of any existing product without the permission of the original manufacturer. However, they may not modify or extend it in any way that conflicts with the original specification published by the designer. Once published, an Exclusive format is treated like any other part of the instruments MIDI implementation — so long as the new instrument remains within the definitions of the published specification."
        case sysEx(SysEx)
        
        /// System Exclusive: Universal SysEx
        ///
        /// Used in both MIDI 1.0 and 2.0 spec.
        ///
        /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See the official MIDI 1.0 and 2.0 specs for details.
        ///
        /// - `deviceID` of 0x7F indicates "All Devices".
        case universalSysEx(UniversalSysEx)
        
        
        // -------------------
        // MARK: System Common
        // -------------------
        
        /// System Common: Timecode Quarter-Frame
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "For device synchronization, MIDI Time Code uses two basic types of messages, described as Quarter Frame and Full. There is also a third, optional message for encoding SMPTE user bits. The Quarter Frame message communicates the Frame, Seconds, Minutes and Hours Count in an 8-message sequence. There is also an MTC FULL FRAME message which is a MIDI System Exclusive Message."
        case timecodeQuarterFrame(TimecodeQuarterFrame)
        
        /// System Common: Song Position Pointer
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "A sequencer's Song Position (SP) is the number of MIDI beats (1 beat = 6 MIDI clocks) that have elapsed from the start of the song and is used to begin playback of a sequence from a position other than the beginning of the song."
        case songPositionPointer(SongPositionPointer)
        
        /// System Common: Song Select
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Specifies which song or sequence is to be played upon receipt of a Start message in sequencers and drum machines capable of holding multiple songs or sequences. This message should be ignored if the receiver is not set to respond to incoming Real Time messages (MIDI Sync)."
        case songSelect(SongSelect)
        
        /// Bus Select - unofficial
        case unofficialBusSelect(UnofficialBusSelect)
        
        /// System Common: Tune Request (Status `0xF6`)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Used with analog synthesizers to request that all oscillators be tuned."
        case tuneRequest(TuneRequest)
        
        
        // ----------------------
        // MARK: System Real Time
        // ----------------------
        
        /// System Real Time: Timing Clock
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Clock-based MIDI systems are synchronized with this message, which is sent at a rate of 24 per quarter note. If Timing Clocks (`0xF8`) are sent during idle time they should be sent at the current tempo setting of the transmitter even while it is not playing. Receivers which are synchronized to incoming Real Time messages (MIDI Sync mode) can thus phase lock their internal clocks while waiting for a Start (`0xFA`) or Continue (`0xFB`) command."
        case timingClock(TimingClock)
        
        /// System Real Time: Start
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Start (`0xFA`) is sent when a PLAY button on the master (sequencer or drum machine) is pressed. This message commands all receivers which are synchronized to incoming Real Time messages (MIDI Sync mode) to start at the beginning of the song or sequence."
        case start(Start)
        
        /// System Real Time: Continue
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Continue (`0xFB`) is sent when a CONTINUE button is hit. A sequence will continue from its current location upon receipt of the next Timing Clock (`0xF8`)."
        case `continue`(Continue)
        
        /// System Real Time: Stop
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Stop (`0xFC`) is sent when a STOP button is hit. Playback in a receiver should stop immediately."
        case stop(Stop)
        
        /// System Real Time: Active Sensing
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Use of Active Sensing is optional for either receivers or transmitters. This byte (`0xFE`) is sent every 300 ms (maximum) whenever there is no other MIDI data being transmitted. If a device never receives Active Sensing it should operate normally. However, once the receiver recognizes Active Sensing (`0xFE`), it then will expect to get a message of some kind every 300 milliseconds. If no messages are received within this time period the receiver will assume the MIDI cable has been disconnected for some reason and should turn off all voices and return to normal operation. It is recommended that transmitters transmit Active Sensing within 270ms and receivers judge at over 330ms leaving a margin of roughly 10%."
        ///
        /// - note: Use of Active Sensing in modern MIDI devices is uncommon and the use of this standard has been deprecated as of MIDI 2.0.
        case activeSensing(ActiveSensing)
        
        /// System Real Time: System Reset
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "System Reset commands all devices in a system to return to their initialized, power-up condition. This message should be used sparingly, and should typically be sent by manual control only. It should not be sent automatically upon power-up and under no condition should this message be echoed."
        case systemReset(SystemReset)
        
    }
    
}
