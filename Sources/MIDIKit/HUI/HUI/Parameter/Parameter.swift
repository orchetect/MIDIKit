//
//  Parameter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.HUI {
    
    /// HUI Parameter
    public enum Parameter: Equatable, Hashable {
        
        case channel(MIDI.UInt4, ChannelParameter)
        case hotKey(HotKey)
        case window(WindowFunction)
        case bankMove(BankMove)
        case assign(Assign)
        case cursor(Cursor)
        case transport(Transport)
        case controlRoom(ControlRoom)
        case numPad(NumPad)
        case timeDisplay(TimeDisplay)
        case autoEnable(AutoEnable)
        case autoMode(AutoMode)
        case statusAndGroup(StatusAndGroup)
        case edit(Edit)
        case functionKey(FunctionKey)
        case paramEdit(ParameterEdit)
        case internalUse(InternalUse)
        
    }
    
}

extension MIDI.HUI.Parameter: CaseIterable {
    
    public typealias AllCases = [Self]
    
    public static var allCases: [MIDI.HUI.Parameter] = [
        
        // Zones 0x00 - 0x07
        // Channel Strips
        .channel(0, .faderTouched),
        .channel(0, .select),
        .channel(0, .mute),
        .channel(0, .solo),
        .channel(0, .auto),
        .channel(0, .vSel),
        .channel(0, .insert),
        .channel(0, .recordReady),
        
        .channel(1, .faderTouched),
        .channel(1, .select),
        .channel(1, .mute),
        .channel(1, .solo),
        .channel(1, .auto),
        .channel(1, .vSel),
        .channel(1, .insert),
        .channel(1, .recordReady),
        
        .channel(2, .faderTouched),
        .channel(2, .select),
        .channel(2, .mute),
        .channel(2, .solo),
        .channel(2, .auto),
        .channel(2, .vSel),
        .channel(2, .insert),
        .channel(2, .recordReady),
        
        .channel(3, .faderTouched),
        .channel(3, .select),
        .channel(3, .mute),
        .channel(3, .solo),
        .channel(3, .auto),
        .channel(3, .vSel),
        .channel(3, .insert),
        .channel(3, .recordReady),
        
        .channel(4, .faderTouched),
        .channel(4, .select),
        .channel(4, .mute),
        .channel(4, .solo),
        .channel(4, .auto),
        .channel(4, .vSel),
        .channel(4, .insert),
        .channel(4, .recordReady),
        
        .channel(5, .faderTouched),
        .channel(5, .select),
        .channel(5, .mute),
        .channel(5, .solo),
        .channel(5, .auto),
        .channel(5, .vSel),
        .channel(5, .insert),
        .channel(5, .recordReady),
        
        .channel(6, .faderTouched),
        .channel(6, .select),
        .channel(6, .mute),
        .channel(6, .solo),
        .channel(6, .auto),
        .channel(6, .vSel),
        .channel(6, .insert),
        .channel(6, .recordReady),
        
        .channel(7, .faderTouched),
        .channel(7, .select),
        .channel(7, .mute),
        .channel(7, .solo),
        .channel(7, .auto),
        .channel(7, .vSel),
        .channel(7, .insert),
        .channel(7, .recordReady),
        
        // Zone 0x08
        // Keyboard Shortcuts
        .hotKey(.ctrl),
        .hotKey(.shift),
        .hotKey(.editMode),
        .hotKey(.undo),
        .hotKey(.cmd),
        .hotKey(.option),
        .hotKey(.editTool),
        .hotKey(.save),
        
        // Zone 0x09
        // Window Functions
        .window(.mix),
        .window(.edit),
        .window(.transport),
        .window(.memLoc),
        .window(.status),
        .window(.alt),
        
        // Zone 0x0A
        // Channel Selection (scroll/bank channels in view)
        .bankMove(.channelLeft),
        .bankMove(.bankLeft),
        .bankMove(.channelRight),
        .bankMove(.bankRight),
        
        // Zone 0x0B
        // Assign 1 (buttons to top left of channel strips)
        .assign(.output),
        .assign(.input),
        .assign(.pan),
        .assign(.sendE),
        .assign(.sendD),
        .assign(.sendC),
        .assign(.sendB),
        .assign(.sendA),
        
        // Zone 0x0C
        // Assign 2 (buttons to top left of channel strips)
        .assign(.assign),
        .assign(.default),
        .assign(.suspend),
        .assign(.shift),
        .assign(.mute),
        .assign(.bypass),
        .assign(.recordReadyAll),
        
        // Zone 0x0D
        // Cursor Movement / Mode / Scrub / Shuttle
        .cursor(.down),
        .cursor(.left),
        .cursor(.mode),
        .cursor(.right),
        .cursor(.up),
        .cursor(.scrub),
        .cursor(.shuttle),
        
        // Zone 0x0E
        // Transport Main
        .transport(.talkback),
        .transport(.rewind),
        .transport(.fastFwd),
        .transport(.stop),
        .transport(.play),
        .transport(.record),
        
        // Zone 0x0F
        // Transport continued
        .transport(.rtz),
        .transport(.end),
        .transport(.online),
        .transport(.loop),
        .transport(.quickPunch),
        
        // Zone 0x10
        // Transport Punch
        .transport(.punch_audition),
        .transport(.punch_pre),
        .transport(.punch_in),
        .transport(.punch_out),
        .transport(.punch_post),
        
        // Zone 0x11
        // Control Room - Monitor Input
        .controlRoom(.input3),
        .controlRoom(.input2),
        .controlRoom(.input1),
        .controlRoom(.mute),
        .controlRoom(.discreteInput1to1),
        
        // Zone 0x12
        // Control Room - Monitor Output
        .controlRoom(.output3),
        .controlRoom(.output2),
        .controlRoom(.output1),
        .controlRoom(.dim),
        .controlRoom(.mono),
        
        // Zone 0x13
        // Num Pad
        .numPad(.num0),
        .numPad(.num1),
        .numPad(.num4),
        .numPad(.num2),
        .numPad(.num5),
        .numPad(.period),
        .numPad(.num3),
        .numPad(.num6),
        
        // Zone 0x14
        // Num Pad
        .numPad(.enter),
        .numPad(.plus),
        
        // Zone 0x15
        // Num Pad
        .numPad(.num7),
        .numPad(.num8),
        .numPad(.num9),
        .numPad(.minus),
        .numPad(.clr),
        .numPad(.equals),
        .numPad(.forwardSlash),
        .numPad(.asterisk),
        
        // Zone 0x16
        // Timecode LEDs (no buttons, LEDs only)
        .timeDisplay(.timecode),
        .timeDisplay(.feet),
        .timeDisplay(.beats),
        .timeDisplay(.rudeSolo),
        
        // Zone 0x17
        // Auto Enable (To the right of the channel strips)
        .autoEnable(.plugin),
        .autoEnable(.pan),
        .autoEnable(.fader),
        .autoEnable(.sendMute),
        .autoEnable(.send),
        .autoEnable(.mute),
        
        // Zone 0x18
        // Auto Mode (To the right of the channel strips)
        .autoMode(.trim),
        .autoMode(.latch),
        .autoMode(.read),
        .autoMode(.off),
        .autoMode(.write),
        .autoMode(.touch),
        
        // Zone 0x19
        // Status/Group (To the right of the channel strips)
        .statusAndGroup(.phase),
        .statusAndGroup(.monitor),
        .statusAndGroup(.auto),
        .statusAndGroup(.suspend),
        .statusAndGroup(.create),
        .statusAndGroup(.group),
        
        // Zone 0x1A
        // Edit (To the right of the channel strips)
        .edit(.paste),
        .edit(.cut),
        .edit(.capture),
        .edit(.delete),
        .edit(.copy),
        .edit(.separate),
        
        // Zone 0x1B
        // Function Keys
        .functionKey(.f1),
        .functionKey(.f2),
        .functionKey(.f3),
        .functionKey(.f4),
        .functionKey(.f5),
        .functionKey(.f6),
        .functionKey(.f7),
        .functionKey(.f8_or_Esc),
        
        // Zone 0x1C
        // Parameter Edit  (Section at top right below the Large Display readout)
        .paramEdit(.insertOrParam),
        .paramEdit(.assign),
        .paramEdit(.select1),
        .paramEdit(.select2),
        .paramEdit(.select3),
        .paramEdit(.select4),
        .paramEdit(.bypass),
        .paramEdit(.compare),
        
        // Zone 0x1D
        // Functions only - no LEDs or buttons
        .internalUse(.footswitchRelay1),
        .internalUse(.footswitchRelay2),
        .internalUse(.click),
        .internalUse(.beep)
        
    ]
    
}

