//
//  HUI Encode Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
internal import MIDIKitInternals

// MARK: - Ping

/// Utility:
/// Encode HUI ping message as a MIDI event. (Specify to host or to client surface).
///
/// - Parameters:
///   - role: Transmission direction (to host or to remote client surface).
/// - Returns: MIDI events.
@inlinable
func encodeHUIPing(
    to role: HUIRole
) -> MIDIEvent {
    switch role {
    case .host:
        return HUIConstants.kMIDI.kPingReplyToHostMessage
    case .surface:
        return HUIConstants.kMIDI.kPingToSurfaceMessage
    }
}

// MARK: - Switch

/// Utility:
/// Encode HUI switch message as MIDI events. (Specify to host or to client surface).
///
/// - Parameters:
///   - zone: HUI zone number.
///   - port: HUI port number.
///   - state: Switch state.
///   - role: Transmission direction (to host or to remote client surface).
/// - Returns: MIDI events.
@inlinable
func encodeHUISwitch(
    zone: HUIZone,
    port: HUIPort,
    state: Bool,
    to role: HUIRole
) -> [MIDIEvent] {
    // set on off byte
    var portByte: UInt8 = port.uInt8Value
    
    if state == true {
        portByte += 0x40
    }
    
    let ccA = role == .host
        ? HUIConstants.kMIDI.kControlDataByte1
            .zoneSelectByteToHost
        : HUIConstants.kMIDI.kControlDataByte1
            .zoneSelectByteToSurface
    let event1: MIDIEvent = .cc(
        ccA.toUInt7,
        value: .midi1(zone.toUInt7),
        channel: 0
    )
    
    let ccB = role == .host
        ? HUIConstants.kMIDI.kControlDataByte1
            .portOnOffByteToHost
        : HUIConstants.kMIDI.kControlDataByte1
            .portOnOffByteToSurface
    let event2: MIDIEvent = .cc(
        ccB.toUInt7,
        value: .midi1(portByte.toUInt7),
        channel: 0
    )
    
    return [event1, event2]
}

/// Utility:
/// Encode HUI switch message as MIDI events. (Specify to host or to client surface).
///
/// - Parameters:
///   - huiSwitch: HUI switch.
///   - state: Switch state.
///   - role: Transmission direction (to host or to remote client surface).
/// - Returns: MIDI events.
@inlinable
func encodeHUISwitch(
    _ huiSwitch: HUISwitch,
    state: Bool,
    to role: HUIRole
) -> [MIDIEvent] {
    let zoneAndPort = huiSwitch.zoneAndPort
    
    return encodeHUISwitch(
        zone: zoneAndPort.zone,
        port: zoneAndPort.port,
        state: state,
        to: role
    )
}

// MARK: - Fader

/// Utility:
/// Encode HUI fader level message as MIDI events. (To host or to client surface).
///
/// - Parameters:
///   - level: Fader level (`0 ... 16383`).
///   - channel: Channel strip number (`0 ... 7`).
/// - Returns: MIDI events.
@inlinable
func encodeHUIFader(
    level: UInt14,
    channel: UInt4
) -> [MIDIEvent] {
    guard (0 ... 16383).contains(level) else { return [] }
    
    // UInt4 is self-validating, no need for guard
    // guard (0x0 ... 0x7).contains(channel) else { return [] }
    
    let msb = level.bytePair.msb.toUInt7
    let lsb = level.bytePair.lsb.toUInt7
    let channelHi = channel.toUInt7
    let channelLow = channel.toUInt7 + 0x20
    
    let event1: MIDIEvent = .cc(channelHi, value: .midi1(msb), channel: 0)
    let event2: MIDIEvent = .cc(channelLow, value: .midi1(lsb), channel: 0)
    
    return [event1, event2]
}

