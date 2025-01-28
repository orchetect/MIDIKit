//
//  HUICoreDecoder.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// Interprets HUI MIDI events and produces strongly-typed core HUI events.
final class HUICoreDecoder: @unchecked Sendable {
    /// Decoder role: the type of HUI MIDI messages expected to be received and decoded.
    public let role: HUIRole
    
    // MARK: local state variables
    
    private var faderMSB: [UInt8] = []
    private var switchesZoneSelect: UInt8?
    
    // MARK: handlers
    
    public typealias HUIEventHandler = ((HUICoreEvent) -> Void)
    
    /// Decoder event handler that is called when HUI events are received.
    public var huiEventHandler: HUIEventHandler?
    
    // MARK: - init
    
    public init(
        role: HUIRole,
        huiEventHandler: HUIEventHandler? = nil
    ) {
        self.role = role
        self.huiEventHandler = huiEventHandler
        reset()
    }
        
    /// Resets the decoder to original init state. (Handlers are unaffected.)
    public func reset() {
        // HUI protocol (and the HUI hardware control surface) has only 8 channel faders.
        // Even though some control surface models have a 9th master fader
        // such as EMAGIC Logic Control and Mackie Control Universal,
        // when running in HUI mode, the master fader is disabled.
        faderMSB = [UInt8](repeating: 0, count: 8)
        
        switchesZoneSelect = nil
    }
}

// MARK: ReceivesMIDIEvents

extension HUICoreDecoder: ReceivesMIDIEvents {
    /// Process HUI MIDI message received from host.
    public func midiIn(event: MIDIEvent) {
        do {
            for coreEvent in try decode(event: event) {
                huiEventHandler?(coreEvent)
            }
        } catch {
            Logger.debug("\(error)")
        }
    }
    
    /// Decodes a MIDI event.
    ///
    /// - Returns: One or more HUI core events if the MIDI event results in decoded HUI event(s).
    /// Not all MIDI events will generate HUI event(s); some merely update the decoder's internal
    /// state, in which case an empty array will be returned. This is not an error condition.
    ///
    /// - Throws: An error if the MIDI event was malformed or contained unexpected data.
    func decode(event: MIDIEvent) throws -> [HUICoreEvent] {
        switch event {
        case HUIConstants.kMIDI.kPingReplyToHostMessage where role == .surface:
            // handler should send HUI ping-reply to host
            return [.ping]
            
        case HUIConstants.kMIDI.kPingToSurfaceMessage where role == .host:
            // handler should update last ping received time/date stamp
            // so it can maintain presence state for the remote HUI surface
            return [.ping]
            
        case let .noteOff(payload) where
            payload.note.number == 0 &&
            [0, 0x8000].contains(payload.velocity.midi2Value):
            
            // MIDI 2.0 translation from MIDI 1.0 at the Core MIDI subsystem level will
            // force MIDI 1.0 Note On events with a velocity of 0 to be a MIDI 2.0 Note Off event.
            // Technically the MIDI 2.0 spec states that the velocity should be 0,
            // however it seems Core MIDI wants to send a 16-bit midpoint value of 0x8000 instead
            
            // handler should send HUI ping-reply to host
            return [.ping]
            
        case let .sysEx7(payload):
            return try parse(sysExPayload: payload)
            
        case let .cc(payload):
            if let decoded = try parse(controlStatusPayload: payload) {
                return [decoded]
            } else {
                return []
            }
        case let .notePressure(payload):
            return [parse(levelMetersPayload: payload)]
            
        case .systemReset where role == .surface:
            return [.systemReset]
            
        default:
            Logger.debug("Unhandled MIDI event received: \(event)")
            return []
        }
    }
}

// MARK: Decoder