extension MIDI.HUI.Parameter: MIDIHUIParameterProtocol {
    
    @inlinable
    public var zoneAndPort: MIDI.HUI.ZoneAndPortPair {
        
        switch self {
        case .channel(let channel, let channelParameter):
            return (channel.asUInt8, channelParameter.port)

        case .hotKey(let param):
            return param.zoneAndPort

        case .window(let param):
            return param.zoneAndPort

        case .bankMove(let param):
            return param.zoneAndPort

        case .assign(let param):
            return param.zoneAndPort

        case .cursor(let param):
            return param.zoneAndPort

        case .transport(let param):
            return param.zoneAndPort

        case .controlRoom(let param):
            return param.zoneAndPort

        case .numPad(let param):
            return param.zoneAndPort

        case .timeDisplay(let param):
            return param.zoneAndPort

        case .autoEnable(let param):
            return param.zoneAndPort

        case .autoMode(let param):
            return param.zoneAndPort

        case .statusAndGroup(let param):
            return param.zoneAndPort

        case .edit(let param):
            return param.zoneAndPort

        case .functionKey(let param):
            return param.zoneAndPort

        case .paramEdit(let param):
            return param.zoneAndPort

        case .internalUse(let param):
            return param.zoneAndPort
        }
        
    }
    
}

extension MIDI.HUI.Parameter {
    
    /// Convenience constructor.
    public init?(zone: MIDI.Byte,
                 port: MIDI.UInt4)
    {
        
        guard let parameter = MIDI.HUI.Parameter.allCases
                .first(where: { $0.zoneAndPort.zone == zone
                    && $0.zoneAndPort.port == port
                })
        else { return nil }
        
        self = parameter
        
    }
    
    /// Convenience constructor.
    public init(channelStrip: MIDI.UInt4,
                component: MIDI.HUI.Parameter.ChannelParameter)
    {
        
        self = .channel(channelStrip, component)
        
    }
    
}
