//
//  HUIDecoder.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Darwin
import MIDIKitCore

/// Interprets HUI MIDI events and produces strongly-typed core HUI events.
///
/// This object is typically instanced once per HUI device. When using ``HUISurface``, it encapsulates an instance of the decoder and uses it transparently.
public final class HUIDecoder {
    /// Decoder role (host or client surface).
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

extension HUIDecoder: ReceivesMIDIEvents {
    /// Process HUI MIDI message received from host.
    public func midiIn(event: MIDIEvent) {
        switch event {
        case HUIConstants.kMIDI.kPingReplyToHostMessage where role == .host:
            // handler should update last ping received time/date stamp
            // so it can maintain presence state for the remote HUI surface
            huiEventHandler?(.ping)
            
        case HUIConstants.kMIDI.kPingToSurfaceMessage where role == .surface:
            // handler should send HUI ping-reply to host
            huiEventHandler?(.ping)
            
        case let .noteOff(payload) where
            payload.note.number == 0 &&
            [0, 0x8000].contains(payload.velocity.midi2Value):
            
            // MIDI 2.0 translation from MIDI 1.0 at the Core MIDI subsystem level
            // will force MIDI 1.0 Note On events with a velocity of 0 to be a MIDI 2.0 Note Off event.
            // Technically the MIDI 2.0 spec states that the velocity should be 0,
            // however it seems Core MIDI wants to send a 16-bit midpoint value of 0x8000 instead
            
            // handler should send HUI ping-reply to host
            huiEventHandler?(.ping)
            
        case let .sysEx7(payload):
            guard payload.manufacturer == HUIConstants.kMIDI.kSysEx.kManufacturer else { return }
            parse(sysExContent: payload.data)
            
        case let .cc(payload):
            parse(controlStatusPayload: payload)
            
        case let .notePressure(payload):
            parse(levelMetersPayload: payload)
            
        default:
            Logger.debug("Unhandled MIDI event received: \(event)")
        }
    }
}

// MARK: Decoder

extension HUIDecoder {
    /// Internal: handles SysEx content.
    private func parse(sysExContent data: [UInt8]) {
        guard data.count >= 2 else { return }
        
        // check for SysEx header
        guard data[0] == HUIConstants.kMIDI.kSysEx.kSubID1,
              data[1] == HUIConstants.kMIDI.kSysEx.kSubID2
        else { return }
        
        let dataAfterHeader = data.suffix(
            from: data.index(
                data.startIndex,
                offsetBy: 2
            )
        )
        
        guard !dataAfterHeader.isEmpty else { return }
        
        switch dataAfterHeader.first {
        case HUIConstants.kMIDI.kDisplayType.smallByte:
            // 0x10 channel [4 chars]
            
            guard dataAfterHeader.count == 6 else {
                Logger.debug(
                    "Received Small Display text MIDI message \(data.hexString(padEachTo: 2)) but length was not expected."
                )
                return
            }
            
            // channel can be 0-8 (0-7 = channel strips, 8 = Select Assign text display)
            let channel = dataAfterHeader[atOffset: 1]
            var newChars: [HUISmallDisplayCharacter] = []
            
            for byte in dataAfterHeader[atOffsets: 2 ... 5] {
                let char = HUISmallDisplayCharacter(rawValue: byte) ?? .unknown()
                newChars.append(char)
            }
            
            let newString = HUISmallDisplayString(chars: newChars)
            
            switch channel {
            case 0 ... 7:
                huiEventHandler?(.channelDisplay(
                    channelStrip: channel.toUInt4,
                    text: newString
                ))
            case 8:
                huiEventHandler?(.selectAssignDisplay(text: newString))
            default:
                Logger.debug(
                    "Small Display text message channel not expected: \(channel)."
                )
            }
            
            return
            
        case HUIConstants.kMIDI.kDisplayType.largeByte:
            // 0x12 zone [10 chars]
            // it may be possible to receive multiple blocks in the same SysEx message (?), ie:
            // 0x12 zone [10 chars] zone [10 chars]
            // message length test: remove first byte (0x12), then see if remainder is divisible by 11
            
            guard (dataAfterHeader.count - 1) % 11 == 0 else {
                Logger.debug(
                    "Received Large Display text MIDI message \(data.hexString(padEachTo: 2)) but length was not expected."
                )
                return
            }
            
            var largeDisplayData = dataAfterHeader[atOffsets: 1 ... dataAfterHeader.count - 1]
            
            var newSlices: [UInt4: [HUILargeDisplayCharacter]] = [:]
            
            while largeDisplayData.count >= 11 {
                let rawSliceIndex = Int(largeDisplayData[atOffset: 0])
                guard let sliceIndex = UInt4(exactly: rawSliceIndex) else {
                    Logger.debug("Encountered out-of-range HUI large display slice index: \(rawSliceIndex)")
                    return
                }
                
                var newSlice: [HUILargeDisplayCharacter] = []
                let letters = largeDisplayData[atOffsets: 1 ... 10]
                
                for letter in letters {
                    let char = HUILargeDisplayCharacter(rawValue: letter) ?? .unknown()
                    newSlice.append(char)
                }
                newSlices[sliceIndex] = newSlice
                
                largeDisplayData = largeDisplayData.dropFirst(11)
            }
            
            huiEventHandler?(.largeDisplay(slices: newSlices))
            return
            
        case HUIConstants.kMIDI.kDisplayType.timeDisplayByte:
            guard dataAfterHeader.count > 1 else { return }
            let tcData = dataAfterHeader[atOffsets: 1 ... dataAfterHeader.count - 1]
            guard tcData.count <= 8 else {
                Logger.debug("Received HUI time display message but it contained too many bytes.")
                return
            }
            
            // chars are encoded in right-to-left sequence order.
            let newChars = tcData.map { HUITimeDisplayCharacter(rawValue: $0) ?? .unknown() }
            huiEventHandler?(.timeDisplay(charsRightToLeft: newChars))
            return
            
        default:
            let msg = dataAfterHeader.hexString(padEachTo: 2)
            
            Logger.debug("Header detected but subsequent message is not recognized: \(msg)")
        }
    }
    
