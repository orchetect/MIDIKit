//
//  HUISurfaceModel Update.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

// MARK: - Main Update Method

extension HUISurfaceModel {
    /// Updates HUI state from a received ``HUIHostEvent`` (returned from ``HUIHostEventDecoder`` after parsing incoming HUI MIDI).
    /// The corresponding granular ``HUISurfaceModelNotification`` is then returned containing the result of the model change.
    ///
    /// > This is a utility method provided for custom implementations. When using ``HUIHost``/``HUIHostBank`` it is not necessary to call this method as it will be handled automatically.
    ///
    /// - Parameters:
    ///   - receivedEvent: The incoming ``HUIHostEvent``.
    /// - Returns: The strongly-typed ``HUISurfaceModelNotification`` containing the result of the state change.
    @discardableResult
    public mutating func updateState(
        from receivedEvent: HUIHostEvent
    ) -> HUISurfaceModelUpdateResult {
        switch receivedEvent {
        case .ping:
            return .changed(.ping)
            
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
            display: display
        ):
            return updateStateFromVPot(
                vPot: vPot,
                display: display
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
    ) -> HUISurfaceModelUpdateResult {
        switch side {
        case .left:
            let isDiff = channelStrips[channelStrip.intValue].levelMeter.left != level
            guard isDiff else { return .unchanged }
            channelStrips[channelStrip.intValue].levelMeter.left = level
        case .right:
            let isDiff = channelStrips[channelStrip.intValue].levelMeter.right != level
            guard isDiff else { return .unchanged }
            channelStrips[channelStrip.intValue].levelMeter.right = level
        }
        
        let notif: HUISurfaceModelNotification = .channelStrip(
            channel: channelStrip,
            .levelMeter(side: side, level: level)
        )
        return .changed(notif)
    }
    
    private mutating func updateStateFromFaderLevel(
        channelStrip: UInt4,
        level: UInt14
    ) -> HUISurfaceModelUpdateResult {
        let isDiff = channelStrips[channelStrip.intValue].fader.level != level
        guard isDiff else { return .unchanged }
        
        channelStrips[channelStrip.intValue].fader.level = level
        
        let notif: HUISurfaceModelNotification = .channelStrip(
            channel: channelStrip,
            .faderLevel(level: level)
        )
        return .changed(notif)
    }
    
    private mutating func updateStateFromVPot(
        vPot: HUIVPot,
        display: HUIVPotDisplay
    ) -> HUISurfaceModelUpdateResult {
        let notif: HUISurfaceModelNotification
        
        switch vPot {
        case let .channel(chan):
            let isDiff = channelStrips[chan.intValue].vPotDisplay != display
            guard isDiff else { return .unchanged }
            
            channelStrips[chan.intValue].vPotDisplay = display
            notif = .channelStrip(
                channel: chan,
                .vPot(display: display)
            )
            
        case .editAssignA:
            let isDiff = parameterEdit.param1VPotDisplay != display
            guard isDiff else { return .unchanged }
            
            parameterEdit.param1VPotDisplay = display
            notif = .paramEdit(.param1VPot(display: display))
            
        case .editAssignB:
            let isDiff = parameterEdit.param2VPotDisplay != display
            guard isDiff else { return .unchanged }
            
            parameterEdit.param2VPotDisplay = display
            notif = .paramEdit(.param2VPot(display: display))
            
        case .editAssignC:
            let isDiff = parameterEdit.param3VPotDisplay != display
            guard isDiff else { return .unchanged }
            
            parameterEdit.param3VPotDisplay = display
            notif = .paramEdit(.param3VPot(display: display))
            
        case .editAssignD:
            let isDiff = parameterEdit.param4VPotDisplay != display
            guard isDiff else { return .unchanged }
            
            parameterEdit.param4VPotDisplay = display
            notif = .paramEdit(.param4VPot(display: display))
            
        case .editAssignScroll:
            // scroll V-Pot has no LED ring display; ignore
            return .unchanged
        }
        
        return .changed(notif)
    }
    
    private mutating func updateStateFromLargeDisplay(
        slices: HUILargeDisplaySlices
    ) -> HUISurfaceModelUpdateResult {
        guard !slices.isEmpty else { return .unchanged }
        
        let isDiff = largeDisplay.update(mergingFrom: slices)
        
        // only return an event if the contents actually changed
        guard isDiff else { return .unchanged }
        
        let topString = largeDisplay.top
        let bottomString = largeDisplay.bottom
        
        let notif: HUISurfaceModelNotification = .largeDisplay(
            top: topString,
            bottom: bottomString
        )
        return .changed(notif)
    }
    
    private mutating func updateStateFromTimeDisplay(
        charsRightToLeft: [HUITimeDisplayCharacter]
    ) -> HUISurfaceModelUpdateResult {
        guard !charsRightToLeft.isEmpty else { return .unchanged }
        
        let isDiff = timeDisplay.timeString.update(charsRightToLeft: charsRightToLeft)
        
        // only return an event if the contents actually changed
        guard isDiff else { return .unchanged }
        
        let notif: HUISurfaceModelNotification = .timeDisplay(
            timeString: timeDisplay.timeString
        )
        return .changed(notif)
    }
    
    private mutating func updateStateFromAssign(
        text: HUISmallDisplayString
    ) -> HUISurfaceModelUpdateResult {
        let isDiff = assign.textDisplay != text
        
        // only return an event if the contents actually changed
        guard isDiff else { return .unchanged }
        
        assign.textDisplay = text
        
        let notif: HUISurfaceModelNotification = .selectAssignDisplay(
            text: text
        )
        return .changed(notif)
    }
    
    private mutating func updateStateFromChannelText(
        text: HUISmallDisplayString,
        channelStrip: UInt4
    ) -> HUISurfaceModelUpdateResult {
        let isDiff = channelStrips[channelStrip.intValue].nameDisplay != text
        
        // only return an event if the contents actually changed
        guard isDiff else { return .unchanged }
        
        channelStrips[channelStrip.intValue].nameDisplay = text
        
        let notif: HUISurfaceModelNotification = .channelStrip(
            channel: channelStrip,
            .nameDisplay(text: text)
        )
        return .changed(notif)
    }
    
    private mutating func updateStateFromSwitch(
        huiSwitch: HUISwitch,
        state: Bool
    ) -> HUISurfaceModelUpdateResult {
        let isDiff = self.state(of: huiSwitch) != state
        guard isDiff else { return .unchanged }
        
        // set state for parameter
        
        setState(of: huiSwitch, to: state)
        
        // return event wrapping the control and its value
        
        switch huiSwitch {
        case let .channelStrip(channel, channelParam):
            switch channelParam {
            case .recordReady:
                return .changed(.channelStrip(
                    channel: channel,
                    .recordReady(state: state)
                ))
            case .insert:
                return .changed(.channelStrip(
                    channel: channel,
                    .insert(state: state)
                ))
            case .vPotSelect:
                return .changed(.channelStrip(
                    channel: channel,
                    .vPotSelect(state: state)
                ))
            case .auto:
                return .changed(.channelStrip(
                    channel: channel,
                    .auto(state: state)
                ))
            case .solo:
                return .changed(.channelStrip(
                    channel: channel,
                    .solo(state: state)
                ))
            case .mute:
                return .changed(.channelStrip(
                    channel: channel,
                    .mute(state: state)
                ))
            case .select:
                return .changed(.channelStrip(
                    channel: channel,
                    .select(state: state)
                ))
            case .faderTouched:
                // ignore - only HUI surface can send fader touch messages
                return .unchanged
            }
            
        case let .hotKey(subParam):
            return .changed(.hotKey(param: subParam, state: state))
            
        case let .window(subParam):
            return .changed(.window(param: subParam, state: state))
            
        case let .bankMove(subParam):
            return .changed(.bankMove(param: subParam, state: state))
            
        case let .assign(subParam):
            return .changed(.assign(param: subParam, state: state))
            
        case let .cursor(subParam):
            return .changed(.cursor(param: subParam, state: state))
            
        case let .transport(subParam):
            return .changed(.transport(param: subParam, state: state))
            
        case let .controlRoom(subParam):
            return .changed(.controlRoom(param: subParam, state: state))
            
        case let .numPad(subParam):
            return .changed(.numPad(param: subParam, state: state))
            
        case let .timeDisplayStatus(subParam):
            return .changed(.timeDisplayStatus(param: subParam, state: state))
            
        case let .autoEnable(subParam):
            return .changed(.autoEnable(param: subParam, state: state))
            
        case let .autoMode(subParam):
            return .changed(.autoMode(param: subParam, state: state))
            
        case let .statusAndGroup(subParam):
            return .changed(.statusAndGroup(param: subParam, state: state))
            
        case let .edit(subParam):
            return .changed(.edit(param: subParam, state: state))
            
        case let .functionKey(subParam):
            return .changed(.functionKey(param: subParam, state: state))
            
        case let .paramEdit(subParam):
            switch subParam {
            case .assign:
                return .changed(.paramEdit(.assign(state: state)))
            case .compare:
                return .changed(.paramEdit(.compare(state: state)))
            case .bypass:
                return .changed(.paramEdit(.bypass(state: state)))
            case .param1Select:
                return .changed(.paramEdit(.param1Select(state: state)))
            case .param2Select:
                return .changed(.paramEdit(.param2Select(state: state)))
            case .param3Select:
                return .changed(.paramEdit(.param3Select(state: state)))
            case .param4Select:
                return .changed(.paramEdit(.param4Select(state: state)))
            case .insertOrParam:
                return .changed(.paramEdit(.insertOrParam(state: state)))
            }
            
        case let .footswitchesAndSounds(subParam):
            return .changed(.footswitchesAndSounds(param: subParam, state: state))
            
        case let .undefined(zone: zone, port: port):
            return .unhandled(
                .switch(huiSwitch: .undefined(zone: zone, port: port), state: state)
            )
        }
    }
}
