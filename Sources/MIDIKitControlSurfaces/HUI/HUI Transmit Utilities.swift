//
//  HUI Transmit Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// Utility:
/// Encodes HUI ping message as a MIDI event. (Specify to host or to client surface).
///
/// - Parameters:
///   - toHost: `true` if transmitting to host, `false` if transmitting to client surface.
/// - Returns: MIDI events.
func encodeHUIPing(
    toHost: Bool
) -> MIDIEvent {
    toHost
        ? HUIConstants.kMIDI.kPingReplyToHostMessage
        : HUIConstants.kMIDI.kPingToClientMessage
}

/// Utility:
/// Encodes HUI switch message as MIDI events. (Specify to host or to client surface).
///
/// - Parameters:
///   - zone: HUI zone number.
///   - port: HUI port number.
///   - state: Switch state.
///   - toHost: `true` if transmitting to host, `false` if transmitting to client surface.
/// - Returns: MIDI events.
func encodeHUISwitch(
    zone: HUIZone,
    port: HUIPort,
    state: Bool,
    toHost: Bool
) -> [MIDIEvent] {
    // set on off byte
    var portByte: UInt8 = port.uInt8Value
    
    if state == true {
        portByte += 0x40
    }
    
    let ccA = toHost
        ? HUIConstants.kMIDI.kControlDataByte1
            .zoneSelectByteToHost
        : HUIConstants.kMIDI.kControlDataByte1
            .zoneSelectByteToSurface
    let event1 = MIDIEvent.cc(
        ccA.toUInt7,
        value: .midi1(zone.toUInt7),
        channel: 0
    )
    
    let ccB = toHost
        ? HUIConstants.kMIDI.kControlDataByte1
            .portOnOffByteToHost
        : HUIConstants.kMIDI.kControlDataByte1
            .portOnOffByteToSurface
    let event2 = MIDIEvent.cc(
        ccB.toUInt7,
        value: .midi1(portByte.toUInt7),
        channel: 0
    )
    
    return [event1, event2]
}

/// Utility:
/// Encodes HUI fader level message as MIDI events. (To host or to client surface).
///
/// - Parameters:
///   - level: `0 ... 16383`
///   - channel: `0 ... 7`
/// - Returns: MIDI events.
func encodeHUIFader(
    level: UInt14,
    channel: Int
) -> [MIDIEvent] {
    guard (0 ... 16383).contains(level) else { return [] }
    guard (0x0 ... 0x7).contains(channel) else { return [] }
    
    let msb = level.bytePair.msb.toUInt7
    let lsb = level.bytePair.lsb.toUInt7
    let channelHi = channel.toUInt7
    let channelLow = (channel + 0x20).toUInt7
    
    let event1 = MIDIEvent.cc(channelHi, value: .midi1(msb), channel: 0)
    let event2 = MIDIEvent.cc(channelLow, value: .midi1(lsb), channel: 0)
    
    return [event1, event2]
}

/// Utility:
/// Encodes HUI fader fader touch/release message as MIDI events. (To host)
///
/// - Parameters:
///   - isTouched: `true` sends touch message, `false` sends release message.
///   - channel: `0 ... 7`
/// - Returns: MIDI events.
func encodeHUIFader(
    isTouched: Bool,
    channel: Int
) -> [MIDIEvent] {
    guard (0x0 ... 0x7).contains(channel) else { return [] }
    
    let event1 = MIDIEvent.cc(
        HUIConstants.kMIDI.kControlDataByte1.zoneSelectByteToHost.toUInt7,
        value: .midi1(channel.toUInt7),
        channel: 0
    )
    let event2 = MIDIEvent.cc(
        HUIConstants.kMIDI.kControlDataByte1.portOnOffByteToHost.toUInt7,
        value: .midi1(isTouched ? 0x40 : 0x00),
        channel: 0
    )
    
    return [event1, event2]
}
