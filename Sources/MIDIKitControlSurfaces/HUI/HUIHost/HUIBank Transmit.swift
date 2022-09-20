//
//  HUIBank Transmit.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUIBank {
    /// Transmit a HUI ping message to the client surface.
    /// It is not necessary to call this manually. The ``HUIHost`` object will handle ping transmission on an internal timer automatically.
    public func transmitPing() {
        let event = encodeHUIPing(to: .surface)
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
            to: .surface
        )
        midiOut(events)
    }
    
    /// Transmit switch state to the client surface.
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
    
    /// Transmit fader level to the client surface.
    ///
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
}