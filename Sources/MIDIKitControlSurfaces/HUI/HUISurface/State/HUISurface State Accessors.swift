//
//  HUISurface State Accessors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurface.State: HUISurfaceStateProtocol {
    public typealias Param = HUIParameter
    
    public func state(of param: Param) -> Bool {
        switch param {
        case let .channelStrip(channel, channelParam):
            return channelStrips[channel].state(of: channelParam)
            
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
            
        case let .timeDisplay(subParam):
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
            
        case let .parameterEdit(subParam):
            return parameterEdit.state(of: subParam)
            
        case let .footswitchesAndSounds(subParam):
            return footswitchesAndSounds.state(of: subParam)
        }
    }
    
    public mutating func setState(of param: Param, to state: Bool) {
        switch param {
        case let .channelStrip(channel, channelParam):
            channelStrips[channel].setState(of: channelParam, to: state)
            
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
            
        case let .timeDisplay(subParam):
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
            
        case let .parameterEdit(subParam):
            parameterEdit.setState(of: subParam, to: state)
            
        case let .footswitchesAndSounds(subParam):
            footswitchesAndSounds.setState(of: subParam, to: state)
        }
    }
}
