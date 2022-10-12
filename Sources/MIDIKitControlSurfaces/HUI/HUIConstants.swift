//
//  HUIConstants.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

// MARK: - HUI System Constants

/// Namespace for HUI constants.
enum HUIConstants { }

extension HUIConstants {
    /// HUI MIDI constants.
    enum kMIDI {
        // MARK: System messages
        
        // Status 0x9 is normally channel voice note-on, but HUI hijacks it.
        // [0x90, 0x00, 0x00]
        static let kPingToSurfaceMessage: MIDIEvent = .noteOn(0, velocity: .midi1(0x00), channel: 0)
        
        // Status 0x9 is normally channel voice note-on, but HUI hijacks it.
        // [0x90, 0x00, 0x7F]
        static let kPingReplyToHostMessage: MIDIEvent = .noteOn(
            0,
            velocity: .midi1(0x7F),
            channel: 0
        )
        
        static let kSystemResetMessage: MIDIEvent = .systemReset() // [0xFF]
        
        // [0xF0, 0x00, 0x00, 0x66, 0x05, 0x00]
        enum kSysEx {
            /// Mackie SysEx Manufacturer ID
            public static let kManufacturer: MIDIEvent.SysExManufacturer = .threeByte(
                byte2: 0x00,
                byte3: 0x66
            )
            public static let kSubID1: UInt8 = 0x05 // product ID?
            public static let kSubID2: UInt8 = 0x00
        }
        
        enum kDisplayType {
            /// 4-character channel name displays, and Select-Assign displays.
            public static let smallByte: UInt8 = 0x10
            /// Main time display.
            public static let timeDisplayByte: UInt8 = 0x11
            /// Main 40 x 2 character display.
            public static let largeByte: UInt8 = 0x12
        }
        
        // Status 0xA is normally MIDI poly aftertouch, but HUI hijacks it.
        static let kLevelMetersStatus: UInt8 = 0xA0
        
        // MARK: Control events
        
        // Status 0xB is normally channel voice control change, but HUI hijacks it.
        // HUI only ever uses first channel, so the status byte will always be exactly 0xB0.
        // HUI also uses running status for back-to-back 0xB status messages.
        static let kControlStatus: UInt8 = 0xB0
        
        // For sending and receiving HUI, switch messages, the zone select
        // and port byte uses a different lower nibble depending on transmit direction.
        enum kControlDataByte1 {
            public static let zoneSelectByteToSurface: UInt8 = 0x0C
            public static let zoneSelectByteToHost: UInt8 =    0x0F
            
            public static let portOnOffByteToSurface: UInt8 =  0x2C
            public static let portOnOffByteToHost: UInt8 =     0x2F
        }
        
        enum kChannelStripElement: UInt4, Equatable, Hashable {
            case fader  = 0x0
            case select = 0x1
            case mute   = 0x2
            case solo   = 0x3
            case auto   = 0x4
            case vSel   = 0x5
            case insert = 0x6
            case rec    = 0x7
        }
        
        static let kSysExStartByte: UInt8 = 0xF0
        static let kSysExEndByte: UInt8 = 0xF7
    }
}
