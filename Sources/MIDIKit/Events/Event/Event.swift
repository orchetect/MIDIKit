//
//  Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI {
    
    public enum Event: Equatable, Hashable {
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        /// Channel Voice Message: Note On (Status `0x9`)
        case noteOn(note: MIDI.UInt7, velocity: MIDI.UInt7, channel: MIDI.UInt4)
        
        /// Channel Voice Message: Note Off (Status `0x8`)
        case noteOff(note: MIDI.UInt7, velocity: MIDI.UInt7, channel: MIDI.UInt4)
        
        /// Channel Voice Message: Polyphonic Aftertouch (Status `0xA`)
        case polyAftertouch(note: MIDI.UInt7, pressure: MIDI.UInt7, channel: MIDI.UInt4)
        
        /// Channel Voice Message: Controller Change (CC) (Status `0xB`)
        case cc(controller: MIDI.UInt7, value: MIDI.UInt7, channel: MIDI.UInt4)
        
        /// Channel Voice Message: Program Change (Status `0xC`)
        case programChange(program: MIDI.UInt7, channel: MIDI.UInt4)
        
        /// Channel Voice Message: Channel Aftertouch (Status `0xD`)
        case chanAftertouch(pressure: MIDI.UInt7, channel: MIDI.UInt4)
        
        /// Channel Voice Message: Pitch Bend (Status `0xE`)
        case pitchBend(value: MIDI.UInt14, channel: MIDI.UInt4)
        
        // MARK: System Exclusive
        
        /// System Exclusive: Manufacturer-specific (Status `0xF0`)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Receivers should ignore non-universal Exclusive messages with ID numbers that do not correspond to their own ID."
        ///
        /// "Any manufacturer of MIDI hardware or software may use the system exclusive codes of any existing product without the permission of the original manufacturer. However, they may not modify or extend it in any way that conflicts with the original specification published by the designer. Once published, an Exclusive format is treated like any other part of the instruments MIDI implementation — so long as the new instrument remains within the definitions of the published specification."
        case sysEx(manufacturer: SysEx.Manufacturer, data: [MIDI.Byte])
        
        /// System Exclusive: Universal SysEx (Status `0xF0`)
        ///
        /// Used in both MIDI 1.0 and 2.0 spec.
        case sysExUniversal(universalType: SysEx.UniversalType,
                            deviceID: MIDI.UInt7,
                            subID1: MIDI.UInt7,
                            subID2: MIDI.UInt7,
                            data: [MIDI.Byte])
        
        // -------------------
        // MARK: System Common
        // -------------------
        
        /// System Common: Timecode Quarter-Frame (Status `0xF1`)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "For device synchronization, MIDI Time Code uses two basic types of messages, described as Quarter Frame and Full. There is also a third, optional message for encoding SMPTE user bits. The Quarter Frame message communicates the Frame, Seconds, Minutes and Hours Count in an 8-message sequence. There is also an MTC FULL FRAME message which is a MIDI System Exclusive Message."
        case timecodeQuarterFrame(byte: MIDI.Byte)
        
        /// System Common: Song Position Pointer (Status `0xF2`)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "A sequencer's Song Position (SP) is the number of MIDI beats (1 beat = 6 MIDI clocks) that have elapsed from the start of the song and is used to begin playback of a sequence from a position other than the beginning of the song."
        case songPositionPointer(midiBeat: MIDI.UInt14)
        
        /// System Common: Song Select (Status `0xF3`)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Specifies which song or sequence is to be played upon receipt of a Start message in sequencers and drum machines capable of holding multiple songs or sequences. This message should be ignored if the receiver is not set to respond to incoming Real Time messages (MIDI Sync)."
        case songSelect(number: MIDI.UInt7)
        
        /// Bus Select - unofficial (Status `0xF5`)
        case unofficialBusSelect
        
        /// System Common: Tune Request (Status `0xF6`)
        ///
        /// - remark: MIDI Spec:
        ///
        /// "Used with analog synthesizers to request that all oscillators be tuned."
        case tuneRequest
        
        // ----------------------
        // MARK: System Real Time
        // ----------------------
        
        /// System Real Time: Timing Clock (Status `0xF8`)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Clock-based MIDI systems are synchronized with this message, which is sent at a rate of 24 per quarter note. If Timing Clocks (`0xF8`) are sent during idle time they should be sent at the current tempo setting of the transmitter even while it is not playing. Receivers which are synchronized to incoming Real Time messages (MIDI Sync mode) can thus phase lock their internal clocks while waiting for a Start (`0xFA`) or Continue (`0xFB`) command."
        case timingClock
        
        /// System Real Time: Start (Status `0xFA`)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Start (`0xFA`) is sent when a PLAY button on the master (sequencer or drum machine) is pressed. This message commands all receivers which are synchronized to incoming Real Time messages (MIDI Sync mode) to start at the beginning of the song or sequence."
        case start
        
        /// System Real Time: Continue (Status `0xFB`)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Continue (`0xFB`) is sent when a CONTINUE button is hit. A sequence will continue from its current location upon receipt of the next Timing Clock (`0xF8`)."
        case `continue`
        
        /// System Real Time: Stop (Status `0xFC`)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Stop (`0xFC`) is sent when a STOP button is hit. Playback in a receiver should stop immediately."
        case stop
        
        /// System Real Time: Active Sensing (Status `0xFE`)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "Use of Active Sensing is optional for either receivers or transmitters. This byte (`0xFE`) is sent every 300 ms (maximum) whenever there is no other MIDI data being transmitted. If a device never receives Active Sensing it should operate normally. However, once the receiver recognizes Active Sensing (`0xFE`), it then will expect to get a message of some kind every 300 milliseconds. If no messages are received within this time period the receiver will assume the MIDI cable has been disconnected for some reason and should turn off all voices and return to normal operation. It is recommended that transmitters transmit Active Sensing within 270ms and receivers judge at over 330ms leaving a margin of roughly 10%."
        ///
        /// - note: Use of Active Sensing in modern MIDI devices is uncommon and the use of this standard has been deprecated as of MIDI 2.0.
        case activeSensing
        
        /// System Real Time: System Reset (Status `0xFF`)
        ///
        /// - remark: MIDI 1.0 Spec:
        ///
        /// "System Reset commands all devices in a system to return to their initialized, power-up condition. This message should be used sparingly, and should typically be sent by manual control only. It should not be sent automatically upon power-up and under no condition should this message be echoed."
        case systemReset
        
    }
    
}

