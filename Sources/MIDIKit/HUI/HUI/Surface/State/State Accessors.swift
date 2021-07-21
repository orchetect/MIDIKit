//
//  State Accessors.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import OTCore

extension MIDI.HUI.Surface.State: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter
    
    public func state(of param: Enum) -> Bool {
        
        switch param {
        case .channelStrip(let channel, let channelParam):
            return channelStrips[channel].state(of: channelParam)
            
        case .hotKey(let subParam):
            return hotKeys.state(of: subParam)
            
        case .window(let subParam):
            return windowFunctions.state(of: subParam)
            
        case .bankMove(let subParam):
            return bankMove.state(of: subParam)
            
        case .assign(let subParam):
            return assign.state(of: subParam)
            
        case .cursor(let subParam):
            return cursor.state(of: subParam)
            
        case .transport(let subParam):
            return transport.state(of: subParam)
            
        case .controlRoom(let subParam):
            return controlRoom.state(of: subParam)
            
        case .numPad(let subParam):
            return numPad.state(of: subParam)
            
        case .timeDisplay(let subParam):
            return timeDisplay.state(of: subParam)
            
        case .autoEnable(let subParam):
            return autoEnable.state(of: subParam)
            
        case .autoMode(let subParam):
            return autoMode.state(of: subParam)
            
        case .statusAndGroup(let subParam):
            return statusAndGroup.state(of: subParam)
            
        case .edit(let subParam):
            return edit.state(of: subParam)
            
        case .functionKey(let subParam):
            return functionKey.state(of: subParam)
            
        case .parameterEdit(let subParam):
            return parameterEdit.state(of: subParam)
            
        case .footswitchesAndSounds(let subParam):
            return footswitchesAndSounds.state(of: subParam)
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        case .channelStrip(let channel, let channelParam):
            channelStrips[channel].setState(of: channelParam, to: state)
            
        case .hotKey(let subParam):
            hotKeys.setState(of: subParam, to: state)
            
        case .window(let subParam):
            windowFunctions.setState(of: subParam, to: state)
            
        case .bankMove(let subParam):
            bankMove.setState(of: subParam, to: state)
            
        case .assign(let subParam):
            assign.setState(of: subParam, to: state)
            
        case .cursor(let subParam):
            cursor.setState(of: subParam, to: state)
            
        case .transport(let subParam):
            transport.setState(of: subParam, to: state)
            
        case .controlRoom(let subParam):
            controlRoom.setState(of: subParam, to: state)
            
        case .numPad(let subParam):
            numPad.setState(of: subParam, to: state)
            
        case .timeDisplay(let subParam):
            timeDisplay.setState(of: subParam, to: state)
            
        case .autoEnable(let subParam):
            autoEnable.setState(of: subParam, to: state)
            
        case .autoMode(let subParam):
            autoMode.setState(of: subParam, to: state)
            
        case .statusAndGroup(let subParam):
            statusAndGroup.setState(of: subParam, to: state)
            
        case .edit(let subParam):
            edit.setState(of: subParam, to: state)
            
        case .functionKey(let subParam):
            functionKey.setState(of: subParam, to: state)
            
        case .parameterEdit(let subParam):
            parameterEdit.setState(of: subParam, to: state)
            
        case .footswitchesAndSounds(let subParam):
            footswitchesAndSounds.setState(of: subParam, to: state)
        }
        
    }
    
}