/// Utility:
/// Encodes HUI fader touch/release message as MIDI events. (To host)
///
/// - Parameters:
///   - isTouched: `true` sends touch message, `false` sends release message.
///   - channel: `0 ... 7`
/// - Returns: MIDI events.
@inlinable
func encodeHUIFader(
    isTouched: Bool,
    channel: UInt4
) -> [MIDIEvent] {
    // UInt4 is self-validating, no need for guard
    // guard (0x0 ... 0x7).contains(channel) else { return [] }
    
    let event1: MIDIEvent = .cc(
        HUIConstants.kMIDI.kControlDataByte1.zoneSelectByteToHost.toUInt7,
        value: .midi1(channel.toUInt7),
        channel: 0
    )
    let event2: MIDIEvent = .cc(
        HUIConstants.kMIDI.kControlDataByte1.portOnOffByteToHost.toUInt7,
        value: .midi1(isTouched ? 0x40 : 0x00),
        channel: 0
    )
    
    return [event1, event2]
}

// MARK: - Level Meters

/// Utility:
/// Encodes HUI level meter message as a MIDI event. (To client surface)
///
/// - Parameters:
///   - channel: Channel strip number (`0 ... 7`).
///   - side: Left or right side of the stereo meter.
///   - level: Level amount (`0x0 ... 0xC`).
///     Where `0x0` is off, `0x1 ... 0xB` is signal level, and `0xC` is clipping (red LED).
/// - Returns: MIDI event.
@usableFromInline
func encodeHUILevelMeter(
    channel: UInt4,
    side: HUISurfaceModelState.StereoLevelMeterSide,
    level: Int
) -> MIDIEvent {
    let clampedLevel = level.clamped(to: HUISurfaceModelState.StereoLevelMeterSide.levelRange)
    let val = UInt8(high: side.rawValue.toUInt4, low: clampedLevel.toUInt4)
    return .notePressure(
        note: channel.toUInt7,
        amount: .midi1(val.toUInt7),
        channel: 0
    )
}

// MARK: - V-Pot Value

/// Utility:
/// Encodes HUI V-Pot value message as a MIDI event. (To host or to client surface)
///
/// - Parameters:
///   - vPot: V-Pot identity.
///   - rawValue: Encoded value.
///     When encoding host → surface, this is the LED preset index.
///     When encoding surface → host, this is the delta rotary knob change
///     value -/+ when the user turns the knob.
///   - role: Transmission direction (to host or to remote client surface).
/// - Returns: MIDI event.
@inlinable
func encodeHUIVPot(
    rawValue: UInt7,
    for vPot: HUIVPot,
    to role: HUIRole
) -> MIDIEvent {
    .cc(
        (role == .host ? 0x40 : 0x10) + vPot.rawValue.toUInt7,
        value: .midi1(rawValue),
        channel: 0
    )
}

/// Utility:
/// Encodes HUI V-Pot value message as a MIDI event. (To client surface)
///
/// - Parameters:
///   - vPot: V-Pot identity.
///   - rawValue: Encoded value.
///     When encoding host → surface, this is the LED preset index.
///     When encoding surface → host, this is the delta rotary knob change
///     value -/+ when the user turns the knob.
///   - role: Transmission direction (to host or to remote client surface).
/// - Returns: MIDI event.
@inlinable
func encodeHUIVPot(
    display: HUIVPotDisplay,
    for vPot: HUIVPot
) -> MIDIEvent {
    encodeHUIVPot(rawValue: display.rawIndex, for: vPot, to: .surface)
}

/// Utility:
/// Encodes HUI V-Pot value message as a MIDI event. (To host)
///
/// > Note: Input value is clamped to `-63 ... 63` due to bit truncation meaning an input delta
/// > value of -64 is not possible and will be truncated to -63.
///
/// - Parameters:
///   - vPot: V-Pot identity.
///   - delta: Delta -/+ value (will be clamped to `-63 ... 63`).
/// - Returns: MIDI event.
@inlinable
func encodeHUIVPot(
    delta: Int7,
    for vPot: HUIVPot
) -> MIDIEvent {
    let encoded = encodeHUIDelta(from: delta)
    return encodeHUIVPot(rawValue: encoded, for: vPot, to: .host)
}

// MARK: - Jog Wheel Delta

/// Utility:
/// Encodes HUI Jog Wheel delta value message as a MIDI event. (To host)
///
/// - Parameters:
///   - rawDelta: Encoded delta -/+ value (7-bit signed integer bit pattern).
/// - Returns: MIDI event.
@inlinable
func encodeJogWheel(
    delta: Int7
) -> MIDIEvent {
    .cc(
        0x0D,
        value: .midi1(encodeHUIDelta(from: delta)),
        channel: 0
    )
}

