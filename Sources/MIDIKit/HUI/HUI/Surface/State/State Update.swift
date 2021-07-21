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
            
        case .levelMeters(channelStrip: let channelStrip,
                          side: let side,
                          level: let level):
            return updateState_LevelMeters(channelStrip: channelStrip,
                                           side: side,
                                           level: level)
            
        case .faderLevel(channelStrip: let channelStrip,
                         level: let level):
            return updateState_FaderLevel(channelStrip: channelStrip,
                                          level: level)
            
        case .vPot(channelStrip: let channelStrip,
                   value: let value):
            return updateState_VPot(channelStrip: channelStrip,
                                    value: value)
            
        case .largeDisplayText(components: let components):
            return updateState_LargeDisplayText(components: components)
            
        case .timeDisplayText(components: let components):
            return updateState_TimeDisplayText(components: components)
            
        case .selectAssignText(text: let text):
            return updateState_AssignText(text: text)
            
        case .channelName(channelStrip: let channelStrip,
                          text: let text):
            return updateState_ChannelText(text: text,
                                           channelStrip: channelStrip)
            
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
        channelStrip: Int,
        side: MIDI.HUI.Surface.State.StereoLevelMeter.Side,
        level: Int
    ) -> MIDI.HUI.Surface.Event? {
        
        switch side {
        case .left: channelStrips[channelStrip].levelMeter.left = level
        case .right: channelStrips[channelStrip].levelMeter.right = level
        }
        
        return .channelStrip(
            channel: channelStrip,
            component: .levelMeter(side: side, level: level)
        )
        
    }
    
    private mutating func updateState_FaderLevel(
        channelStrip: Int,
        level: MIDI.UInt14
    ) -> MIDI.HUI.Surface.Event? {
        
        channelStrips[channelStrip].fader.level = level
        
        return .channelStrip(channel: channelStrip, component: .faderLevel(level))
        
    }
    
    private mutating func updateState_VPot(
        channelStrip: Int,
        value: MIDI.UInt7
    ) -> MIDI.HUI.Surface.Event? {
        
        guard channelStrip.isContained(in: 0...7)
        else {
            Log.debug("HUI: VPot with channel \(channelStrip) not handled - needs coding. Probably a Large Display vPot?")
            return nil
        }
        
        channelStrips[channelStrip].vPotLevel = value
        
        return .channelStrip(channel: channelStrip, component: .vPot(value))
        
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
        channelStrip: Int
    ) -> MIDI.HUI.Surface.Event? {
        
        channelStrips[channelStrip].nameTextDisplay = text
        
        return .channelStrip(channel: channelStrip, component: .nameTextDisplay(text))
        
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
        case .channelStrip(let channel, let channelParam):
            switch channelParam {
            case .recordReady:
                return .channelStrip(channel: channel, component: .recordReady(state))
            case .insert:
                return .channelStrip(channel: channel, component: .insert(state))
            case .vPotSelect:
                return .channelStrip(channel: channel, component: .vPotSelect(state))
            case .auto:
                return .channelStrip(channel: channel, component: .auto(state))
            case .solo:
                return .channelStrip(channel: channel, component: .solo(state))
            case .mute:
                return .channelStrip(channel: channel, component: .mute(state))
            case .select:
                return .channelStrip(channel: channel, component: .select(state))
            case .faderTouched:
                return .channelStrip(channel: channel, component: .faderTouched(state))
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
            
        case .parameterEdit(let subParam):
            return .paramEdit(param: subParam, state: state)
            
        case .footswitchesAndSounds(let subParam):
            return .footswitchesAndSounds(param: subParam, state: state)
        }
        
    }
    
}
