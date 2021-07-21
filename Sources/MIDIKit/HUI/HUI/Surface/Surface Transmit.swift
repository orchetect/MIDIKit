//
//  Surface Transmit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import OTCore

extension MIDI.HUI.Surface {
    
    /// HUI ping message transmit to host.
    /// It is not necessary to call this manually. The `Surface` object will handle ping replies automatically.
    public func transmitPing() {
        
        midiEventSendHandler?(MIDI.HUI.kMIDI.kPingReplyToHostMessage)
        
    }
    
    /// Transmit switch state to host.
    /// - Parameters:
    ///   - zone: HUI zone number
    ///   - port: HUI port number
    ///   - state: State of switch or action
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
    
    /// Transmit switch state to host.
    public func transmitSwitch(_ param: MIDI.HUI.Parameter,
                               state: Bool) {
        
        let zoneAndPort = param.zoneAndPort
        
        transmitSwitch(zone: zoneAndPort.zone,
                       port: zoneAndPort.port,
                       state: state)
        
    }
    
    /// Transmit fader level to host.
    /// - parameters:
    ///   - level: 0...16383
    ///   - channel: 0...7
    public func transmitFader(level: MIDI.UInt14,
                              channel: Int) {
        
        guard level.isContained(in: 0...16383) else { return }
        guard channel.isContained(in: 0x0...0x7) else { return }
        
        let msb = level.bytePair.MSB.midiUInt7
        let lsb = level.bytePair.LSB.midiUInt7
        let channelHi = channel.midiUInt7
        let channelLow = (channel + 0x20).midiUInt7
        
        let event1 = MIDI.Event.cc(controller: channelHi, value: msb, channel: 0)
        let event2 = MIDI.Event.cc(controller: channelLow, value: lsb, channel: 0)
        
        midiEventSendHandler?(event1)
        midiEventSendHandler?(event2)
        
    }
    
    /// Transmit fader touch/release message to host.
    /// - parameters:
    ///   - isTouched: `true` sends touch message, `false` sends release message
    ///   - channel: 0...7
    public func transmitFader(isTouched: Bool,
                              channel: Int) {
        
        guard channel.isContained(in: 0x0...0x7) else { return }
        
        let event1 = MIDI.Event.cc(controller: 0x0F, value: channel.midiUInt7, channel: 0)
        let event2 = MIDI.Event.cc(controller: 0x2F, value: isTouched ? 0x40 : 0x00, channel: 0)
        
        midiEventSendHandler?(event1)
        midiEventSendHandler?(event2)
        
    }
    
    /// Sends a message that tells the host that the HUI device is powering on or off.
    public func transmitSystemReset() {
        
        midiEventSendHandler?(MIDI.HUI.kMIDI.kSystemResetMessage)
        
    }
    
}
