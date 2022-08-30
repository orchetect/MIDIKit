//
//  HUISurface State Update.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Main Update Method

extension HUISurface.State {
    /// Internal: Updates HUI state from a received HUI event.
    internal mutating func updateState(
        from receivedEvent: HUICoreEvent
    ) -> HUISurface.Event? {
        switch receivedEvent {
        case .ping:
            return .ping
            
        case let .levelMeters(
            channelStrip: channelStrip,
            side: side,
            level: level
        ):
            return updateState_LevelMeters(
                channelStrip: channelStrip,
                side: side,
                level: level
            )
            
        case let .faderLevel(
            channelStrip: channelStrip,
            level: level
        ):
            return updateState_FaderLevel(
                channelStrip: channelStrip,
                level: level
            )
            
        case let .vPot(
            number: number,
            value: value
        ):
            return updateState_VPot(
                number: number,
                value: value
            )
            
        case let .largeDisplayText(components: components):
            return updateState_LargeDisplayText(components: components)
            
        case let .timeDisplayText(components: components):
            return updateState_TimeDisplayText(components: components)
            
        case let .selectAssignText(text: text):
            return updateState_AssignText(text: text)
            
        case let .channelName(
            channelStrip: channelStrip,
            text: text
        ):
            return updateState_ChannelText(
                text: text,
                channelStrip: channelStrip
            )
            
        case let .switch(
            zone: zone,
            port: port,
            state: state
        ):
            return updateState_Switch(
                zone: zone,
                port: port,
                state: state
            )
        }
    }
}

// MARK: - State Update Trunk Methods

extension HUISurface.State {
    private mutating func updateState_LevelMeters(
        channelStrip: Int,
        side: HUISurface.State.StereoLevelMeter.Side,
        level: Int
    ) -> HUISurface.Event? {
        guard channelStrips.indices.contains(channelStrip) else {
            Logger.debug("HUI: Level meter channel out of range: \(channelStrip)")
            return nil
        }
        
        switch side {
        case .left: channelStrips[channelStrip].levelMeter.left = level
        case .right: channelStrips[channelStrip].levelMeter.right = level
        }
        
        return .channelStrip(
            channel: channelStrip,
            .levelMeter(side: side, level: level)
        )
    }
    
    private mutating func updateState_FaderLevel(
        channelStrip: Int,
        level: UInt14
    ) -> HUISurface.Event? {
        guard channelStrips.indices.contains(channelStrip) else {
            Logger.debug("HUI: Fader channel out of range: \(channelStrip)")
            return nil
        }
        
        channelStrips[channelStrip].fader.level = level
        
        return .channelStrip(
            channel: channelStrip,
            .faderLevel(level)
        )
    }
    
    private mutating func updateState_VPot(
        number: Int,
        value: UInt7
    ) -> HUISurface.Event? {
        switch number {
        case 0 ... 7:
            channelStrips[number].vPotLevel = value
            
            return .channelStrip(
                channel: number,
                .vPot(value)
            )
            
        case 8:
            return .paramEdit(.param1VPotLevel(value))
        case 9:
            return .paramEdit(.param2VPotLevel(value))
        case 10:
            return .paramEdit(.param3VPotLevel(value))
        case 11:
            return .paramEdit(.param4VPotLevel(value))
            
        default:
            Logger.debug("HUI: VPot with index \(number) not handled.")
            return nil
        }
    }
    
    private mutating func updateState_LargeDisplayText(
        components: [String]
    ) -> HUISurface.Event? {
        largeDisplay.components = components
        
        let topString = largeDisplay.topStringValue
        let bottomString = largeDisplay.bottomStringValue
        
        return .largeDisplay(top: topString, bottom: bottomString)
    }
    
    private mutating func updateState_TimeDisplayText(
        components: [String]
    ) -> HUISurface.Event? {
        timeDisplay.components = components
        
        let timeDisplayString = timeDisplay.stringValue
        
        return .timeDisplay(timeString: timeDisplayString)
    }
    
    private mutating func updateState_AssignText(
        text: String
    ) -> HUISurface.Event? {
        assign.textDisplay = text
        
        return .selectAssignText(text: text)
    }
    
    private mutating func updateState_ChannelText(
        text: String,
        channelStrip: Int
    ) -> HUISurface.Event? {
        channelStrips[channelStrip].nameTextDisplay = text
        
        return .channelStrip(
            channel: channelStrip,
            .nameTextDisplay(text)
        )
    }
    
    private mutating func updateState_Switch(
        zone: UInt8,
        port: UInt4,
        state: Bool
    ) -> HUISurface.Event? {
        guard let param = HUIParameter(zone: zone, port: port)
        else {
            return .unhandledSwitch(zone: zone, port: port, state: state)
        }
        
        // set state for parameter
        
        setState(of: param, to: state)
        
        // return event wrapping the control and its value
        
        switch param {
        case let .channelStrip(channel, channelParam):
            switch channelParam {
            case .recordReady:
                return .channelStrip(
                    channel: channel,
                    .recordReady(state)
                )
            case .insert:
                return .channelStrip(
                    channel: channel,
                    .insert(state)
                )
            case .vPotSelect:
                return .channelStrip(
                    channel: channel,
                    .vPotSelect(state)
                )
            case .auto:
                return .channelStrip(
                    channel: channel,
                    .auto(state)
                )
            case .solo:
                return .channelStrip(
                    channel: channel,
                    .solo(state)
                )
            case .mute:
                return .channelStrip(
                    channel: channel,
                    .mute(state)
                )
            case .select:
                return .channelStrip(
                    channel: channel,
                    .select(state)
                )
            case .faderTouched:
                return .channelStrip(
                    channel: channel,
                    .faderTouched(state)
                )
            }
            
        case let .hotKey(subParam):
            return .hotKey(param: subParam, state: state)
            
        case let .window(subParam):
            return .windowFunctions(param: subParam, state: state)
            
        case let .bankMove(subParam):
            return .bankMove(param: subParam, state: state)
            
        case let .assign(subParam):
            return .assign(param: subParam, state: state)
            
        case let .cursor(subParam):
            return .cursor(param: subParam, state: state)
            
        case let .transport(subParam):
            return .transport(param: subParam, state: state)
            
        case let .controlRoom(subParam):
            return .controlRoom(param: subParam, state: state)
            
        case let .numPad(subParam):
            return .numPad(param: subParam, state: state)
            
        case let .timeDisplay(subParam):
            return .timeDisplayStatus(param: subParam, state: state)
            
        case let .autoEnable(subParam):
            return .autoEnable(param: subParam, state: state)
            
        case let .autoMode(subParam):
            return .autoMode(param: subParam, state: state)
            
        case let .statusAndGroup(subParam):
            return .statusAndGroup(param: subParam, state: state)
            
        case let .edit(subParam):
            return .edit(param: subParam, state: state)
            
        case let .functionKey(subParam):
            return .functionKey(param: subParam, state: state)
            
        case let .parameterEdit(subParam):
            switch subParam {
            case .assign:
                return .paramEdit(.assign(state))
            case .compare:
                return .paramEdit(.compare(state))
            case .bypass:
                return .paramEdit(.bypass(state))
            case .param1Select:
                return .paramEdit(.param1Select(state))
            case .param2Select:
                return .paramEdit(.param2Select(state))
            case .param3Select:
                return .paramEdit(.param3Select(state))
            case .param4Select:
                return .paramEdit(.param4Select(state))
            case .insertOrParam:
                return .paramEdit(.insertOrParam(state))
            }
            
        case let .footswitchesAndSounds(subParam):
            return .footswitchesAndSounds(param: subParam, state: state)
        }
    }
}