// MARK: - Large Text Display

/// Utility:
/// Encode HUI large text display as MIDI events. (To surface)
/// Encodes the entire large text display (40 x 2 characters) sourced as 8 text slices of 10
/// characters each, which matches the HUI encoding.
///
/// - Parameters:
///   - display: Top and bottom text line text, each 40 characters in length.
/// - Returns: MIDI event.
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@inlinable
func encodeHUILargeDisplay(
    display: HUISurfaceModelState.LargeDisplay
) -> [MIDIEvent] {
    encodeHUILargeDisplay(slices: display.slices)
}

/// Utility:
/// Encode HUI large text display as MIDI events. (To surface)
/// Encodes the entire large text display (40 x 2 characters) sourced as
/// 8 text slices of 10 characters each, which matches the HUI encoding.
///
/// - Parameters:
///   - top: Top text line text of 40 characters in length.
///   - bottom: Bottom text line text of 40 characters in length.
/// - Returns: MIDI event.
@inlinable
func encodeHUILargeDisplay(
    top: HUILargeDisplayString,
    bottom: HUILargeDisplayString
) -> [MIDIEvent] {
    encodeHUILargeDisplay(slices: .init(top: top, bottom: bottom))
}

/// Utility:
/// Encode HUI large text display as MIDI events. (To surface)
/// Encodes the entire large text display (40 x 2 characters) sourced as
/// 8 text slices of 10 characters each, which matches the HUI encoding.
///
/// This text display is split into 8 slices of 10 characters each,
/// with slices indexed `0 ... 3` for the top 40-character row,
/// and `4 ... 7` for the bottom 40-character row.
/// (This mirrors its raw HUI MIDI message encoding format.)
/// Any of these slices may be sent at any time in any order.
///
/// - Parameters:
///   - slices: Between 1 and 8 text slices of 10 characters each.
/// - Returns: MIDI event.
@inlinable
func encodeHUILargeDisplay(
    slices: HUILargeDisplaySlices
) -> [MIDIEvent] {
    // even though it's possible to embed more than one slice in a single SysEx message,
    // we will just do one SysEx per slice (which is how Pro Tools transmits slices)
    
    // also, it's not necessary to sort the slices in index order
    // but it can't hurt, and makes unit testing more predictable
    
    slices
        .sorted(by: { $0.key < $1.key })
        .map { (sliceIndex, sliceChars) in
            encodeHUILargeDisplay(sliceIndex: sliceIndex, text: sliceChars)
        }
}

/// Utility:
/// Encode HUI large text display as MIDI events. (To surface)
/// Encodes a single text slice (up to 10 characters), which matches the HUI encoding.
///
/// - Parameters:
///   - sliceIndex: Text slice index (`0 ... 7`). Each slice contains 10 characters.
///   - text: Slice text, up to 10 characters.
/// - Returns: MIDI event.
@inlinable
func encodeHUILargeDisplay(
    sliceIndex: UInt4,
    text: [HUILargeDisplayCharacter]
) -> MIDIEvent {
    let textBytes = text.map(\.rawValue)
    
    return huiSysExTemplate(
        body: [
            HUIConstants.kMIDI.kDisplayType.largeByte,
            UInt7(sliceIndex)
        ] + textBytes
    )
}

// MARK: - Time Display

/// Utility:
/// Encode time display message (timecode, mm:ss, bars/beats, frames). (To client surface)
///
/// - Parameters:
///   - text: 8 digits, the first seven with optional trailing dots.
/// - Returns: MIDI event.
@inlinable
func encodeHUITimeDisplay(
    text: HUITimeDisplayString
) -> MIDIEvent {
    let textBytes = text.chars.map(\.rawValue).reversed()
    
    return huiSysExTemplate(
        body: [
            HUIConstants.kMIDI.kDisplayType.timeDisplayByte
        ] + textBytes
    )
}

