//
//  Constants.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

// MARK: - HUI System Constants

extension MIDI.HUI {
    
    public enum kMIDI {
        
        // MARK: System messages
        
        // Status 0x9 is normally channel voice note-on, but HUI hijacks it.
        public static let kPingFromHostMessage:    [MIDI.Byte] = [0x90, 0x00, 0x00]
        
        // Status 0x9 is normally channel voice note-on, but HUI hijacks it.
        public static let kPingReplyToHostMessage: [MIDI.Byte] = [0x90, 0x00, 0x7F]
        
        public static let kSystemResetMessage:     [MIDI.Byte] = [0xFF]
        
        public static let kSysExHeader:            [MIDI.Byte] = [0xF0, 0x00, 0x00, 0x66, 0x05, 0x00]
        
        public enum kDisplayType {
            /// 4-character channel name displays, and Select-Assign displays
            public static let smallByte:           MIDI.Byte   = 0x10
            /// Main time display (can be switched between modes, such as timecode, bars/beats, etc.)
            public static let timeDisplayByte:     MIDI.Byte   = 0x11
            /// Main 40x2 character display
            public static let largeByte:           MIDI.Byte   = 0x12
        }
        
        // Status 0xA is normally MIDI poly aftertouch, but HUI hijacks it.
        public static let kLevelMetersStatus:      MIDI.Byte   = 0xA0
        
        // MARK: Control events
        
        // Status 0xB is normally channel voice control change, but HUI hijacks it.
        // HUI only ever uses first channel, so the status byte will always be exactly 0xB0.
        // HUI also uses running status for back-to-back 0xB status messages.
        public static let kControlStatus:          MIDI.Byte   = 0xB0
        
        public enum kControlDataByte1 {
            public static let zoneSelectByte:      MIDI.Byte   = 0x0C
            public static let portOnOffByte:       MIDI.Byte   = 0x2C
        }
        
        public static let kVPotData1UpperNibble:   MIDI.Byte   = 0x10
        
        public static let kSysExStartByte:         MIDI.Byte   = 0xF0
        public static let kSysExEndByte:           MIDI.Byte   = 0xF7
        
    }
    
}

// MARK: - HUI Character Tables

extension MIDI.HUI {
    
    /// HUI Character & String Tables
    ///
    /// There are more values to this table - need to discover what they are.
    /// (Pro Tools uses index values upwards of 48, maybe beyond)
    enum kCharTables {
        
        static let timeDisplay = [
            "0",  "1",  "2",  "3",    // 0x00 ...
            "4",  "5",  "6",  "7",    //
            "8",  "9",  "A",  "B",    //
            "C",  "D",  "E",  "F",    //      ... 0x0F
            "0.", "1.", "2.", "3.",   // 0x10 ...
            "4.", "5.", "6.", "7.",   //
            "8.", "9.", "A.", "B.",   //
            "C.", "D.", "E.", "F.",   //      ... 0x1F
            " ",                      // 0x20 - this is a guess; I think it's an empty space, or an empty string
            "?",  "?",  "?",  "?",    // 0x21 ...
            "?",  "?",  "?",  "?",    //
            "?",  "?",  "?",  "?",    //
            "?",  "?",  "?",          // 0x2F - placeholders, not sure about these; put in question marks for now
            " ."                      // 0x30 - this is a guess; I think it's an empty space with a period
        ]
        
