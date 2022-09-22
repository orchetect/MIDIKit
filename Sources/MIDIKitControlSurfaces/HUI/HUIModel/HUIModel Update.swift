//
//  HUIModel Update.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Main Update Method

extension HUIModel {
    /// Updates HUI state from a received ``HUICoreEvent`` (returned from ``HUIDecoder`` after parsing incoming HUI MIDI).
    /// The corresponding granular ``HUIEvent`` is then returned.
    internal mutating func updateState(
        from receivedEvent: HUICoreEvent
    ) -> HUIEvent? {
        switch receivedEvent {
        case .ping:
            return .ping
            
        case let .levelMeters(
            channelStrip: channelStrip,
            side: side,
            level: level
        ):
            return updateStateFromLevelMeters(
                channelStrip: channelStrip,
                side: side,
                level: level
            )
            
        case let .faderLevel(
            channelStrip: channelStrip,
            level: level
        ):
            return updateStateFromFaderLevel(
                channelStrip: channelStrip,
                level: level
            )
            
        case let .vPot(
            vPot: vPot,
            delta: delta
        ):
            return updateStateFromVPot(
                vPot: vPot,
                delta: delta
            )
            
        case let .largeDisplay(slices: slices):
            return updateStateFromLargeDisplayText(slices: slices)
            
        case let .timeDisplay(text: text):
            return updateStateFromTimeDisplayText(text: text)
            
        case let .selectAssignText(text: text):
            return updateStateFromAssignText(text: text)
            
        case let .channelName(
            channelStrip: channelStrip,
            text: text
        ):
            return updateStateFromChannelText(
                text: text,
                channelStrip: channelStrip
            )
            
        case let .switch(
            zone: zone,
            port: port,
            state: state
        ):
            return updateStateFromSwitch(
                zone: zone,
                port: port,
                state: state
            )
        }
    }
}

// MARK: - State Update Trunk Methods

extension HUIModel {
    private mutating func updateStateFromLevelMeters(
        channelStrip: UInt4,
        side: StereoLevelMeter.Side,
        level: Int
    ) -> HUIEvent? {
        switch side {
        case .left:
            channelStrips[channelStrip.intValue].levelMeter.left = level
        case .right:
            channelStrips[channelStrip.intValue].levelMeter.right = level
        }
        
        return .channelStrip(
            channel: channelStrip,
            .levelMeter(side: side, level: level)
        )
    }
    
    private mutating func updateStateFromFaderLevel(
        channelStrip: UInt4,
        level: UInt14
    ) -> HUIEvent? {
       channelStrips[channelStrip.intValue].fader.level = level
        
        return .channelStrip(
            channel: channelStrip,
            .faderLevel(level: level)
        )
    }
    
    private mutating func updateStateFromVPot(
        vPot: HUIVPot,
        delta: UInt7
    ) -> HUIEvent? {
        switch vPot {
        case .channel(let chan):
            // update surface state's absolute value
            channelStrips[chan.intValue].vPotLevel = UInt7(
                clamping: channelStrips[chan.intValue].vPotLevel.intValue + delta.intValue
            )
            
            // return delta change
            return .channelStrip(
                channel: chan,
                .vPot(delta: delta)
            )
        case .editAssignA:
            return .paramEdit(.param1VPotLevel(delta: delta))
        case .editAssignB:
            return .paramEdit(.param2VPotLevel(delta: delta))
        case .editAssignC:
            return .paramEdit(.param3VPotLevel(delta: delta))
        case .editAssignD:
            return .paramEdit(.param4VPotLevel(delta: delta))
        case .editAssignScroll:
            return .paramEdit(.paramScroll(delta: delta))
        }
    }
    
    private mutating func updateStateFromLargeDisplayText(
        slices: [[HUILargeDisplayCharacter]]
    ) -> HUIEvent? {
        largeDisplay.slices = slices
        
        let topString = largeDisplay.top
        let bottomString = largeDisplay.bottom
        
        return .largeDisplay(top: topString, bottom: bottomString)
    }
    
    private mutating func updateStateFromTimeDisplayText(
        text: HUITimeDisplayString
    ) -> HUIEvent? {
        timeDisplay.timeString = text
        
        return .timeDisplay(timeString: text)
    }
    
    private mutating func updateStateFromAssignText(
        text: HUISmallDisplayString
    ) -> HUIEvent? {
        assign.textDisplay = text
        
        return .selectAssignText(text: text)
    }
    
    private mutating func updateStateFromChannelText(
        text: HUISmallDisplayString,
        channelStrip: UInt4
    ) -> HUIEvent? {
        channelStrips[channelStrip.intValue].nameTextDisplay = text
        
        return .channelStrip(
            channel: channelStrip,
            .nameTextDisplay(text: text)
        )
    }
    
    private mutating func updateStateFromSwitch(
        zone: HUIZone,
        port: HUIPort,
        state: Bool
    ) -> HUIEvent? {
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
                    .recordReady(state: state)
                )
            case .insert:
                return .channelStrip(
                    channel: channel,
                    .insert(state: state)
                )
            case .vPotSelect:
                return .channelStrip(
                    channel: channel,
                    .vPotSelect(state: state)
                )
            case .auto:
                return .channelStrip(
                    channel: channel,
                    .auto(state: state)
                )
            case .solo:
                return .channelStrip(
                    channel: channel,
                    .solo(state: state)
                )
            case .mute:
                return .channelStrip(
                    channel: channel,
                    .mute(state: state)
                )
            case .select:
                return .channelStrip(
                    channel: channel,
                    .select(state: state)
                )
            case .faderTouched:
                return .channelStrip(
                    channel: channel,
                    .faderTouched(state: state)
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
                return .paramEdit(.assign(state: state))
            case .compare:
                return .paramEdit(.compare(state: state))
            case .bypass:
                return .paramEdit(.bypass(state: state))
            case .param1Select:
                return .paramEdit(.param1Select(state: state))
            case .param2Select:
                return .paramEdit(.param2Select(state: state))
            case .param3Select:
                return .paramEdit(.param3Select(state: state))
            case .param4Select:
                return .paramEdit(.param4Select(state: state))
            case .insertOrParam:
                return .paramEdit(.insertOrParam(state: state))
            }
            
        case let .footswitchesAndSounds(subParam):
            return .footswitchesAndSounds(param: subParam, state: state)
        }
    }
}
