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
            return nil
            
        case .levelMeters(channel: let channel,
                          leftSide: let leftSide,
                          level: let level):
            return updateState_LevelMeters(channel: channel,
                                           leftSide: leftSide,
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
            
        case .channelText(text: let text,
                          channel: let channel):
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
        channel: Int,
        leftSide: Bool,
        level: Int
    ) -> MIDI.HUI.Surface.Event? {
        
        let side: MIDI.HUI.LevelMetersSide = leftSide ? .left : .right
        
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
        channel: Int,
        level: Int
    ) -> MIDI.HUI.Surface.Event? {
        
        channels[channel].fader.level = level
        
        return .channelStrip(channel: channel, param: .faderLevel(level))
        
    }
    
    private mutating func updateState_VPot(
        channel: Int,
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
        channel: Int
    ) -> MIDI.HUI.Surface.Event? {
        
        channels[channel].textDisplayString = text
        
        return .channelStrip(channel: channel, param: .textDisplay(text))
        
    }
    
    private mutating func updateState_Switch(
        zone: Int,
        port: Int,
        state: Bool
    ) -> MIDI.HUI.Surface.Event? {
        
        guard let param = MIDI.HUI.Parameter(zone: zone, port: port)
        else {
            Log.debug("Received switch change message but could not find a matching switch in the lookup table. Received zone \(zone.hex.stringValue(prefix: true)), port \(port.hex.stringValue(prefix: true)), state \(state)")
            return nil
        }
        
        switch zone {
        case 0x00...0x07:
            // channel strip related
            let channel = zone
            return updateState_Switch_Channel(param: param,
                                              channel: channel,
                                              port: port,
                                              state: state)
            
        case 0x08:
            // hotkey
            return updateState_Switch_HotKey(param: param, state: state)
            
        case 0x09:
            // window
            return updateState_Switch_Window(param: param, state: state)
            
        case 0x0A:
            // bank move
            return updateState_Switch_BankMove(param: param, state: state)
            
        case 0x0B...0x0C:
            // assign
            return updateState_Switch_Assign(param: param, state: state)
            
        case 0x0D:
            // cursor
            return updateState_Switch_Cursor(param: param, state: state)
            
        case 0x0E...0x10:
            // transport
            return updateState_Switch_Transport(param: param, state: state)
            
        case 0x11...0x12:
            // control room
            return updateState_Switch_ControlRoom(param: param, state: state)
        
        case 0x13...0x15:
            // num pad
            // transmit-only to host (host never transmits these to the HUI device)
            // so no state is needed to be kept, just return the event
            return .hotKey(param: param, state: state)
            
        case 0x16:
            // time display LEDs / rude solo light
            return updateState_Switch_LEDs(param: param, state: state)
            
        case 0x17:
            // Auto Enable button group
            // ***** needs implementing in future
            return .unhandledSwitch(switchName: param, state: state)
            
        case 0x18:
            // Auto Mode button group
            // ***** needs implementing in future
            return .unhandledSwitch(switchName: param, state: state)
        case 0x19:
            // Status/Group button group
            // ***** needs implementing in future
            return .unhandledSwitch(switchName: param, state: state)
            
        case 0x1A:
            // Edit button group
            // ***** needs implementing in future
            return .unhandledSwitch(switchName: param, state: state)
            
        case 0x1B:
            // Function keys (F1-F8)
            // ***** needs implementing in future
            return .unhandledSwitch(switchName: param, state: state)
            
        case 0x1C:
            // Parameter Edit
            // ***** needs implementing in future
            return .unhandledSwitch(switchName: param, state: state)
            
        case 0x1D:
            // Functions only - no LEDs or buttons
            // ***** needs implementing in future
            return .unhandledSwitch(switchName: param, state: state)
            
        default:
            return .unhandledSwitch(switchName: param, state: state)
        }
        
    }
    
}

// MARK: - State Update Switches

extension MIDI.HUI.Surface.State {
    
    private mutating func updateState_Switch_Channel(
        param: MIDI.HUI.Parameter,
        channel: Int,
        port: Int,
        state: Bool
    ) -> MIDI.HUI.Surface.Event? {
        
        switch port {
        case 0x0: // fader
            // not sure if this is ever used?? (port 0 on channel zones 0-7)
            return .unhandledSwitch(switchName: param, state: state)
            
        case 0x1: // select
            channels[channel].select = state
            return .channelStrip(channel: channel, param: .select(state))
            
        case 0x2: // mute
            channels[channel].mute = state
            return .channelStrip(channel: channel, param: .mute(state))
            
        case 0x3: // solo
            channels[channel].solo = state
            return .channelStrip(channel: channel, param: .solo(state))
            
        case 0x4: // auto
            channels[channel].auto = state
            return .channelStrip(channel: channel, param: .auto(state))
            
        case 0x5: // VSel
            channels[channel].vPotSelect = state
            return .channelStrip(channel: channel, param: .vPotSelect(state))
            
        case 0x6: // insert
            channels[channel].insert = state
            return .channelStrip(channel: channel, param: .insert(state))
            
        case 0x7: // record ready
            channels[channel].recordReady = state
            return .channelStrip(channel: channel, param: .recordReady(state))
            
        default:
            return nil
            
        }
        
    }
    
    private mutating func updateState_Switch_HotKey(
        param: MIDI.HUI.Parameter,
        state: Bool
    ) -> MIDI.HUI.Surface.Event? {
        
        switch param {
        case .hotkey_shift: hotKeys.shift = state
        case .hotkey_ctrl: hotKeys.ctrl = state
        case .hotkey_option: hotKeys.option = state
        case .hotkey_cmd: hotKeys.cmd = state
            
        case .hotkey_undo: hotKeys.undo = state
        case .hotkey_save: hotKeys.save = state
            
        case .hotkey_editMode: hotKeys.editMode = state
        case .hotkey_editTool: hotKeys.editTool = state
            
        default: break
        }
        
        return .hotKey(param: param, state: state)
        
    }
    