        static let largeDisplay = [
            "",   "",   "",   "",     // 0x00 ...
            "",   "",   "",   "",     //
            "",   "",   "",   "",     //
            "",   "",   "",   "",     //      ... 0x0F
            "11",   "12", "13", "14", // 0x10 ...
            "full", "r4", "r3", "r2", //
            "r1",    "♪", "°C", "°F", //
            "▼",     "▶︎",  "◀︎",  "▲", //      ... 0x1F
            " ",  "!",  "\"", "#",    // 0x20 ...
            "$",  "%",  "&",  "'",    //
            "(",  ")",  "*",  "+",    //
            ",",  "-",  ".",  "/",    //      ... 0x2F
            "0",  "1",  "2",  "3",    // 0x30 ...
            "4",  "5",  "6",  "7",    //
            "8",  "9",  ":",  ";",    //
            "<",  "=",  ">",  "?",    //      ... 0x3F
            "@",  "A",  "B",  "C",    // 0x40 ...
            "D",  "E",  "F",  "G",    //
            "H",  "I",  "J",  "K",    //
            "L",  "M",  "N",  "O",    //      ... 0x4F
            "P",  "Q",  "R",  "S",    // 0x50 ...
            "T",  "U",  "V",  "W",    //
            "X",  "Y",  "Z",  "[",    //
            "\\", "]",  "^",  "_",    //      ... 0x5F
            "`",  "a",  "b",  "c",    // 0x60 ...
            "d",  "e",  "f",  "g",    //
            "h",  "i",  "j",  "k",    //
            "l",  "m",  "n",  "o",    //      ... 0x6F
            "p",  "q",  "r",  "s",    // 0x70 ...
            "t",  "u",  "v",  "w",    //
            "x",  "y",  "z",  "{",    //
            "|",  "}",  "→",  "←"     //      ... 0x7F
        ]
        
        static let smallDisplay = [
            "ì", "↑", "→", "↓", "←", "¿", "à", "Ø", "ø", "ò", "ù", "Ň", "Ç", "ê", "É", "é", // 0x00 ... 0x0F
            "è", "Æ", "æ", "Å", "å", "Ä", "ä", "Ö", "ö", "Ü", "ü","°C","°F", "ß", "£", "¥", // 0x10 ... 0x1F
            " ", "!", "\"","#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", // 0x20 ... 0x2F
            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ":", ";", "<", "=", ">", "?", // 0x30 ... 0x3F
            "@", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", // 0x40 ... 0x4F
            "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\","]", "^", "_", // 0x50 ... 0x5F
            "`", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", // 0x60 ... 0x6F
            "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "{", "|", "}", "~", "░"  // 0x70 ... 0x7F
        ]
        
        static let vPotLEDMatrix = [
            "           ", "*          ", " *         ", "  *        ", // 0x00 ...
            "   *       ", "    *      ", "     *     ", "      *    ",
            "       *   ", "        *  ", "         * ", "          *",
            "           ", "           ", "           ", "           ",
            "           ", "******     ", " *****     ", "  ****     ",
            "   ***     ", "    **     ", "     *     ", "     **    ",
            "     ***   ", "     ****  ", "     ***** ", "     ******", //      ... 0x2B
            
            "           ", "           ", "           ", "           ", // (these might not be used)
            
            "           ", "*          ", "**         ", "***        ", // 0x30 ...
            "****       ", "*****      ", "******     ", "*******    ",
            "********   ", "*********  ", "********** ", "***********", //      ... 0x3B
            
            "           ", "           ", "           ", "           ", // (these might not be used)
            
            "           ", "     *     ", "    ***    ", "   *****   ", // 0x40 ...
            "  *******  ", " ********* ", "***********", "***********",
            "***********", "***********", "***********", "***********"  //      ... 0x4B
        ]
        
        // There is also a small LED under the encoder that can be turned on by adding 40 to v.
        
    }
    
}

// MARK: - HUI Zones and Ports tables

extension MIDI.HUI {
    
    public typealias ZoneAndPortPair = (zone: Int, port: Int)
    
