//
//  Surface Transmit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import OTCore

extension MIDI.HUI.Surface {
    
    /// HUI ping message transmit function
    public func transmitPing() {
        
        midiEventSendHandler?(MIDI.HUI.kMIDI.kPingReplyToHostMessage)
        
    }
    
    /// Most basic switch transmit function
    internal func transmitSwitch(zone: MIDI.Byte,
                                 port:  MIDI.UInt4,
                                 state: Bool) {
        
        // set on off byte
        var portByte: MIDI.Byte
        
        if state == true {
            portByte = port.asUInt8 + 0x40
        } else {
            portByte = port.asUInt8
        }
        
        midiEventSendHandler?([0xB0, 0x0F, zone,
                               0xB0, 0x2F, portByte])
        
    }
    
    /// Convenience function to set a switch by referencing its `kHUIZonePortName` enumeration
    public func transmitSwitch(_ param: MIDI.HUI.Parameter,
                               state: Bool) {
        
        let zoneAndPort = param.zoneAndPort
        
        transmitSwitch(zone: zoneAndPort.zone,
                       port: zoneAndPort.port,
                       state: state)
        
    }
    
    /// Transmit fader level to host
    /// - parameter level: between 0 - 16383
    public func transmitFader(level: Int,
                              channel: MIDI.UInt7) {
        
        guard level.isContained(in: 0...16383) else { return }
        guard channel.isContained(in: 0x0...0xF) else { return }
        
        let hi = level / 128;
        let low = level % 128;
        let channelHi = channel.asUInt8;
        let channelLow = channel.asUInt8 + 0x20;
        
        // use running status to send two 0xB0 status messages in one packet
        midiEventSendHandler?([0xB0,
                               channelHi, hi.uint8,
                               channelLow, low.uint8])
        
    }
    
    /// Transmit fader touch/release message to host
    /// - parameter isTouched: `true` sends touch message, `false` sends release message
    public func transmitFader(isTouched: Bool,
                              channel: MIDI.UInt7) {
        
        guard channel.isContained(in: 0x0...0xF) else { return }
        
        // use running status to send two 0xB0 status messages in one packet
        midiEventSendHandler?([0xB0,
                               0x0F, channel.asUInt8,
                               0x2F, isTouched ? 0x40 : 0x00])
        
    }
    
    /// Sends a message that tells the host that the HUI device is powering on or off.
    public func transmitSystemReset() {
        
        Log.debug("Sending system reset message.")
        
        // I believe this is correct but not sure if it's multiple 0xff bytes or just one.
        midiEventSendHandler?(MIDI.HUI.kMIDI.kSystemResetMessage)
        
    }
    
}
