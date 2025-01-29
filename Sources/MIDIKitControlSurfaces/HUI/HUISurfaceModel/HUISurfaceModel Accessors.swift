//
//  HUISurfaceModel Accessors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModel: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch
    
    /// Returns the current state in the model of the given HUI switch parameter.
    ///
    /// > Reading state of ``HUISwitch/undefined(zone:port:)`` will always return `false` as state
    /// > is not stored for undefined switches.
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case let .channelStrip(channel, subParam):
            return channelStrips[channel.intValue].state(of: subParam)
            
        case let .hotKey(subParam):
            return hotKeys.state(of: subParam)
            
        case let .window(subParam):
            return windowFunctions.state(of: subParam)
            
        case let .bankMove(subParam):
            return bankMove.state(of: subParam)
            
        case let .assign(subParam):
            return assign.state(of: subParam)
            
        case let .cursor(subParam):
            return cursor.state(of: subParam)
            
        case let .transport(subParam):
            return transport.state(of: subParam)
            
        case let .controlRoom(subParam):
            return controlRoom.state(of: subParam)
            
        case let .numPad(subParam):
            return numPad.state(of: subParam)
            
        case let .timeDisplayStatus(subParam):
            return timeDisplay.state(of: subParam)
            
        case let .autoEnable(subParam):
            return autoEnable.state(of: subParam)
            
        case let .autoMode(subParam):
            return autoMode.state(of: subParam)
            
        case let .statusAndGroup(subParam):
            return statusAndGroup.state(of: subParam)
            
        case let .edit(subParam):
            return edit.state(of: subParam)
            
        case let .functionKey(subParam):
            return functionKey.state(of: subParam)
            
        case let .paramEdit(subParam):
            return parameterEdit.state(of: subParam)
            
        case let .footswitchesAndSounds(subParam):
            return footswitchesAndSounds.state(of: subParam)
            
        case .undefined(zone: _, port: _):
            // no actual state - just return false as a default
            return false
        }
    }
    
    /// Sets the state in the model of the given HUI switch parameter.
    ///
    /// > Setting state for ``HUISwitch/undefined(zone:port:)`` has no effect and will not be
    /// > stored.
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case let .channelStrip(channel, subParam):
            channelStrips[channel.intValue].setState(of: subParam, to: state)
            
        case let .hotKey(subParam):
            hotKeys.setState(of: subParam, to: state)
            
        case let .window(subParam):
            windowFunctions.setState(of: subParam, to: state)
            
        case let .bankMove(subParam):
            bankMove.setState(of: subParam, to: state)
            
        case let .assign(subParam):
            assign.setState(of: subParam, to: state)
            
        case let .cursor(subParam):
            cursor.setState(of: subParam, to: state)
            
        case let .transport(subParam):
            transport.setState(of: subParam, to: state)
            
        case let .controlRoom(subParam):
            controlRoom.setState(of: subParam, to: state)
            
        case let .numPad(subParam):
            numPad.setState(of: subParam, to: state)
            
        case let .timeDisplayStatus(subParam):
            timeDisplay.setState(of: subParam, to: state)
            
        case let .autoEnable(subParam):
            autoEnable.setState(of: subParam, to: state)
            
        case let .autoMode(subParam):
            autoMode.setState(of: subParam, to: state)
            
        case let .statusAndGroup(subParam):
            statusAndGroup.setState(of: subParam, to: state)
            
        case let .edit(subParam):
            edit.setState(of: subParam, to: state)
            
        case let .functionKey(subParam):
            functionKey.setState(of: subParam, to: state)
            
        case let .paramEdit(subParam):
            parameterEdit.setState(of: subParam, to: state)
            
        case let .footswitchesAndSounds(subParam):
            footswitchesAndSounds.setState(of: subParam, to: state)
            
        case .undefined(zone: _, port: _):
            // don't store state for undefined switches
            break
        }
    }
    
    /// Returns the current LED display state in the model of the given HUI V-Pot.
    ///
    /// > The rotary scroll knob in the DSP Edit/Assign section does not have an LED ring display,
    /// > so default will always be returned.
    @inlinable
    public func state(of vPot: HUIVPot) -> HUIVPotDisplay {
        switch vPot {
        case let .channel(channel):
            return channelStrips[channel.intValue].vPotDisplay
        case .editAssignA:
            return parameterEdit.param1VPotDisplay
        case .editAssignB:
            return parameterEdit.param2VPotDisplay
        case .editAssignC:
            return parameterEdit.param3VPotDisplay
        case .editAssignD:
            return parameterEdit.param4VPotDisplay
        case .editAssignScroll:
            // scroll knob has no LED ring display, just return empty LED config
            return .init(leds: .allOff, lowerLED: false)
        }
    }
}