    static let kHUIZoneAndPortPairs: [Parameter : ZoneAndPortPair] = [
        // Zones 0x00 - 0x07
        // Channel Strips
        .channel0_fader             : (0x00, 0x00),
        .channel0_select            : (0x00, 0x01),
        .channel0_mute              : (0x00, 0x02),
        .channel0_solo              : (0x00, 0x03),
        .channel0_auto              : (0x00, 0x04),
        .channel0_vSel              : (0x00, 0x05),
        .channel0_insert            : (0x00, 0x06),
        .channel0_rec               : (0x00, 0x07),
        
        .channel1_fader             : (0x01, 0x00),
        .channel1_select            : (0x01, 0x01),
        .channel1_mute              : (0x01, 0x02),
        .channel1_solo              : (0x01, 0x03),
        .channel1_auto              : (0x01, 0x04),
        .channel1_vSel              : (0x01, 0x05),
        .channel1_insert            : (0x01, 0x06),
        .channel1_rec               : (0x01, 0x07),
        
        .channel2_fader             : (0x02, 0x00),
        .channel2_select            : (0x02, 0x01),
        .channel2_mute              : (0x02, 0x02),
        .channel2_solo              : (0x02, 0x03),
        .channel2_auto              : (0x02, 0x04),
        .channel2_vSel              : (0x02, 0x05),
        .channel2_insert            : (0x02, 0x06),
        .channel2_rec               : (0x02, 0x07),
        
        .channel3_fader             : (0x03, 0x00),
        .channel3_select            : (0x03, 0x01),
        .channel3_mute              : (0x03, 0x02),
        .channel3_solo              : (0x03, 0x03),
        .channel3_auto              : (0x03, 0x04),
        .channel3_vSel              : (0x03, 0x05),
        .channel3_insert            : (0x03, 0x06),
        .channel3_rec               : (0x03, 0x07),
        
        .channel4_fader             : (0x04, 0x00),
        .channel4_select            : (0x04, 0x01),
        .channel4_mute              : (0x04, 0x02),
        .channel4_solo              : (0x04, 0x03),
        .channel4_auto              : (0x04, 0x04),
        .channel4_vSel              : (0x04, 0x05),
        .channel4_insert            : (0x04, 0x06),
        .channel4_rec               : (0x04, 0x07),
        
        .channel5_fader             : (0x05, 0x00),
        .channel5_select            : (0x05, 0x01),
        .channel5_mute              : (0x05, 0x02),
        .channel5_solo              : (0x05, 0x03),
        .channel5_auto              : (0x05, 0x04),
        .channel5_vSel              : (0x05, 0x05),
        .channel5_insert            : (0x05, 0x06),
        .channel5_rec               : (0x05, 0x07),
        
        .channel6_fader             : (0x06, 0x00),
        .channel6_select            : (0x06, 0x01),
        .channel6_mute              : (0x06, 0x02),
        .channel6_solo              : (0x06, 0x03),
        .channel6_auto              : (0x06, 0x04),
        .channel6_vSel              : (0x06, 0x05),
        .channel6_insert            : (0x06, 0x06),
        .channel6_rec               : (0x06, 0x07),
        
        .channel7_fader             : (0x07, 0x00),
        .channel7_select            : (0x07, 0x01),
        .channel7_mute              : (0x07, 0x02),
        .channel7_solo              : (0x07, 0x03),
        .channel7_auto              : (0x07, 0x04),
        .channel7_vSel              : (0x07, 0x05),
        .channel7_insert            : (0x07, 0x06),
        .channel7_rec               : (0x07, 0x07),
        
        // Zone 0x08
        // Keyboard Shortcuts
        .hotkey_ctrl                : (0x08, 0x00),
        .hotkey_shift               : (0x08, 0x01),
        .hotkey_editMode            : (0x08, 0x02),
        .hotkey_undo                : (0x08, 0x03),
        .hotkey_cmd                 : (0x08, 0x04),
        .hotkey_option              : (0x08, 0x05),
        .hotkey_editTool            : (0x08, 0x06),
        .hotkey_save                : (0x08, 0x07),
        
        // Zone 0x09
        // Window
        .window_mix                 : (0x09, 0x00),
        .window_edit                : (0x09, 0x01),
        .window_transport           : (0x09, 0x02),
        .window_memLoc              : (0x09, 0x03),
        .window_status              : (0x09, 0x04),
        .window_alt                 : (0x09, 0x05),
        
        // Zone 0x0A
        // Channel Selection (scroll/bank channels in view)
        .bankMove_ChannelLeft       : (0x0a, 0x00),
        .bankMove_BankLeft          : (0x0a, 0x01),
        .bankMove_ChannelRight      : (0x0a, 0x02),
        .bankMove_BankRight         : (0x0a, 0x03),
        
        // Zone 0x0B
        // Assign 1 (buttons to top left of channel strips)
        .assign_output              : (0x0b, 0x00),
        .assign_input               : (0x0b, 0x01),
        .assign_pan                 : (0x0b, 0x02),
        .assign_sendE               : (0x0b, 0x03),
        .assign_sendD               : (0x0b, 0x04),
        .assign_sendC               : (0x0b, 0x05),
        .assign_sendB               : (0x0b, 0x06),
        .assign_sendA               : (0x0b, 0x07),
        
        // Zone 0x0C
        // Assign 2 (buttons to top left of channel strips)
        .assign_assign              : (0x0c, 0x00),
        .assign_default             : (0x0c, 0x01),
        .assign_suspend             : (0x0c, 0x02),
        .assign_shift               : (0x0c, 0x03),
        .assign_mute                : (0x0c, 0x04),
        .assign_bypass              : (0x0c, 0x05),
        .assign_recordReadyAll      : (0x0c, 0x06),
        
        // Zone 0x0D
        // Cursor Movement / Mode / Scrub / Shuttle
        .cursor_down                : (0x0d, 0x00),
        .cursor_left                : (0x0d, 0x01),
        .cursor_mode                : (0x0d, 0x02),
        .cursor_right               : (0x0d, 0x03),
        .cursor_up                  : (0x0d, 0x04),
        .cursor_scrub               : (0x0d, 0x05),
        .cursor_shuttle             : (0x0d, 0x06),
        
        // Zone 0x0E
        // Transport Main
        .transport_talkback         : (0x0e, 0x00),
        .transport_rewind           : (0x0e, 0x01),
        .transport_fastFwd          : (0x0e, 0x02),
        .transport_stop             : (0x0e, 0x03),
        .transport_play             : (0x0e, 0x04),
        .transport_record           : (0x0e, 0x05),
        
        // Zone 0x0F
        // Transport continued
        .transport_rtz              : (0x0f, 0x00),
        .transport_end              : (0x0f, 0x01),
        .transport_online           : (0x0f, 0x02),
        .transport_loop             : (0x0f, 0x03),
        .transport_quickPunch       : (0x0f, 0x04),
        
        // Zone 0x10
        // Transport Punch
        .transport_punch_audition   : (0x10, 0x00),
        .transport_punch_pre        : (0x10, 0x01),
        .transport_punch_in         : (0x10, 0x02),
        .transport_punch_out        : (0x10, 0x03),
        .transport_punch_post       : (0x10, 0x04),
        
        // Zone 0x11
        // Control Room - Monitor Input
        .controlRoom_input3         : (0x11, 0x00),
        .controlRoom_input2         : (0x11, 0x01),
        .controlRoom_input1         : (0x11, 0x02),
        .controlRoom_mute           : (0x11, 0x03),
        .controlRoom_discrete       : (0x11, 0x04),
        
        // Zone 0x12
        // Control Room - Monitor Output
        .controlRoom_output3        : (0x12, 0x00),
        .controlRoom_output2        : (0x12, 0x01),
        .controlRoom_output1        : (0x12, 0x02),
        .controlRoom_dim            : (0x12, 0x03),
        .controlRoom_mono           : (0x12, 0x04),
        
        // Zone 0x13
        // Num Pad
        .numpad_0                   : (0x13, 0x00),
        .numpad_1                   : (0x13, 0x01),
        .numpad_4                   : (0x13, 0x02),
        .numpad_2                   : (0x13, 0x03),
        .numpad_5                   : (0x13, 0x04),
        .numpad_period              : (0x13, 0x05),
        .numpad_3                   : (0x13, 0x06),
        .numpad_6                   : (0x13, 0x07),
        
        // Zone 0x14
        // Num Pad
        .numpad_enter               : (0x14, 0x00),
        .numpad_plus                : (0x14, 0x01),
        
        // Zone 0x15
        // Num Pad
        .numpad_7                   : (0x15, 0x00),
        .numpad_8                   : (0x15, 0x01),
        .numpad_9                   : (0x15, 0x02),
        .numpad_minus               : (0x15, 0x03),
        .numpad_clr                 : (0x15, 0x04),
        .numpad_equals              : (0x15, 0x05),
        .numpad_forwardSlash        : (0x15, 0x06),
        .numpad_asterisk            : (0x15, 0x07),
        
        // Zone 0x16
        // Timecode LEDs (no buttons, LEDs only)
        .LED_timecode_timecode      : (0x16, 0x00),
        .LED_timecode_feet          : (0x16, 0x01),
        .LED_timecode_beats         : (0x16, 0x02),
        .LED_rudeSolo               : (0x16, 0x03),
        
        // Zone 0x17
        // Auto Enable (To the right of the channel strips)
        .autoEnable_plugin          : (0x17, 0x00),
        .autoEnable_pan             : (0x17, 0x01),
        .autoEnable_fader           : (0x17, 0x02),
        .autoEnable_sendMute        : (0x17, 0x03),
        .autoEnable_send            : (0x17, 0x04),
        .autoEnable_mute            : (0x17, 0x05),
        
        // Zone 0x18
        // Auto Mode (To the right of the channel strips)
        .autoMode_trim              : (0x18, 0x00),
        .autoMode_latch             : (0x18, 0x01),
        .autoMode_read              : (0x18, 0x02),
        .autoMode_off               : (0x18, 0x03),
        .autoMode_write             : (0x18, 0x04),
        .autoMode_touch             : (0x18, 0x05),
        
        // Zone 0x19
        // Status/Group (To the right of the channel strips)
        .statusGroup_phase          : (0x19, 0x00),
        .statusGroup_monitor        : (0x19, 0x01),
        .statusGroup_auto           : (0x19, 0x02),
        .statusGroup_suspend        : (0x19, 0x03),
        .statusGroup_create         : (0x19, 0x04),
        .statusGroup_group          : (0x19, 0x05),
        
        // Zone 0x1A
        // Edit (To the right of the channel strips)
        .edit_paste                 : (0x1a, 0x00),
        .edit_cut                   : (0x1a, 0x01),
        .edit_capture               : (0x1a, 0x02),
        .edit_delete                : (0x1a, 0x03),
        .edit_copy                  : (0x1a, 0x04),
        .edit_separate              : (0x1a, 0x05),
        
        // Zone 0x1B
        // Function Keys
        .functionKey_F1             : (0x1b, 0x00),
        .functionKey_F2             : (0x1b, 0x01),
        .functionKey_F3             : (0x1b, 0x02),
        .functionKey_F4             : (0x1b, 0x03),
        .functionKey_F5             : (0x1b, 0x04),
        .functionKey_F6             : (0x1b, 0x05),
        .functionKey_F7             : (0x1b, 0x06),
        .functionKey_F8_or_Esc      : (0x1b, 0x07),
        
        // Zone 0x1C
        // Parameter Edit  (Section at top right below the Large Display readout)
        .paramEdit_insertParam      : (0x1c, 0x00),
        .paramEdit_assign           : (0x1c, 0x01),
        .paramEdit_select1          : (0x1c, 0x02),
        .paramEdit_select2          : (0x1c, 0x03),
        .paramEdit_select3          : (0x1c, 0x04),
        .paramEdit_select4          : (0x1c, 0x05),
        .paramEdit_bypass           : (0x1c, 0x06),
        .paramEdit_compare          : (0x1c, 0x07),
        
        // Zone 0x1D
        // Functions only - no LEDs or buttons
        .internal_footswitchRelay1  : (0x1d, 0x00),
        .internal_footswitchRelay2  : (0x1d, 0x01),
        .internal_click             : (0x1d, 0x02),
        .internal_beep              : (0x1d, 0x03)
    ]
    
}

// MARK: - Channel Strip Element

extension MIDI.HUI {
    
    public enum ChannelStripElement: Int {
        
        case fader  = 0x00
        case select = 0x01
        case mute   = 0x02
        case solo   = 0x03
        case auto   = 0x04
        case vSel   = 0x05
        case insert = 0x06
        case rec    = 0x07
        
    }
    
}
