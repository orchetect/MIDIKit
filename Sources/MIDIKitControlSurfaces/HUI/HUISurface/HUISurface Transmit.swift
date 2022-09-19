//
//  HUISurface Transmit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension HUISurface {
    /// Transmit a HUI ping message to the host.
    /// It is not necessary to call this manually. The ``HUISurface`` object will handle ping replies automatically.
    public func transmitPing() {
        let event = encodeHUIPing(to: .host)
        midiOut(event)
    }
    
    /// Transmit switch state to host.
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
    public func transmitSwitch(
        _ param: HUIParameter,
        state: Bool
    ) {
        let zoneAndPort = param.zoneAndPort
        
        transmitSwitch(
            zone: zoneAndPort.zone,
            port: zoneAndPort.port,
            state: state
        )
    }
    
    /// Transmit fader level to the host.
    /// - Parameters:
    ///   - level: `0 ... 16383`
    ///   - channel: `0 ... 7`
    public func transmitFader(
        level: UInt14,
        channel: Int
    ) {
        let events = encodeHUIFader(level: level, channel: channel)
        midiOut(events)
    }
    
    /// Transmit fader touch/release message to the host.
    /// - Parameters:
    ///   - isTouched: `true` sends touch message, `false` sends release message.
    ///   - channel: `0 ... 7`
    public func transmitFader(
        isTouched: Bool,
        channel: Int
    ) {
        let events = encodeHUIFader(isTouched: isTouched, channel: channel)
        midiOut(events)
    }
    
    /// Sends a message that tells the host that the HUI device is powering on or off.
    public func transmitSystemReset() {
        midiOut(HUIConstants.kMIDI.kSystemResetMessage)
    }
}
