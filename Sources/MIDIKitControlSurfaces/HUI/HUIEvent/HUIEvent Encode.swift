//
//  HUIEvent Encode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUIEvent {
    /// Encode the HUI event to raw HUI MIDI event(s).
    public func encode(to role: HUIRole) -> [MIDIEvent] {
        switch self {
        case .ping:
            return [encodeHUIPing(to: role)]
            
        case let .largeDisplay(top, bottom):
            return encodeHUILargeDisplay(top: top, bottom: bottom)

        case let .timeDisplay(timeString):
            return [encodeHUITimeDisplay(text: timeString)]
            
        case let .timeDisplayStatus(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .selectAssignDisplay(text):
            return [encodeHUISmallDisplay(for: .selectAssign, text: text)]

        case let .channelStrip(channel, channelStripComponent):
            return channelStripComponent.encoded(to: role, channel: channel)

        case let .hotKey(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .paramEdit(paramEditComponent):
            return paramEditComponent.encoded(to: role)

        case let .functionKey(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .autoEnable(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .autoMode(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .statusAndGroup(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .edit(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .numPad(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .window(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .bankMove(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .assign(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .cursor(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .controlRoom(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .transport(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .footswitchesAndSounds(param, state):
            let zoneAndPort = param.zoneAndPort
            
            return encodeHUISwitch(
                zone: zoneAndPort.zone,
                port: zoneAndPort.port,
                state: state,
                to: role
            )

        case let .undefinedSwitch(zone, port, state):
            return encodeHUISwitch(
                zone: zone,
                port: port,
                state: state,
                to: role
            )
        }
    }
}

extension HUIEvent.ChannelStripComponent {
    /// Encode the HUI channel strip event to raw HUI MIDI events.
    public func encoded(
        to role: HUIRole,
        channel: UInt4
    ) -> [MIDIEvent] {
        switch self {
        case let .levelMeter(side, level):
            return [encodeHUILevelMeter(
                channel: channel,
                side: side,
                level: level
            )]
        case let .recordReady(state):
            return encodeHUISwitch(.channelStrip(channel, .recordReady), state: state, to: role)
        case let .insert(state):
            return encodeHUISwitch(.channelStrip(channel, .insert), state: state, to: role)
        case let .vPotSelect(state):
            return encodeHUISwitch(.channelStrip(channel, .vPotSelect), state: state, to: role)
        case let .vPot(value):
            return [encodeHUIVPotValue(for: .channel(channel), rawValue: value.rawValue)]
        case let .auto(state):
            return encodeHUISwitch(.channelStrip(channel, .auto), state: state, to: role)
        case let .solo(state):
            return encodeHUISwitch(.channelStrip(channel, .solo), state: state, to: role)
        case let .mute(state):
            return encodeHUISwitch(.channelStrip(channel, .mute), state: state, to: role)
        case let .nameTextDisplay(text):
            return [encodeHUISmallDisplay(for: .channel(channel), text: text)]
        case let .select(state):
            return encodeHUISwitch(.channelStrip(channel, .select), state: state, to: role)
        case let .faderTouched(state):
            return encodeHUISwitch(.channelStrip(channel, .faderTouched), state: state, to: role)
        case let .faderLevel(level):
            return encodeHUIFader(level: level, channel: channel)
        }
    }
}

extension HUIEvent.ParamEditComponent {
    /// Encode the HUI channel strip event to raw HUI MIDI events.
    public func encoded(
        to role: HUIRole
    ) -> [MIDIEvent] {
        switch self {
        case let .assign(state):
            return encodeHUISwitch(.paramEdit(.assign), state: state, to: role)
        case let .compare(state):
            return encodeHUISwitch(.paramEdit(.compare), state: state, to: role)
        case let .bypass(state):
            return encodeHUISwitch(.paramEdit(.bypass), state: state, to: role)
        case let .param1Select(state):
            return encodeHUISwitch(.paramEdit(.param1Select), state: state, to: role)
        case let .param1VPot(value):
            return [encodeHUIVPotValue(for: .editAssignA, rawValue: value.rawValue)]
        case let .param2Select(state):
            return encodeHUISwitch(.paramEdit(.param2Select), state: state, to: role)
        case let .param2VPot(value):
            return [encodeHUIVPotValue(for: .editAssignB, rawValue: value.rawValue)]
        case let .param3Select(state):
            return encodeHUISwitch(.paramEdit(.param3Select), state: state, to: role)
        case let .param3VPot(value):
            return [encodeHUIVPotValue(for: .editAssignC, rawValue: value.rawValue)]
        case let .param4Select(state):
            return encodeHUISwitch(.paramEdit(.param4Select), state: state, to: role)
        case let .param4VPot(value):
            return [encodeHUIVPotValue(for: .editAssignD, rawValue: value.rawValue)]
        case let .insertOrParam(state):
            return encodeHUISwitch(.paramEdit(.insertOrParam), state: state, to: role)
        case let .paramScroll(delta):
            return [encodeHUIVPotValue(for: .editAssignScroll, rawValue: delta.rawUInt7Byte)]
        }
    }
}
