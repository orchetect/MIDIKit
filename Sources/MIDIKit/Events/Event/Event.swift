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
        
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
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
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        case .noteOn(note: let note, velocity: let velocity, channel: let channel):
            return [0x90 + channel.uint8, note.uint8, velocity.uint8]
            
        case .noteOff(note: let note, velocity: let velocity, channel: let channel):
            return [0x80 + channel.uint8, note.uint8, velocity.uint8]
            
        case .polyAftertouch(note: let note, pressure: let pressure, channel: let channel):
            return [0xA0 + channel.uint8, note.uint8, pressure.uint8]
            
        case .cc(controller: let controller, value: let value, channel: let channel):
            return [0xB0 + channel.uint8, controller.uint8, value.uint8]
            
        case .programChange(program: let program, channel: let channel):
            return [0xC0 + channel.uint8, program.uint8]
            
        case .chanAftertouch(pressure: let pressure, channel: let channel):
            return [0xD0 + channel.uint8, pressure.uint8]
            
        case .pitchBend(value: let value, channel: let channel):
            let bytePair = value.bytePair
            return [0xE0 + channel.uint8, bytePair.LSB, bytePair.MSB]
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
        case .sysEx(manufacturer: let manufacturer, data: let data):
            return [0xF0] + manufacturer.bytes + data + [0xF7]
            
        case .sysExUniversal(universalType: let universalType,
                             deviceID: let deviceID,
                             subID1: let subID1,
                             subID2: let subID2,
                             data: let data):
            return [0xF0, universalType.rawValue.uint8, deviceID.uint8, subID1.uint8, subID2.uint8] + data + [0xF7]
            
        // -------------------
        // MARK: System Common
        // -------------------
        
        case .timecodeQuarterFrame(byte: let byte):
            return [0xF1, byte]
            
        case .songPositionPointer(midiBeat: let midiBeat):
            let bytePair = midiBeat.bytePair
            return [0xF2, bytePair.LSB, bytePair.MSB]
            
        case .songSelect(number: let number):
            return [0xF3, number.uint8]
            
        case .unofficialBusSelect:
            return [0xF5]
            
        case .tuneRequest:
            return [0xF6]
            
        // ----------------------
        // MARK: System Real Time
        // ----------------------
            
        case .timingClock:
            return [0xF8]
            
        case .start:
            return [0xFA]
            
        case .continue:
            return [0xFB]
            
        case .stop:
            return [0xFC]
            
        case .activeSensing:
            return [0xFE]
            
        case .systemReset:
            return [0xFF]
            
        }
        
    }
    
}

extension MIDI.Event: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        // -------------------
        // MARK: Channel Voice
        // -------------------
        
        case .noteOn(note: let note, velocity: let velocity, channel: let channel):
            return "noteOn(\(note), vel: \(velocity), chan: \(channel))"
            
        case .noteOff(note: let note, velocity: let velocity, channel: let channel):
            return "noteOff(\(note), vel: \(velocity), chan: \(channel))"
                
        case .polyAftertouch(note: let note, pressure: let pressure, channel: let channel):
            return "polyAftertouch(note:\(note), pressure: \(pressure), chan: \(channel))"
        
        case .cc(controller: let controller, value: let value, channel: let channel):
            return "cc(\(controller), val: \(value), chan: \(channel))"
            
        case .programChange(program: let program, channel: let channel):
            return "prgChange(\(program), chan: \(channel))"
            
        case .chanAftertouch(pressure: let pressure, channel: let channel):
            return "chanAftertouch(pressure: \(pressure), chan: \(channel))"
            
        case .pitchBend(value: let value, channel: let channel):
            return "pitchBend(\(value), chan: \(channel))"
            
        // ----------------------
        // MARK: System Exclusive
        // ----------------------
        
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
            
        // -------------------
        // MARK: System Common
        // -------------------
        
        case .timecodeQuarterFrame(byte: let byte):
            return "timecodeQF(\(byte.binary.stringValue(prefix: true)))"
            
        case .songPositionPointer(midiBeat: let midiBeat):
            return "songPositionPointer(beat: \(midiBeat))"
            
        case .songSelect(number: let number):
            return "songSelect(number: \(number))"
            
        case .unofficialBusSelect:
            return "unofficialBusSelect"
            
        case .tuneRequest:
            return "tuneRequest"
            
        // ----------------------
        // MARK: System Real Time
        // ----------------------
            
        case .timingClock:
            return "timingClock"
            
        case .start:
            return "start"
            
        case .continue:
            return "continue"
            
        case .stop:
            return "stop"
            
        case .activeSensing:
            return "activeSensing"
            
        case .systemReset:
            return "systemReset"
        
        }
        
    }
    
}