extension HUICoreDecoder {
    /// Internal: handles SysEx content.
    func parse(sysExPayload payload: MIDIEvent.SysEx7) throws -> [HUICoreEvent] {
        guard payload.manufacturer == HUIConstants.kMIDI.kSysEx.kManufacturer else {
            // this is not a critical error, it's possible the MIDI port
            // is shared with other hardware/software and we just want to ignore
            // SysEx messages not intended for us
            throw HUIDecoderError.malformed(
                "SysEx manufacturer ID is not Mackie. Ignoring MIDI message."
            )
        }
        
        let data = payload.data
        
        guard data.count >= 2 else {
            throw HUIDecoderError.malformed(
                "Expected more bytes in SysEx."
            )
        }
        
        // check for SysEx header
        guard data[0] == HUIConstants.kMIDI.kSysEx.kSubID1,
              data[1] == HUIConstants.kMIDI.kSysEx.kSubID2
        else {
            throw HUIDecoderError.malformed(
                "SysEx sub-IDs (first two bytes) are not recognized. "
                    + "It is possible the IDs belong to hardware other than the Mackie HUI. "
                    + "Raw data: [\(data.hexString(padEachTo: 2, prefixes: false))]"
            )
        }
        
        let dataAfterHeader = data.suffix(
            from: data.index(
                data.startIndex,
                offsetBy: 2
            )
        )
        
        guard !dataAfterHeader.isEmpty else {
            throw HUIDecoderError.malformed(
                "Expected more bytes in SysEx."
            )
        }
        
        switch dataAfterHeader.first {
        case HUIConstants.kMIDI.kDisplayType.smallByte.uInt8Value:
            // 0x10
            // then one or more sequences of:
            //   channel [4 chars]
            
            // Pro Tools only ever sends SysEx with a single small display change
            // but some DAWs like Logic will send multiple small text changes in a single SysEx
            
            let contiguousSlices = dataAfterHeader[atOffsets: 1 ... dataAfterHeader.count - 1]
            
            guard contiguousSlices.count % 5 == 0 else {
                throw HUIDecoderError.malformed(
                    "Received Small Display text MIDI message \(data.hexString(padEachTo: 2)) but length was not expected."
                )
            }
            
            let slices = contiguousSlices.split(every: 5)
            
            let events: [HUICoreEvent] = try slices.map { slice in
                // channel can be 0-8 (0-7 = channel strips, 8 = Select Assign text display)
                let channel = slice[atOffset: 0]
                var newChars: [HUISmallDisplayCharacter] = []
                
                for byte in slice[atOffsets: 1 ... 4] {
                    let char = HUISmallDisplayCharacter(rawValue: byte) ?? .unknown()
                    newChars.append(char)
                }
                
                let newString = HUISmallDisplayString(chars: newChars)
                
                switch channel {
                case 0 ... 7:
                    return .channelDisplay(
                        channelStrip: channel.toUInt4,
                        text: newString
                    )
                case 8:
                    return .selectAssignDisplay(text: newString)
                default:
                    throw HUIDecoderError.malformed(
                        "Small Display text message channel not expected: \(channel)."
                    )
                }
            }
            return events
            
        case HUIConstants.kMIDI.kDisplayType.largeByte.uInt8Value:
            // 0x12 sliceIndex [10 chars]
            // it is possible to receive multiple blocks in the same SysEx message, ie:
            // 0x12 sliceIndex [10 chars] sliceIndex [10 chars]
            
            let contiguousSlices = dataAfterHeader[atOffsets: 1 ... dataAfterHeader.count - 1]
            
            guard contiguousSlices.count % 11 == 0 else {
                throw HUIDecoderError.malformed(
                    "Received Large Display text MIDI message \(data.hexString(padEachTo: 2)) but length was not expected."
                )
            }
            
            let slices = contiguousSlices.split(every: 11)
            
            let newSlices: HUILargeDisplaySlices = try slices.reduce(into: [:]) { base, slice in
                let rawSliceIndex = Int(slice[atOffset: 0])
                guard let sliceIndex = UInt4(exactly: rawSliceIndex) else {
                    throw HUIDecoderError.malformed(
                        "Encountered out-of-range HUI large display slice index: \(rawSliceIndex)"
                    )
                }
                
                var newSlice: [HUILargeDisplayCharacter] = []
                let letters = contiguousSlices[atOffsets: 1 ... 10]
                
                for letter in letters {
                    let char = HUILargeDisplayCharacter(rawValue: letter) ?? .unknown()
                    newSlice.append(char)
                }
                base[sliceIndex] = newSlice
            }
            
            return [.largeDisplay(slices: newSlices)]
            
        case HUIConstants.kMIDI.kDisplayType.timeDisplayByte.uInt8Value:
            guard dataAfterHeader.count > 1 else {
                throw HUIDecoderError.malformed(
                    "Received HUI time display message but did not contain enough bytes."
                )
            }
            let tcData = dataAfterHeader[atOffsets: 1 ... dataAfterHeader.count - 1]
            guard tcData.count <= 8 else {
                throw HUIDecoderError.malformed(
                    "Received HUI time display message but it contained too many bytes."
                )
            }
            
            // chars are encoded in right-to-left sequence order.
            let newChars = tcData.map {
                HUITimeDisplayCharacter(rawValue: $0) ?? .unknown()
            }
            return [.timeDisplay(charsRightToLeft: newChars)]
            
        default:
            let msg = dataAfterHeader.hexString(padEachTo: 2)
            
            throw HUIDecoderError.malformed(
                "SysEx header present but subsequent bytes not recognized: \(msg)"
            )
        }
    }
    
