//
//  HUISurfaceModel Accessors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
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
            channelStrips[channel.intValue].state(of: subParam)
            
        case let .hotKey(subParam):
            hotKeys.state(of: subParam)
            
        case let .window(subParam):
            windowFunctions.state(of: subParam)
            
        case let .bankMove(subParam):
            bankMove.state(of: subParam)
            
        case let .assign(subParam):
            assign.state(of: subParam)
            
        case let .cursor(subParam):
            cursor.state(of: subParam)
            
        case let .transport(subParam):
            transport.state(of: subParam)
            
        case let .controlRoom(subParam):
            controlRoom.state(of: subParam)
            
        case let .numPad(subParam):
            numPad.state(of: subParam)
            
        case let .timeDisplayStatus(subParam):
            timeDisplay.state(of: subParam)
            
        case let .autoEnable(subParam):
            autoEnable.state(of: subParam)
            
        case let .autoMode(subParam):
            autoMode.state(of: subParam)
            
        case let .statusAndGroup(subParam):
            statusAndGroup.state(of: subParam)
            
        case let .edit(subParam):
            edit.state(of: subParam)
            
        case let .functionKey(subParam):
            functionKey.state(of: subParam)
            
        case let .paramEdit(subParam):
            parameterEdit.state(of: subParam)
            
        case let .footswitchesAndSounds(subParam):
            footswitchesAndSounds.state(of: subParam)
            
        case .undefined(zone: _, port: _):
            // no actual state - just return false as a default
            false
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
            channelStrips[channel.intValue].vPotDisplay
        case .editAssignA:
            parameterEdit.param1VPotDisplay
        case .editAssignB:
            parameterEdit.param2VPotDisplay
        case .editAssignC:
            parameterEdit.param3VPotDisplay
        case .editAssignD:
            parameterEdit.param4VPotDisplay
        case .editAssignScroll:
            // scroll knob has no LED ring display, just return empty LED config
            .init(leds: .allOff, lowerLED: false)
        }
    }
}
