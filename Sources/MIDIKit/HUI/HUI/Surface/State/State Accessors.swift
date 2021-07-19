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
        case .channel(let channel, let channelParam):
            return channels[channel].state(of: channelParam)
            
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
            _ = subParam ; break //return numPad.state(of: subParam)
            
        case .timeDisplay(let subParam):
            return timeDisplay.state(of: subParam)
            
        case .autoEnable(let subParam):
            _ = subParam ; break //return autoEnable.state(of: subParam)
            
        case .autoMode(let subParam):
            _ = subParam ; break //return autoMode.state(of: subParam)
            
        case .statusAndGroup(let subParam):
            _ = subParam ; break //return statusAndGroup.state(of: subParam)
            
        case .edit(let subParam):
            _ = subParam ; break //return statusAndGroup.state(of: subParam)
            
        case .functionKey(let subParam):
            _ = subParam ; break //return functionKey.state(of: subParam)
            
        case .paramEdit(let subParam):
            _ = subParam ; break //return paramEdit.state(of: subParam)
            
        case .internalUse(let subParam):
            _ = subParam ; break //return internalUse.state(of: subParam)
        }
        
        Log.error("MIDI.HUI.Surface.State not yet implemented for this switch: \(param). 🤷‍♂️")
        return false
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        case .channel(let channel, let channelParam):
            channels[channel].setState(of: channelParam, to: state)
            
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
            
        case .paramEdit(let subParam):
            parameterEdit.setState(of: subParam, to: state)
            
        case .internalUse(let subParam):
            internalUse.setState(of: subParam, to: state)
        }
        
    }
    
}
