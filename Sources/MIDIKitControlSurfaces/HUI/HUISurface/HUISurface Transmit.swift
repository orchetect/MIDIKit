//
//  HUISurface Transmit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUISurface {
    /// Transmit a HUI ping message to the host.
    /// It is not necessary to call this manually. The ``HUISurface`` object will handle ping
    /// replies automatically.
    func transmitPing() {
        let event = encodeHUIPing(to: .host)
        midiOut(event)
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
        
        let events = encodeHUISwitch(
            zone: zoneAndPort.zone,
            port: zoneAndPort.port,
            state: state,
            to: .host
        )
        midiOut(events)
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
    
    /// Transmit V-Pot rotary knob delta change to the host.
    ///
    /// - Parameters:
    ///   - vPot: V-Pot identity.
    ///   - delta: Delta change amount as a 7-bit signed integer (clamped to `-63 ... 63`).
    public func transmitVPot(
        delta: Int7,
        for vPot: HUIVPot
    ) {
        // don't bother sending events for a 0 delta
        // which means no change
        guard delta != 0 else { return }
        
        let event = encodeHUIVPot(
            delta: delta,
            for: vPot
        )
        midiOut(event)
    }
    
    /// Transmit Jog Wheel delta change to the host.
    public func transmitJogWheel(
        delta: Int7
    ) {
        // don't bother sending events for a 0 delta
        // which means no change
        guard delta != 0 else { return }
        
        let event = encodeJogWheel(delta: delta)
        midiOut(event)
    }
    
    /// Sends a message that tells the host that the HUI surface is powering on or off.
    public func transmitSystemReset() {
        midiOut(HUIConstants.kMIDI.kSystemResetMessage)
    }
}
