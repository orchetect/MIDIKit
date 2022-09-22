//
//  HUISurface Transmit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUISurface {
    /// Transmit a HUI ping message to the host.
    /// It is not necessary to call this manually. The ``HUISurface`` object will handle ping replies automatically.
    public func transmitPing() {
        let event = encodeHUIPing(to: .host)
        midiOut(event)
    }
    
    /// Transmit switch state to host.
    ///
    /// - Parameters:
    ///   - zone: HUI zone number.
    ///   - port: HUI port number.
    ///   - state: State of switch or action.
    internal func transmitSwitch(
        zone: HUIZone,
        port: HUIPort,
        state: Bool
    ) {
        let events = encodeHUISwitch(
            zone: zone,
            port: port,
            state: state,
            to: .host
        )
        midiOut(events)
    }
    
    /// Transmit switch state to the host.
    ///
    /// - Parameters:
    ///   - huiSwitch: Switch parameter.
    ///   - state: Switch state.
    public func transmitSwitch(
        _ huiSwitch: HUISwitch,
        state: Bool
    ) {
        let zoneAndPort = huiSwitch.zoneAndPort
        
        transmitSwitch(
            zone: zoneAndPort.zone,
            port: zoneAndPort.port,
            state: state
        )
    }
    
    /// Transmit fader level to the host.
    ///
    /// - Parameters:
    ///   - level: `0 ... 16383`
    ///   - channel: `0 ... 7`
    public func transmitFader(
        level: UInt14,
        channel: UInt4
    ) {
        let events = encodeHUIFader(level: level, channel: channel)
        midiOut(events)
    }
    
    /// Transmit fader touch/release message to the host.
    /// 
    /// - Parameters:
    ///   - isTouched: `true` sends touch message, `false` sends release message.
    ///   - channel: `0 ... 7`
    public func transmitFader(
        isTouched: Bool,
        channel: UInt4
    ) {
        let events = encodeHUIFader(isTouched: isTouched, channel: channel)
        midiOut(events)
    }
    
    /// Transmit V-Pot rotary knob delta change to the client surface.
    ///
    /// - Parameters:
    ///   - vPot: V-Pot identity.
    ///   - delta: Delta change amount as a 7-bit signed integer (`-64 ... 63`).
    public func transmitVPot(
        for vPot: HUIVPot,
        delta: Int7
    ) {
        let event = encodeHUIVPotValue(for: vPot, rawValue: delta.rawUInt7Byte)
        midiOut(event)
    }
    
    /// Sends a message that tells the host that the HUI device is powering on or off.
    public func transmitSystemReset() {
        midiOut(HUIConstants.kMIDI.kSystemResetMessage)
    }
}
