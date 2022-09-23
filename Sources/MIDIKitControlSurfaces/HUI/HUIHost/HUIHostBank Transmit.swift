//
//  HUIHostBank Transmit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUIHostBank {
    /// Transmit a HUI ping message to the client surface.
    /// It is not necessary to call this manually. The ``HUIHost`` object will handle ping transmission on an internal timer automatically.
    internal func transmitPing() {
        let event = encodeHUIPing(to: .surface)
        midiOut(event)
    }
    
    /// Transmit switch state to the client surface.
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
            to: .surface
        )
        midiOut(events)
    }
    
    /// Transmit fader level to the client surface.
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
    
    /// Transmit LED level meter change to the client surface.
    ///
    /// - Parameters:
    ///   - channel: Channel strip number (`0 ... 7`).
    ///   - side: Left or right side of the stereo meter.
    ///   - level: Level amount (`0x0 ... 0xC`). Where `0x0` is off, `0x1 ... 0xB` is signal level, and `0xC` is clipping (red LED).
    public func transmitLevelMeter(
        channel: UInt4,
        side: HUISurfaceModel.StereoLevelMeter.Side,
        level: Int
    ) {
        let event = encodeHUILevelMeter(
            channel: channel,
            side: side,
            level: level
        )
        midiOut(event)
    }
    
    /// Transmit V-Pot LED change to the client surface.
    ///
    /// - Parameters:
    ///   - vPot: V-Pot identity.
    ///   - value: Encoded value. When encoding host → surface, this is the LED preset index. When encoding surface → host, this is the delta rotary knob change value -/+ when the user turns the knob.
    public func transmitVPot(
        _ vPot: HUIVPot,
        display: HUIVPotDisplay
    ) {
        let event = encodeHUIVPotValue(
            for: vPot,
            rawValue: display.rawIndex
        )
        midiOut(event)
    }
    
    /// Transmit large display text (40 x 2 characters) to the client surface.
    ///
    /// - Parameters:
    ///   - display: Full display to transmit
    public func transmitLargeDisplay(
        _ display: HUISurfaceModel.LargeDisplay
    ) {
        let event = encodeHUILargeDisplay(display: display)
        midiOut(event)
    }
    
    /// Transmit small display text (4 characters) to the client surface.
    ///
    /// - Parameters:
    ///   - display: Identity of the small display.
    ///   - text: 4-character text to display.
    public func transmitSmallDisplay(
        _ display: HUISmallDisplay,
        text: HUISmallDisplayString
    ) {
        let event = encodeHUISmallDisplay(for: display, text: text)
        midiOut(event)
    }
    
    /// Transmit full set of time display digits to the client surface.
    ///
    /// - Parameters:
    ///   - text: Full set of 8 digits.
    public func transmitTimeDisplay(
        text: HUITimeDisplayString
    ) {
        let event = encodeHUITimeDisplay(text: text)
        midiOut(event)
    }
    
    /// Transmit some or all of the time display digits to the client surface.
    ///
    /// - Parameters:
    ///   - charsRightToLeft: Between 1 and 8 characters in reverse sequence order (first array element is rightmost digit). More than 8 characters will discarded and truncated to 8 characters.
    public func transmitTimeDisplay(
        charsRightToLeft: [HUITimeDisplayCharacter]
    ) {
        let event = encodeHUITimeDisplay(charsRightToLeft: charsRightToLeft)
        midiOut(event)
    }
}
