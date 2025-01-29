//
//  HUIConstants.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

// MARK: - HUI System Constants

/// Namespace for HUI constants.
@usableFromInline
enum HUIConstants { }

extension HUIConstants {
    /// HUI MIDI constants.
    @usableFromInline
    enum kMIDI {
        // MARK: System messages
        
        /// Status 0x9 is normally channel voice note-on, but HUI hijacks it.
        /// [0x90, 0x00, 0x00]
        @inlinable
        static var kPingToSurfaceMessage: MIDIEvent {
            .noteOn(0, velocity: .midi1(0x00), channel: 0)
        }
        
        /// Status 0x9 is normally channel voice note-on, but HUI hijacks it.
        /// [0x90, 0x00, 0x7F]
        @inlinable
        static var kPingReplyToHostMessage: MIDIEvent {
            .noteOn(
                0,
                velocity: .midi1(0x7F),
                channel: 0
            )
        }
        
        @inlinable
        static var kSystemResetMessage: MIDIEvent { .systemReset() } // [0xFF]
        
        /// [0xF0, 0x00, 0x00, 0x66, 0x05, 0x00]
        @usableFromInline
        enum kSysEx {
            /// Mackie SysEx Manufacturer ID
            @inlinable
            static var kManufacturer: MIDIEvent.SysExManufacturer {
                .threeByte(
                    byte2: 0x00,
                    byte3: 0x66
                )
            }
            @inlinable
            static var kSubID1: UInt7 { 0x05 } // product ID?
            
            @inlinable
            static var kSubID2: UInt7 { 0x00 }
        }
        
        @usableFromInline
        enum kDisplayType {
            /// 4-character channel name displays, and Select-Assign displays.
            @inlinable
            static var smallByte: UInt7 { 0x10 }
            
            /// Main time display.
            @inlinable
            static var timeDisplayByte: UInt7 { 0x11 }
            
            /// Main 40 x 2 character display.
            @inlinable
            static var largeByte: UInt7 { 0x12 }
        }
        
        /// Status 0xA is normally MIDI poly aftertouch, but HUI hijacks it.
        @inlinable
        static var kLevelMetersStatus: UInt8 { 0xA0 }
        
        // MARK: Control events
        
        /// Status 0xB is normally channel voice control change, but HUI hijacks it.
        /// HUI only ever uses first channel, so the status byte will always be exactly 0xB0.
        /// HUI also uses running status for back-to-back 0xB status messages.
        @inlinable
        static var kControlStatus: UInt8 { 0xB0 }
        
        /// For sending and receiving HUI, switch messages, the zone select
        /// and port byte uses a different lower nibble depending on transmit direction.
        @usableFromInline
        enum kControlDataByte1 {
            @inlinable
            static var zoneSelectByteToSurface: UInt8 { 0x0C }
            
            @inlinable
            static var zoneSelectByteToHost: UInt8 { 0x0F }
            
            @inlinable
            static var portOnOffByteToSurface: UInt8 { 0x2C }
            
            @inlinable
            static var portOnOffByteToHost: UInt8 { 0x2F }
        }
        
        @usableFromInline
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
        
        @inlinable
        static var kSysExStartByte: UInt8 { 0xF0 }
        @inlinable
        static var kSysExEndByte: UInt8 { 0xF7 }
    }
}
