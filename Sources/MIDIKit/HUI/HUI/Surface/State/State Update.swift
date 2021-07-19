//
//  State Update.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import OTCore

// MARK: - Main Update Method

extension MIDI.HUI.Surface.State {
    
    internal mutating func updateState(
        receivedEvent: MIDI.HUI.Parser.Event
    ) -> MIDI.HUI.Surface.Event? {
        
        switch receivedEvent {
        case .pingReceived:
            return .ping
            
        case .levelMeters(channel: let channel,
                          side: let side,
                          level: let level):
            return updateState_LevelMeters(channel: channel,
                                           side: side,
                                           level: level)
            
        case .faderLevel(channel: let channel,
                         level: let level):
            return updateState_FaderLevel(channel: channel,
                                          level: level)
            
        case .vPot(channel: let channel,
                   value: let value):
            return updateState_VPot(channel: channel,
                                    value: value)
            
        case .largeDisplayText(components: let components):
            return updateState_LargeDisplayText(components: components)
            
        case .timeDisplayText(components: let components):
            return updateState_TimeDisplayText(components: components)
            
        case .selectAssignText(text: let text):
            return updateState_AssignText(text: text)
            
        case .channelText(channel: let channel,
                          text: let text):
            return updateState_ChannelText(text: text,
                                           channel: channel)
            
        case .switch(zone: let zone,
                     port: let port,
                     state: let state):
            return updateState_Switch(zone: zone,
                                      port: port,
                                      state: state)
            
        }
        
    }
    
}

// MARK: - State Update Trunk Methods

extension MIDI.HUI.Surface.State {
    
    private mutating func updateState_LevelMeters(
        channel: MIDI.UInt4,
        side: MIDI.HUI.Surface.State.StereoLevelMeter.Side,
        level: Int
    ) -> MIDI.HUI.Surface.Event? {
        
        switch side {
        case .left: channels[channel].levelMeter.left = level
        case .right: channels[channel].levelMeter.right = level
        }
        
        return .channelStrip(
            channel: channel,
            param: .levelMeter(side: side, level: level)
        )
        
    }
    
    private mutating func updateState_FaderLevel(
        channel: MIDI.UInt4,
        level: Int
    ) -> MIDI.HUI.Surface.Event? {
        
        channels[channel].fader.level = level
        
        return .channelStrip(channel: channel, param: .faderLevel(level))
        
    }
    
    private mutating func updateState_VPot(
        channel: MIDI.UInt4,
        value: Int
    ) -> MIDI.HUI.Surface.Event? {
        
        guard channel.isContained(in: 0...7)
        else {
            Log.debug("HUI: VPot with channel \(channel) not handled - needs coding. Probably a Large Display vPot?")
            return nil
        }
        
        channels[channel].vPotLevel = value
        
        return .channelStrip(channel: channel, param: .vPot(value))
        
    }
    
    private mutating func updateState_LargeDisplayText(
        components: [String]
    ) -> MIDI.HUI.Surface.Event? {
        
        largeDisplay.components = components
        
        let topString = largeDisplay.topStringValue
        let bottomString = largeDisplay.bottomStringValue
        
        return .largeDisplay(top: topString, bottom: bottomString)
        
    }
    
    private mutating func updateState_TimeDisplayText(
        components: [String]
    ) -> MIDI.HUI.Surface.Event? {
        
        timeDisplay.components = components
        
        let timeDisplayString = timeDisplay.stringValue
        
        return .timeDisplay(timeString: timeDisplayString)
        
    }
    
    private mutating func updateState_AssignText(
        text: String
    ) -> MIDI.HUI.Surface.Event? {
        
        assign.textDisplay = text
        
        return .selectAssignText(text: text)
        
    }
    
    private mutating func updateState_ChannelText(
        text: String,
        channel: MIDI.UInt4
    ) -> MIDI.HUI.Surface.Event? {
        
        channels[channel].textDisplayString = text
        
        return .channelStrip(channel: channel, param: .textDisplay(text))
        
    }
    
    private mutating func updateState_Switch(
        zone: MIDI.Byte,
        port: MIDI.UInt4,
        state: Bool
    ) -> MIDI.HUI.Surface.Event? {
        
        guard let param = MIDI.HUI.Parameter(zone: zone, port: port)
        else {
            return .unhandledSwitch(zone: zone, port: port, state: state)
        }
        
        // set state for parameter
        
        setState(of: param, to: state)
        
        // return event wrapping the control and its value
        
        switch param {
        case .channel(let channel, let channelParam):
            switch channelParam {
            case .recordReady:
                return .channelStrip(channel: channel, param: .recordReady(state))
            case .insert:
                return .channelStrip(channel: channel, param: .insert(state))
            case .vSel:
                return .channelStrip(channel: channel, param: .vPotSelect(state))
            case .auto:
                return .channelStrip(channel: channel, param: .auto(state))
            case .solo:
                return .channelStrip(channel: channel, param: .solo(state))
            case .mute:
                return .channelStrip(channel: channel, param: .mute(state))
            case .select:
                return .channelStrip(channel: channel, param: .select(state))
            case .faderTouched:
                return .channelStrip(channel: channel, param: .faderTouched(state))
            }
            
        case .hotKey(let subParam):
            return .hotKey(param: subParam, state: state)
            
        case .window(let subParam):
            return .windowFunctions(param: subParam, state: state)
            
        case .bankMove(let subParam):
            return .bankMove(param: subParam, state: state)
            
        case .assign(let subParam):
            return .assign(param: subParam, state: state)
            
        case .cursor(let subParam):
            return .cursor(param: subParam, state: state)
            
        case .transport(let subParam):
            return .transport(param: subParam, state: state)
            
        case .controlRoom(let subParam):
            return .controlRoom(param: subParam, state: state)
            
        case .numPad(let subParam):
            return .numPad(param: subParam, state: state)
            
        case .timeDisplay(let subParam):
            return .timeDisplay(param: subParam, state: state)
            
        case .autoEnable(let subParam):
            return .autoEnable(param: subParam, state: state)
            
        case .autoMode(let subParam):
            return .autoMode(param: subParam, state: state)
            
        case .statusAndGroup(let subParam):
            return .statusAndGroup(param: subParam, state: state)
            
        case .edit(let subParam):
            return .edit(param: subParam, state: state)
            
        case .functionKey(let subParam):
            return .functionKey(param: subParam, state: state)
            
        case .paramEdit(let subParam):
            return .paramEdit(param: subParam, state: state)
            
        case .internalUse(let subParam):
            return .internalUse(param: subParam, state: state)
        }
        
    }
    
}