    private mutating func updateState_Switch_Window(
        param: MIDI.HUI.Parameter,
        state: Bool
    ) -> MIDI.HUI.Surface.Event? {
        
        switch param {
        case .window_mix: windowFunctions.mix = state
        case .window_edit: windowFunctions.edit = state
        case .window_transport: windowFunctions.transport = state
        case .window_memLoc: windowFunctions.memLoc = state
        case .window_status: windowFunctions.status = state
        case .window_alt: windowFunctions.alt = state
        default: break
        }
        
        return .windowFunctions(param: param, state: state)
        
    }
    
    private mutating func updateState_Switch_BankMove(
        param: MIDI.HUI.Parameter,
        state: Bool
    ) -> MIDI.HUI.Surface.Event? {
        
        switch param {
        case .bankMove_ChannelLeft: bankMove.channelLeft = state
        case .bankMove_ChannelRight: bankMove.channelRight = state
        case .bankMove_BankLeft: bankMove.bankLeft = state
        case .bankMove_BankRight: bankMove.bankRight = state
        default: break
        }
        
        return .bankMove(param: param, state: state)
        
    }
    
    private mutating func updateState_Switch_Assign(
        param: MIDI.HUI.Parameter,
        state: Bool
    ) -> MIDI.HUI.Surface.Event? {
        
        switch param {
        case .assign_recordReadyAll: assign.recordReadyAll = state
        case .assign_bypass: assign.bypass = state
            
        case .assign_sendA: assign.sendA = state
        case .assign_sendB: assign.sendB = state
        case .assign_sendC: assign.sendC = state
        case .assign_sendD: assign.sendD = state
        case .assign_sendE: assign.sendE = state
        case .assign_pan: assign.pan = state
            
        case .assign_mute: assign.mute = state
        case .assign_shift: assign.shift = state
            
        case .assign_input: assign.input = state
        case .assign_output: assign.output = state
        case .assign_assign: assign.assign = state
            
        case .assign_suspend: assign.suspend = state
        case .assign_default: assign.default = state
            
        default: break
        }
        
        return .assign(param: param, state: state)
        
    }
    
    private mutating func updateState_Switch_Cursor(
        param: MIDI.HUI.Parameter,
        state: Bool
    ) -> MIDI.HUI.Surface.Event? {
        
        switch param {
        case .cursor_mode: cursor.mode = state
            
        case .cursor_up: break // no LED, just command buttons
        case .cursor_down: break // no LED, just command buttons
        case .cursor_left: break // no LED, just command buttons
        case .cursor_right: break // no LED, just command buttons
            
        case .cursor_scrub: cursor.scrub = state
        case .cursor_shuttle: cursor.shuttle = state
        default: break
        }
        
        return .cursor(param: param, state: state)
        
    }
    
    private mutating func updateState_Switch_Transport(
        param: MIDI.HUI.Parameter,
        state: Bool
    ) -> MIDI.HUI.Surface.Event? {
        
        switch param {
        case .transport_rewind: transport.rewind = state
        case .transport_stop: transport.stop = state
        case .transport_play: transport.play = state
        case .transport_fastFwd: transport.fastFwd = state
        case .transport_record: transport.record = state
            
        case .transport_talkback: transport.talkback = state
            
        case .transport_punch_audition: transport.punch_audition = state
        case .transport_punch_pre: transport.punch_pre = state
        case .transport_punch_in: transport.punch_in = state
        case .transport_punch_out: transport.punch_out = state
        case .transport_punch_post: transport.punch_post = state
        case .transport_rtz: transport.rtz = state
        case .transport_end: transport.end = state
        case .transport_online: transport.online = state
        case .transport_loop: transport.loop = state
        case .transport_quickPunch: transport.quickPunch = state
            
        default: break
        }
        
        return .transport(param: param, state: state)
        
    }
    
    private mutating func updateState_Switch_ControlRoom(
        param: MIDI.HUI.Parameter,
        state: Bool
    ) -> MIDI.HUI.Surface.Event? {
        
        switch param {
        case .controlRoom_input1: controlRoom.input1 = state
        case .controlRoom_input2: controlRoom.input2 = state
        case .controlRoom_input3: controlRoom.input3 = state
        case .controlRoom_discrete: controlRoom.discrete = state
        case .controlRoom_mute: controlRoom.mute = state
            
        case .controlRoom_output1: controlRoom.output1 = state
        case .controlRoom_output2: controlRoom.output2 = state
        case .controlRoom_output3: controlRoom.output3 = state
        case .controlRoom_dim: controlRoom.dim = state
        case .controlRoom_mono: controlRoom.mono = state
            
        default: break
        }
        
        return .controlRoom(param: param, state: state)
        
    }
    
    private mutating func updateState_Switch_LEDs(
        param: MIDI.HUI.Parameter,
        state: Bool
    ) -> MIDI.HUI.Surface.Event? {
        
        switch param {
        case .LED_timecode_timecode: timeDisplay.timecode = state
        case .LED_timecode_feet: timeDisplay.feet = state
        case .LED_timecode_beats: timeDisplay.beats = state
            
        case .LED_rudeSolo: timeDisplay.rudeSolo = state
            
        default: break
        }
        
        return .timeDisplay(param: param, state: state)
        
    }
    
}