    /// Internal: Handle control status messages.
    private func parse(controlStatusPayload payload: MIDIEvent.CC) {
        // Control Segment
        
        let dataByte1 = payload.controller.number.uInt8Value
        let dataByte2 = payload.value.midi1Value.uInt8Value
        
        switch dataByte1 {
        case 0x00 ... 0x07:
            // Channel Strip Fader level MSB
            
            let channel = Int(dataByte1.nibbles.low)
            
            faderMSB[channel] = dataByte2
            
        case 0x20 ... 0x27:
            // Channel Strip Fader level LSB
            
            let channel = dataByte1.nibbles.low
            
            let msb = UInt16(faderMSB[channel.intValue]) << 7
            let lsb = UInt16(dataByte2)
            
            guard let level = (msb + lsb).toUInt14Exactly else { return }
            
            huiEventHandler?(.faderLevel(
                channelStrip: channel,
                level: level
            ))
            
        case 0x10 ... 0x1B:
            // V-Pots
            
            // When encoding host → surface, this is the LED preset index.
            // When encoding surface → host, this is the delta rotary knob change value -/+ when the user turns the knob.
            
            let number = dataByte1 % 0x10
            guard let vPot = HUIVPot(rawValue: number),
                  let value = Int7(exactly: dataByte2)
            else { return }
            
            let vPotValue: HUIVPotValue
            switch role {
            case .host:
                vPotValue = HUIVPotValue.delta(value)
            case .surface:
                vPotValue = HUIVPotValue.display(.init(rawIndex: UInt8(value.intValue)))
            }
            
            huiEventHandler?(.vPot(
                vPot: vPot,
                value: vPotValue
            ))
            
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
                // Not sure what this is used for. Any of the HUI docs available don't mention it being used. However, Pro Tools transmits switch messages that utilize this sate nibble. It's been observed being transmit when changing a track's automation mode to Read, and one message per track is sent when opening a Pro Tools session.
                Logger.debug(
                    "Received (switch cmd msg 2/2) with unhandled state nibble 0x2. Ignoring."
                )
                switchesZoneSelect = nil
                return
                
            case 0x4:
                state = true
                
            default:
                let cmd = payload.midi1RawBytes().hexString(padEachTo: 2, prefixes: true)
                let stateNibble = dataByte2.nibbles.high.hexString(prefix: true)
                
                if let zone = switchesZoneSelect {
                    let huiSwitch = HUISwitch(zone: zone, port: port)
                    
                    switch huiSwitch {
                    case .undefined(zone: _, port: _):
                        Logger.debug(
                            "Received \(cmd) (switch cmd msg 2/2) but has unexpected state nibble \(stateNibble). Additionally, could not guess zone and port pair name. Ignoring message."
                        )
                    default:
                        Logger.debug(
                            "Received \(cmd) (switch cmd msg 2/2) matching \(huiSwitch) but has unexpected state nibble \(stateNibble). Ignoring message."
                        )
                    }
                } else {
                    Logger.debug(
                        "Received \(cmd) (switch cmd msg 2/2) but has unexpected state nibble \(stateNibble). Additionally, could not lookup zone and port name because zone select message was not received prior. Ignoring message."
                    )
                }
                
                switchesZoneSelect = nil
                return
            }
            
            if let zone = switchesZoneSelect {
                switchesZoneSelect = nil // reset zone select
                let huiSwitch = HUISwitch(zone: zone, port: port)
                huiEventHandler?(.switch(huiSwitch: huiSwitch, state: state))
            } else {
                let cmd = payload.midi1RawBytes().hexString(padEachTo: 2, prefixes: true)
                
                Logger
                    .debug(
                        "Received message 2 of a switch command (\(cmd) port: \(port), state: \(state)) without first receiving a zone select message. Ignoring."
                    )
                
                switchesZoneSelect = nil
            }
            
        default:
            let b1 = dataByte1.hexString(padTo: 2, prefix: true)
            let cmd = payload.midi1RawBytes().hexString(padEachTo: 2, prefixes: true)
            
            Logger.debug("Unrecognized HUI MIDI status 0xB0 data byte 1: \(b1) in message: \(cmd).")
        }
    }
    
    /// Internal: Handle level meter messages.
    private func parse(levelMetersPayload payload: MIDIEvent.NotePressure) {
        let channel = payload.note.number.toUInt4Exactly ?? 0
        
        // encodes both side and value
        let sideAndValue = payload.amount.midi1Value.uInt8Value.nibbles
        let side: HUIModel.StereoLevelMeter.Side = sideAndValue.high == 0 ? .left : .right
        let level: Int = sideAndValue.low.intValue
        
        huiEventHandler?(.levelMeter(
            channelStrip: channel,
            side: side,
            level: level
        ))
    }
}
