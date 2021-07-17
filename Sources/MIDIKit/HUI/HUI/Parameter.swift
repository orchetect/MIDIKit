//
//  Parameter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.HUI {
    
    /// HUI Parameter, representing a Zone and Port combination.
    public enum Parameter: Hashable {
        
        // Zones 0x00 - 0x07
        // Channel Strips
        case channel0_fader
        case channel0_select
        case channel0_mute
        case channel0_solo
        case channel0_auto
        case channel0_vSel
        case channel0_insert
        case channel0_rec
        
        case channel1_fader
        case channel1_select
        case channel1_mute
        case channel1_solo
        case channel1_auto
        case channel1_vSel
        case channel1_insert
        case channel1_rec
        
        case channel2_fader
        case channel2_select
        case channel2_mute
        case channel2_solo
        case channel2_auto
        case channel2_vSel
        case channel2_insert
        case channel2_rec
        
        case channel3_fader
        case channel3_select
        case channel3_mute
        case channel3_solo
        case channel3_auto
        case channel3_vSel
        case channel3_insert
        case channel3_rec
        
        case channel4_fader
        case channel4_select
        case channel4_mute
        case channel4_solo
        case channel4_auto
        case channel4_vSel
        case channel4_insert
        case channel4_rec
        
        case channel5_fader
        case channel5_select
        case channel5_mute
        case channel5_solo
        case channel5_auto
        case channel5_vSel
        case channel5_insert
        case channel5_rec
        
        case channel6_fader
        case channel6_select
        case channel6_mute
        case channel6_solo
        case channel6_auto
        case channel6_vSel
        case channel6_insert
        case channel6_rec
        
        case channel7_fader
        case channel7_select
        case channel7_mute
        case channel7_solo
        case channel7_auto
        case channel7_vSel
        case channel7_insert
        case channel7_rec
        
        // Zone 0x08
        // Keyboard Shortcuts
        case hotkey_ctrl
        case hotkey_shift
        case hotkey_editMode
        case hotkey_undo
        case hotkey_cmd
        case hotkey_option
        case hotkey_editTool
        case hotkey_save
        
        // Zone 0x09
        // Window Functions
        case window_mix
        case window_edit
        case window_transport
        case window_memLoc
        case window_status
        case window_alt
        
        // Zone 0x0A
        // Channel Selection (scroll/bank channels in view)
        case bankMove_ChannelLeft
        case bankMove_BankLeft
        case bankMove_ChannelRight
        case bankMove_BankRight
        
        // Zone 0x0B
        // Assign 1 (buttons to top left of channel strips)
        case assign_output
        case assign_input
        case assign_pan
        case assign_sendE
        case assign_sendD
        case assign_sendC
        case assign_sendB
        case assign_sendA
        
        // Zone 0x0C
        // Assign 2 (buttons to top left of channel strips)
        case assign_assign
        case assign_default
        case assign_suspend
        case assign_shift
        case assign_mute
        case assign_bypass
        case assign_recordReadyAll
        
        // Zone 0x0D
        // Cursor Movement / Mode / Scrub / Shuttle
        case cursor_down
        case cursor_left
        case cursor_mode            // has LED; button in center of cursor direction keys
        case cursor_right
        case cursor_up
        case cursor_scrub           // has LED; to the right of the jogwheel
        case cursor_shuttle         // has LED; to the right of the jogwheel
        
        // Zone 0x0E
        // Transport Main
        case transport_talkback     // activates onboard talkback mic
        case transport_rewind
        case transport_fastFwd
        case transport_stop
        case transport_play
        case transport_record
        
        // Zone 0x0F
        // Transport continued
        case transport_rtz          // |< RTZ
        case transport_end          // END >|
        case transport_online
        case transport_loop
        case transport_quickPunch
        
        // Zone 0x10
        // Transport Punch
        case transport_punch_audition
        case transport_punch_pre
        case transport_punch_in
        case transport_punch_out
        case transport_punch_post
        
        // Zone 0x11
        // Control Room - Monitor Input
        case controlRoom_input3
        case controlRoom_input2
        case controlRoom_input1
        case controlRoom_mute
        case controlRoom_discrete   // 1:1 Discrete input
        
        // Zone 0x12
        // Control Room - Monitor Output
        case controlRoom_output3
        case controlRoom_output2
        case controlRoom_output1
        case controlRoom_dim
        case controlRoom_mono
        
        // Zone 0x13
        // Num Pad
        case numpad_0
        case numpad_1
        case numpad_4
        case numpad_2
        case numpad_5
        case numpad_period          // .
        case numpad_3
        case numpad_6
        
        // Zone 0x14
        // Num Pad
        case numpad_enter
        case numpad_plus            // +
        
        // Zone 0x15
        // Num Pad
        case numpad_7
        case numpad_8
        case numpad_9
        case numpad_minus           // -
        case numpad_clr             // clr
        case numpad_equals          // =
        case numpad_forwardSlash    // /
        case numpad_asterisk        // *
        
        // Zone 0x16
        // Time Display LEDs
        case LED_timecode_timecode  // "TIME CODE"  Timecode LEDs that are to the left of the timecode readout above the control room section (no buttons, LEDs only)
        case LED_timecode_feet      // "FEET"       Timecode LEDs that are to the left of the timecode readout above the control room section (no buttons, LEDs only)
        case LED_timecode_beats     // "BEATS"      Timecode LEDs that are to the left of the timecode readout above the control room section (no buttons, LEDs only)
        case LED_rudeSolo           // "RUDE SOLO LIGHT"    Above the control room section
        
        // Zone 0x17
        // Auto Enable (To the right of the channel strips)
        case autoEnable_plugin
        case autoEnable_pan
        case autoEnable_fader
        case autoEnable_sendMute
        case autoEnable_send
        case autoEnable_mute
        
        // Zone 0x18
        // Auto Mode (To the right of the channel strips)
        case autoMode_trim
        case autoMode_latch
        case autoMode_read
        case autoMode_off
        case autoMode_write
        case autoMode_touch
        
        // Zone 0x19          Status/Group (To the right of the channel strips)
        case statusGroup_phase
        case statusGroup_monitor
        case statusGroup_auto
        case statusGroup_suspend
        case statusGroup_create
        case statusGroup_group
        
        // Zone 0x1A
        // Edit (To the right of the channel strips)
        case edit_paste
        case edit_cut
        case edit_capture
        case edit_delete
        case edit_copy
        case edit_separate
        
        // Zone 0x1B
        // Function Keys
        case functionKey_F1
        case functionKey_F2
        case functionKey_F3
        case functionKey_F4
        case functionKey_F5
        case functionKey_F6
        case functionKey_F7
        case functionKey_F8_or_Esc
        
        // Zone 0x1C
        // Parameter Edit  (Section at top right below the Large Display readout)
        case paramEdit_insertParam  // INSERT (off) / PARAM (on) toggle
        case paramEdit_assign
        case paramEdit_select1
        case paramEdit_select2
        case paramEdit_select3
        case paramEdit_select4
        case paramEdit_bypass
        case paramEdit_compare
        
        // Zone 0x1D
        // Functions only - no LEDs or buttons
        case internal_footswitchRelay1
        case internal_footswitchRelay2
        case internal_click
        case internal_beep
        
    }
    
}

extension MIDI.HUI.Parameter {
    
    /// Convenience constructor.
    public init?(zone: Int,
                 port: Int)
    {
        
        guard let parameter = MIDI.HUI.kHUIZoneAndPortPairs
                .first(where: { $1.zone == zone && $1.port == port })?
                .key
        else {
            return nil
        }
        
        self = parameter
        
    }
    
    /// Convenience constructor.
    public init?(channelStrip: Int,
                 channelElement: MIDI.HUI.ChannelStripElement)
    {
        
        guard let parameter = MIDI.HUI.kHUIZoneAndPortPairs
                .first(where: { $1.zone == channelStrip && $1.port == channelElement.rawValue })?
                .key
        else {
            return nil
        }
        
        self = parameter
        
    }
    
}
