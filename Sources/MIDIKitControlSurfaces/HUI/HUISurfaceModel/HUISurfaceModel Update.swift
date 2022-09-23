//
//  HUISurfaceModel Update.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Main Update Method

extension HUISurfaceModel {
    /// Updates HUI state from a received ``HUICoreEvent`` (returned from ``HUIDecoder`` after parsing incoming HUI MIDI).
    /// The corresponding granular ``HUIEvent`` is then returned containing the result of the model change.
    ///
    /// > This is a utility method provided for custom implementations. When using ``HUIHost``/``HUIHostBank`` it is not necessary to call this method as it will be handled automatically.
    ///
    /// - Parameters:
    ///   - receivedEvent: The incoming ``HUICoreEvent``.
    /// - Returns: The strongly-typed ``HUIEvent`` containing the result of the state change.
    @discardableResult
    public mutating func updateState(
        from receivedEvent: HUICoreEvent
    ) -> HUIEvent? {
        switch receivedEvent {
        case .ping:
            return .ping
            
        case let .levelMeter(
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
            value: value
        ):
            return updateStateFromVPot(
                vPot: vPot,
                value: value
            )
            
        case let .largeDisplay(slices: slices):
            return updateStateFromLargeDisplay(slices: slices)
            
        case let .timeDisplay(charsRightToLeft: chars):
            return updateStateFromTimeDisplay(charsRightToLeft: chars)
            
        case let .selectAssignDisplay(text: text):
            return updateStateFromAssign(text: text)
            
        case let .channelDisplay(
            channelStrip: channelStrip,
            text: text
        ):
            return updateStateFromChannelText(
                text: text,
                channelStrip: channelStrip
            )
            
        case let .switch(
            huiSwitch: huiSwitch,
            state: state
        ):
            return updateStateFromSwitch(
                huiSwitch: huiSwitch,
                state: state
            )
        }
    }
}

// MARK: - State Update Sub-Methods

extension HUISurfaceModel {
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
        value: HUIVPotValue
    ) -> HUIEvent? {
        let rawValue = value.rawValue
        let display = HUIVPotDisplay(rawIndex: rawValue.uInt8Value)
        
        switch vPot {
        case let .channel(chan):
            channelStrips[chan.intValue].vPotDisplay = display
            return .channelStrip(
                channel: chan,
                .vPot(value: value)
            )
        case .editAssignA:
            parameterEdit.param1VPotDisplay = display
            return .paramEdit(.param1VPot(value: value))
        case .editAssignB:
            parameterEdit.param2VPotDisplay = display
            return .paramEdit(.param2VPot(value: value))
        case .editAssignC:
            parameterEdit.param3VPotDisplay = display
            return .paramEdit(.param3VPot(value: value))
        case .editAssignD:
            parameterEdit.param4VPotDisplay = display
            return .paramEdit(.param4VPot(value: value))
        case .editAssignScroll:
            return .paramEdit(.paramScroll(delta: value.wrappedValue))
        }
    }
    
    private mutating func updateStateFromLargeDisplay(
        slices: [UInt4: [HUILargeDisplayCharacter]]
    ) -> HUIEvent? {
        guard !slices.isEmpty else { return nil }
        
        let isDifferent = largeDisplay.update(mergingFrom: slices)
        
        // only return an event if the contents actually changed
        guard isDifferent else { return nil }
        
        let topString = largeDisplay.top
        let bottomString = largeDisplay.bottom
        
        return .largeDisplay(top: topString, bottom: bottomString)
    }
    
    private mutating func updateStateFromTimeDisplay(
        charsRightToLeft: [HUITimeDisplayCharacter]
    ) -> HUIEvent? {
        guard !charsRightToLeft.isEmpty else { return nil }
        
        let isDifferent = timeDisplay.timeString.update(charsRightToLeft: charsRightToLeft)
        
        // only return an event if the contents actually changed
        guard isDifferent else { return nil }
        
        return .timeDisplay(timeString: timeDisplay.timeString)
    }
    
    private mutating func updateStateFromAssign(
        text: HUISmallDisplayString
    ) -> HUIEvent? {
        assign.textDisplay = text
        
        return .selectAssignDisplay(text: text)
    }
    
    private mutating func updateStateFromChannelText(
        text: HUISmallDisplayString,
        channelStrip: UInt4
    ) -> HUIEvent? {
        channelStrips[channelStrip.intValue].nameDisplay = text
        
        return .channelStrip(
            channel: channelStrip,
            .nameDisplay(text: text)
        )
    }
    
    private mutating func updateStateFromSwitch(
        huiSwitch: HUISwitch,
        state: Bool
    ) -> HUIEvent? {
        // set state for parameter
        
        setState(of: huiSwitch, to: state)
        
        // return event wrapping the control and its value
        
        switch huiSwitch {
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
            return .window(param: subParam, state: state)
            
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
            
        case let .paramEdit(subParam):
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
            
        case let .undefined(zone: zone, port: port):
            return .undefinedSwitch(zone: zone, port: port, state: state)
        }
    }
}