extension MIDI.Event {
    
    public var rawBytes: [MIDI.Byte] {
        
        switch self {
        
        // channel voice
        
        case .noteOn(note: let note, velocity: let velocity, channel: let channel):
            return [0x90 + channel.asUInt8, note.asUInt8, velocity.asUInt8]
            
        case .noteOff(note: let note, velocity: let velocity, channel: let channel):
            return [0x80 + channel.asUInt8, note.asUInt8, velocity.asUInt8]
            
        case .cc(controller: let controller, value: let value, channel: let channel):
            _ = channel
            _ = controller
            _ = value
            return [0xB0 + channel.asUInt8, controller.asUInt8, value.asUInt8]
            
        // system
        
        case .sysEx(manufacturer: let manufacturer, data: let data):
            return [0xF0] + manufacturer.bytes + data + [0xF7]
            
        case .sysExUniversal(universalType: let universalType,
                             deviceID: let deviceID,
                             subID1: let subID1,
                             subID2: let subID2,
                             data: let data):
            return [0xF0, universalType.rawValue.uint8, deviceID.asUInt8, subID1.asUInt8, subID2.asUInt8] + data + [0xF7]
            
        default:
            fatalError("Unhandled case: \(self)")
        }
        
    }
    
}

extension MIDI.Event: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        // channel voice
        
        case .noteOn(note: let note, velocity: let velocity, channel: let channel):
            return "noteOn(note: \(note), vel: \(velocity), chan: \(channel))"
            
        case .noteOff(note: let note, velocity: let velocity, channel: let channel):
            return "noteOff(note: \(note), vel: \(velocity), chan: \(channel))"
            
        case .cc(controller: let controller, value: let value, channel: let channel):
            return "cc(num: \(controller), value: \(value), chan: \(channel))"
            
        // system
        
        case .sysEx(manufacturer: let manufacturer, data: let data):
            let dataString = data.hex.stringValue(padTo: 2, prefix: true)
            return "sysEx(mfr: \(manufacturer), data: [\(dataString)])"
            
        case .sysExUniversal(universalType: let universalType,
                             deviceID: let deviceID,
                             subID1: let subID1,
                             subID2: let subID2,
                             data: let data):
            let dataString = data.hex.stringValue(padTo: 2, prefix: true)
            return "sysExUniversal(\(universalType), deviceID: \(deviceID), subID1: \(subID1), subID2: \(subID2), data: [\(dataString)])"
            
        default:
            fatalError("Unhandled case: \(self)")
            
        }
        
    }
    
}
