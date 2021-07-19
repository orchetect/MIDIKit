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
        var portByte: MIDI.Byte = port.asUInt8
        
        if state == true {
            portByte += 0x40
        }
        
        let event1 = MIDI.Event.cc(controller: 0x0F, value: zone.midiUInt7, channel: 0)
        let event2 = MIDI.Event.cc(controller: 0x2F, value: portByte.midiUInt7, channel: 0)
        
        midiEventSendHandler?(event1)
        midiEventSendHandler?(event2)
        
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
    public func transmitFader(level: MIDI.UInt14,
                              channel: MIDI.UInt7) {
        
        guard level.isContained(in: 0...16383) else { return }
        guard channel.isContained(in: 0x0...0xF) else { return }
        
        let msb = level.bytePair.MSB.midiUInt7
        let lsb = level.bytePair.LSB.midiUInt7
        let channelHi = channel.asUInt8.midiUInt7
        let channelLow = (channel.asUInt8 + 0x20).midiUInt7
        
        let event1 = MIDI.Event.cc(controller: channelHi, value: msb, channel: 0)
        let event2 = MIDI.Event.cc(controller: channelLow, value: lsb, channel: 0)
        
        midiEventSendHandler?(event1)
        midiEventSendHandler?(event2)
        
    }
    
    /// Transmit fader touch/release message to host
    /// - parameter isTouched: `true` sends touch message, `false` sends release message
    public func transmitFader(isTouched: Bool,
                              channel: MIDI.UInt7) {
        
        guard channel.isContained(in: 0x0...0xF) else { return }
        
        let event1 = MIDI.Event.cc(controller: 0x0F, value: channel, channel: 0)
        let event2 = MIDI.Event.cc(controller: 0x2F, value: isTouched ? 0x40 : 0x00, channel: 0)
        
        midiEventSendHandler?(event1)
        midiEventSendHandler?(event2)
        
    }
    
    /// Sends a message that tells the host that the HUI device is powering on or off.
    public func transmitSystemReset() {
        
        midiEventSendHandler?(MIDI.HUI.kMIDI.kSystemResetMessage)
        
    }
    
}
