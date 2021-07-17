//
//  Surface Transmit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import OTCore

extension MIDI.HUI.Surface {
    
    /// Most basic switch transmit function
    public func transmitSwitch(zone: Int,
                               port: Int,
                               state: Bool) {
        
        //set on off byte
        var portByte: Int
        
        if state == true {
            portByte = port + 0x40
        } else {
            portByte = port
        }
        
        midiEventSendHandler?([0xb0, 0x0f, MIDI.Byte(zone)])            // zone select
        midiEventSendHandler?([0xb0, 0x2f, MIDI.Byte(portByte)])        // switch message
        
    }
    
    /// Convenience function to set a switch by referencing its `kHUIZonePortName` enumeration
    @discardableResult
    public func transmitSwitch(switchName: MIDI.HUI.Parameter,
                               state: Bool) -> Bool {
        
        guard let lookup = MIDI.HUI.kHUIZoneAndPortPairs[switchName]
        else { return false }
        
        transmitSwitch(zone: lookup.zone,
                       port: lookup.port,
                       state: state)
        return true
        
    }
    
    /// Convenience function to set a channel strip-related switch. Returns true if succeeded.
    /// - parameter channelStrip: HUI channel strip (0-7)
    @discardableResult
    public func transmitSwitch(channelStrip: Int,
                               param: MIDI.HUI.ChannelStripElement,
                               state: Bool) -> Bool {
        
        guard let lookupZP = MIDI.HUI.Parameter(channelStrip: channelStrip,
                                                channelElement: param)
        else { return false }
        
        return transmitSwitch(switchName: lookupZP,
                              state: state)
        
    }
    
    /// Transmit fader level to host
    /// - parameter level: between 0 - 16383
    public func transmitFader(level: Int,
                              channel: Int) {
        
        guard level >= 0 && level <= 16383 else { return }
        guard channel >= 0x0 && channel <= 0xF else { return }
        
        let hi = level / 128;
        let low = level % 128;
        let channelHi = channel;
        let channelLow = channel + 0x20;
        
        midiEventSendHandler?([0xb0, UInt8(channelHi), UInt8(hi), 0xb0, UInt8(channelLow), UInt8(low)])
        
    }
    
    /// Transmit fader touch/release message to host
    /// - parameter isTouched: `true` sends touch message, `false` sends release message
    public func transmitFader(isTouched: Bool,
                              channel: Int) {
        
        guard channel >= 0x0 && channel <= 0xF else { return }
        
        midiEventSendHandler?([0xb0, 0x0f, UInt8(channel), 0xb0, 0x2f, isTouched ? 0x40 : 0x00])
        
    }
    
    /// Sends a message that tells the host that the HUI unit is powering on or off.
    public func transmitSystemReset() {
        
        Log.debug("MIDI.HUI: Sending system reset message.")
        
        // I believe this is correct but not sure if it's multiple 0xff bytes or just one.
        midiEventSendHandler?(MIDI.HUI.kMIDI.kSystemResetMessage)
        
    }
    
}