/// Utility:
/// Encode time display message (timecode, mm:ss, bars/beats, frames). (To client surface)
///
/// - Parameters:
///   - charsRightToLeft: Between 1 and 8 characters in reverse sequence order (first array element
/// is rightmost digit). More than 8 characters will discarded and truncated to 8 characters.
/// - Returns: MIDI event.
@inlinable
func encodeHUITimeDisplay(
    charsRightToLeft: [HUITimeDisplayCharacter]
) -> MIDIEvent {
    let textBytes = charsRightToLeft.prefix(8).map(\.rawValue)
    
    return huiSysExTemplate(
        body: [
            HUIConstants.kMIDI.kDisplayType.timeDisplayByte
        ] + textBytes
    )
}

// MARK: - Small Text Display

/// Utility:
/// Encode small text message (channel strip or Select Assign). (To client surface)
///
/// - Parameters:
///   - channel: Channel `0 ... 7`, Select Assign text display.
///   - text: 4-character HUI-encoded text.
/// - Returns: MIDI event.
@inlinable
func encodeHUISmallDisplay(
    for display: HUISmallDisplay,
    text: HUISmallDisplayString
) -> MIDIEvent {
    let textBytes = text.chars.map(\.rawValue)
    
    return huiSysExTemplate(
        body: [
            HUIConstants.kMIDI.kDisplayType.smallByte,
            display.rawValue
        ] + textBytes
    )
}

// MARK: - Helpers

/// Utility:
/// Forms a HUI SysEx message with the given data bytes.
///
/// - Parameters:
///   - body: Data bytes, not including the manufacturer or sub ID 1/2.
/// - Returns: MIDI event.
@inlinable
func huiSysExTemplate(body: [UInt8]) throws -> MIDIEvent {
    try .sysEx7(
        manufacturer: HUIConstants.kMIDI.kSysEx.kManufacturer,
        data: [
            HUIConstants.kMIDI.kSysEx.kSubID1.uInt8Value,
            HUIConstants.kMIDI.kSysEx.kSubID2.uInt8Value
        ] + body
    )
}

/// Utility:
/// Forms a HUI SysEx message with the given data bytes.
///
/// - Parameters:
///   - body: Data bytes, not including the manufacturer or sub ID 1/2.
/// - Returns: MIDI event.
@_disfavoredOverload @inlinable
func huiSysExTemplate(body: [UInt7]) -> MIDIEvent {
    .sysEx7(
        manufacturer: HUIConstants.kMIDI.kSysEx.kManufacturer,
        data: [
            HUIConstants.kMIDI.kSysEx.kSubID1,
            HUIConstants.kMIDI.kSysEx.kSubID2
        ] + body
    )
}

/// Utility:
/// Encode HUI system reset message. (To host)
///
/// - Returns: MIDI event.
@inlinable
func encodeHUISystemReset() -> MIDIEvent {
    HUIConstants.kMIDI.kSystemResetMessage
}

/// Utility:
/// Encodes HUI delta value (V-Pot, jog wheel) into a raw byte.
///
/// > Note: Input value is clamped to `-63 ... 63` due to bit truncation meaning an input delta
/// > value of -64 is not possible and will be truncated to -63.
///
/// > Note: This is used for surface → host transmission of delta pot changes and not relevant for
/// > LED ring display encoding.
///
/// - Parameters:
///   - delta: Delta -/+ value (will be clamped to `-63 ... 63`).
/// - Returns: Encoded `UInt7` byte ready to be packed into a HUI MIDI message.
@inlinable
func encodeHUIDelta(from delta: Int7) -> UInt7 {
    let isNegative = delta < 0
    let delta = abs(delta.intValue) & 0b111111
    
    if isNegative {
        return UInt7(delta)
    } else {
        return UInt7(delta + 0b1000000)
    }
}

/// Utility:
/// Decodes a raw byte into a HUI delta value (V-Pot, jog wheel).
///
/// > Note: This is used for surface → host transmission of delta pot changes and not relevant for
/// > LED ring display encoding.
///
/// - Parameters:
///   - delta: Encoded `UInt7` byte from a HUI MIDI message.
/// - Returns: Delta -/+ value (`-63 ... 63`).
@inlinable
func decodeHUIDelta(from delta: UInt7) -> Int7 {
    let isNegative = ((delta & 0b1000000) >> 6) == 0b0
    let delta = Int8(delta & 0b111111)
    
    if isNegative {
        return Int7(-delta)
    } else {
        return Int7(delta)
    }
}