    /// Internal: Handle control status messages.
    func parse(controlStatusPayload payload: MIDIEvent.CC) throws -> HUICoreEvent? {
        // Control Segment
        
        let dataByte1 = payload.controller.number.uInt8Value
        let dataByte2 = payload.value.midi1Value.uInt8Value
        let dataByte2UInt7 = payload.value.midi1Value
        
        switch dataByte1 {
        case 0x00 ... 0x07:
            // Channel Strip Fader level MSB
            
            let channel = Int(dataByte1.nibbles.low)
            
            faderMSB[channel] = dataByte2
            
        case 0x0D:
            // Jog Wheel delta
            
            switch role {
            case .host:
                throw HUIDecoderError.unhandled(
                    "Jog Wheel event decoded but host is not capable of generating Jog Wheel events, only receiving them."
                )
            case .surface:
                let value = decodeHUIDelta(from: dataByte2UInt7)
                return .jogWheel(delta: value)
            }
            
        case 0x20 ... 0x27:
            // Channel Strip Fader level LSB
            
            let channel = dataByte1.nibbles.low
            
            let msb = UInt16(faderMSB[channel.intValue]) << 7
            let lsb = UInt16(dataByte2)
            
            guard let level = (msb + lsb).toUInt14Exactly else {
                throw HUIDecoderError.malformed(
                    "Received channel strip fader level LSB but combined MSB + LSB value is invalid."
                )
            }
            
            return .faderLevel(
                channelStrip: channel,
                level: level
            )
            
        case 0x10 ... 0x1C, // to surface
             0x40 ... 0x4C: // to host (0x40 offset of 'to surface')
            // V-Pots
            
            // When encoding host → surface, this is the LED preset index.
            // When encoding surface → host, this is the delta rotary knob change value -/+ when the
            // user turns the knob.
            
            let number = dataByte1 % 0x10
            guard let vPot = HUIVPot(rawValue: number)
            else {
                throw HUIDecoderError.malformed(
                    "V-Pot ID is invalid."
                )
            }
            
            let vPotValue: HUIVPotValue = {
                switch role {
                case .host:
                    return .display(.init(rawIndex: dataByte2))
                case .surface:
                    let value = decodeHUIDelta(from: dataByte2UInt7)
                    return .delta(value)
                }
            }()
            
            return .vPot(
                vPot: vPot,
                value: vPotValue
            )
            
        case HUIConstants.kMIDI.kControlDataByte1.zoneSelectByteToHost,
             HUIConstants.kMIDI.kControlDataByte1.zoneSelectByteToSurface:
            // zone select (1st message)
            
            if let zs = switchesZoneSelect {
                let newZS = dataByte2.hexString(padTo: 2, prefix: true)
                let oldZS = zs.hexString(padTo: 2, prefix: true)
                Logger.debug(
                    "Received new switch zone select \(newZS), but zone select buffer was not empty. (\(oldZS) was stored)). Storing new zone select."
                )
            }
            
            switchesZoneSelect = dataByte2
            
        case HUIConstants.kMIDI.kControlDataByte1.portOnOffByteToHost,
             HUIConstants.kMIDI.kControlDataByte1.portOnOffByteToSurface:
            // port on, or port off (2nd message)
            
            let port = dataByte2.nibbles.low
            var state: Bool
            
            switch dataByte2.nibbles.high {
            case 0x0:
                state = false
                
            case 0x2:
                // Not sure what this is used for. Any of the HUI docs available don't mention it
                // being used. However, Pro Tools transmits switch messages that utilize this sate
                // nibble. It's been observed being transmit when changing a track's automation mode
                // to Read, and one message per track is sent when opening a Pro Tools session.
                Logger.debug(
                    "Received (switch cmd msg 2/2) with unhandled state nibble 0x2. Ignoring."
                )
                switchesZoneSelect = nil
                return nil
                
            case 0x4:
                state = true
                
            default:
                defer { switchesZoneSelect = nil }
                
                let cmd = payload.midi1RawBytes().hexString(padEachTo: 2, prefixes: true)
                let stateNibble = dataByte2.nibbles.high.hexString(prefix: true)
                
                if let zone = switchesZoneSelect {
                    let huiSwitch = HUISwitch(zone: zone, port: port)
                    
                    switch huiSwitch {
                    case .undefined(zone: _, port: _):
                        throw HUIDecoderError.unhandled(
                            "Received \(cmd) (switch cmd msg 2/2) but has unexpected state nibble \(stateNibble). Additionally, could not guess zone and port pair name. Ignoring message."
                        )
                    default:
                        throw HUIDecoderError.unhandled(
                            "Received \(cmd) (switch cmd msg 2/2) matching \(huiSwitch) but has unexpected state nibble \(stateNibble). Ignoring message."
                        )
                    }
                } else {
                    throw HUIDecoderError.unhandled(
                        "Received \(cmd) (switch cmd msg 2/2) but has unexpected state nibble \(stateNibble). Additionally, could not lookup zone and port name because zone select message was not received prior. Ignoring message."
                    )
                }
            }
            
            if let zone = switchesZoneSelect {
                switchesZoneSelect = nil // reset zone select
                let huiSwitch = HUISwitch(zone: zone, port: port)
                return .switch(huiSwitch: huiSwitch, state: state)
            } else {
                let cmd = payload.midi1RawBytes().hexString(padEachTo: 2, prefixes: true)
                
                Logger.debug(
                    "Received message 2 of a switch command (\(cmd) port: \(port), state: \(state)) without first receiving a zone select message. Ignoring."
                )
                
                switchesZoneSelect = nil
            }
            
        default:
            let b1 = dataByte1.hexString(padTo: 2, prefix: true)
            let cmd = payload.midi1RawBytes().hexString(padEachTo: 2, prefixes: true)
            
            throw HUIDecoderError.malformed(
                "Unrecognized HUI MIDI status 0xB0 data byte 1: \(b1) in message: \(cmd)."
            )
        }
        
        return nil
    }
    
    /// Internal: Handle level meter messages.
    private func parse(levelMetersPayload payload: MIDIEvent.NotePressure) -> HUICoreEvent {
        let channel = payload.note.number.toUInt4Exactly ?? 0
        
        // encodes both side and value
        let sideAndValue = payload.amount.midi1Value.uInt8Value.nibbles
        let side: HUISurfaceModelState.StereoLevelMeter.Side = sideAndValue.high == 0 ? .left : .right
        let level: Int = sideAndValue.low.intValue
        
        return .levelMeter(
            channelStrip: channel,
            side: side,
            level: level
        )
    }
}
