//
//  HUIParameter.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// HUI Parameter
public enum HUIParameter: Equatable, Hashable {
    case channelStrip(Int, ChannelParameter)
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
    case parameterEdit(ParameterEdit)
    case footswitchesAndSounds(FootswitchesAndSounds)
}

extension HUIParameter: CaseIterable {
    public typealias AllCases = [Self]
    
    public static var allCases: [HUIParameter] = [
        // Zones 0x00 - 0x07
        // Channel Strips
        .channelStrip(0, .faderTouched),
        .channelStrip(0, .select),
        .channelStrip(0, .mute),
        .channelStrip(0, .solo),
        .channelStrip(0, .auto),
        .channelStrip(0, .vPotSelect),
        .channelStrip(0, .insert),
        .channelStrip(0, .recordReady),
        
        .channelStrip(1, .faderTouched),
        .channelStrip(1, .select),
        .channelStrip(1, .mute),
        .channelStrip(1, .solo),
        .channelStrip(1, .auto),
        .channelStrip(1, .vPotSelect),
        .channelStrip(1, .insert),
        .channelStrip(1, .recordReady),
        
        .channelStrip(2, .faderTouched),
        .channelStrip(2, .select),
        .channelStrip(2, .mute),
        .channelStrip(2, .solo),
        .channelStrip(2, .auto),
        .channelStrip(2, .vPotSelect),
        .channelStrip(2, .insert),
        .channelStrip(2, .recordReady),
        
        .channelStrip(3, .faderTouched),
        .channelStrip(3, .select),
        .channelStrip(3, .mute),
        .channelStrip(3, .solo),
        .channelStrip(3, .auto),
        .channelStrip(3, .vPotSelect),
        .channelStrip(3, .insert),
        .channelStrip(3, .recordReady),
        
        .channelStrip(4, .faderTouched),
        .channelStrip(4, .select),
        .channelStrip(4, .mute),
        .channelStrip(4, .solo),
        .channelStrip(4, .auto),
        .channelStrip(4, .vPotSelect),
        .channelStrip(4, .insert),
        .channelStrip(4, .recordReady),
        
        .channelStrip(5, .faderTouched),
        .channelStrip(5, .select),
        .channelStrip(5, .mute),
        .channelStrip(5, .solo),
        .channelStrip(5, .auto),
        .channelStrip(5, .vPotSelect),
        .channelStrip(5, .insert),
        .channelStrip(5, .recordReady),
        
        .channelStrip(6, .faderTouched),
        .channelStrip(6, .select),
        .channelStrip(6, .mute),
        .channelStrip(6, .solo),
        .channelStrip(6, .auto),
        .channelStrip(6, .vPotSelect),
        .channelStrip(6, .insert),
        .channelStrip(6, .recordReady),
        
        .channelStrip(7, .faderTouched),
        .channelStrip(7, .select),
        .channelStrip(7, .mute),
        .channelStrip(7, .solo),
        .channelStrip(7, .auto),
        .channelStrip(7, .vPotSelect),
        .channelStrip(7, .insert),
        .channelStrip(7, .recordReady),
        
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
        .transport(.punchAudition),
        .transport(.punchPre),
        .transport(.punchIn),
        .transport(.punchOut),
        .transport(.punchPost),
        
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
        .functionKey(.f8OrEsc),
        
        // Zone 0x1C
        // Parameter Edit  (Section at top right below the Large Display readout)
        .parameterEdit(.insertOrParam),
        .parameterEdit(.assign),
        .parameterEdit(.param1Select),
        .parameterEdit(.param2Select),
        .parameterEdit(.param3Select),
        .parameterEdit(.param4Select),
        .parameterEdit(.bypass),
        .parameterEdit(.compare),
        
        // Zone 0x1D
        // Functions only - no LEDs or buttons
        .footswitchesAndSounds(.footswitchRelay1),
        .footswitchesAndSounds(.footswitchRelay2),
        .footswitchesAndSounds(.click),
        .footswitchesAndSounds(.beep)
    ]
}

extension HUIParameter: HUIParameterProtocol {
    public var zoneAndPort: HUIZoneAndPort {
        switch self {
        case let .channelStrip(channelStrip, channelParameter):
            return (UInt8(exactly: channelStrip) ?? 0, channelParameter.port)

        case let .hotKey(param):
            return param.zoneAndPort

        case let .window(param):
            return param.zoneAndPort

        case let .bankMove(param):
            return param.zoneAndPort

        case let .assign(param):
            return param.zoneAndPort

        case let .cursor(param):
            return param.zoneAndPort

        case let .transport(param):
            return param.zoneAndPort

        case let .controlRoom(param):
            return param.zoneAndPort

        case let .numPad(param):
            return param.zoneAndPort

        case let .timeDisplay(param):
            return param.zoneAndPort

        case let .autoEnable(param):
            return param.zoneAndPort

        case let .autoMode(param):
            return param.zoneAndPort

        case let .statusAndGroup(param):
            return param.zoneAndPort

        case let .edit(param):
            return param.zoneAndPort

        case let .functionKey(param):
            return param.zoneAndPort

        case let .parameterEdit(param):
            return param.zoneAndPort

        case let .footswitchesAndSounds(param):
            return param.zoneAndPort
        }
    }
}

extension HUIParameter: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .channelStrip(channelStrip, channelParameter):
            return "channelStrip(\(channelStrip), \(channelParameter))"

        case let .hotKey(param):
            return "hotKey(\(param))"

        case let .window(param):
            return "window(\(param))"

        case let .bankMove(param):
            return "bankMove(\(param))"

        case let .assign(param):
            return "assign(\(param))"

        case let .cursor(param):
            return "cursor(\(param))"

        case let .transport(param):
            return "transport(\(param))"

        case let .controlRoom(param):
            return "controlRoom(\(param))"

        case let .numPad(param):
            return "numPad(\(param))"

        case let .timeDisplay(param):
            return "timeDisplay(\(param))"

        case let .autoEnable(param):
            return "autoEnable(\(param))"

        case let .autoMode(param):
            return "autoMode(\(param))"

        case let .statusAndGroup(param):
            return "statusAndGroup(\(param))"

        case let .edit(param):
            return "edit(\(param))"

        case let .functionKey(param):
            return "functionKey(\(param))"

        case let .parameterEdit(param):
            return "parameterEdit(\(param))"

        case let .footswitchesAndSounds(param):
            return "footswitchesAndSounds(\(param))"
        }
    }
}

extension HUIParameter {
    /// Construct from a HUI zone and port pair.
    /// Returns `nil` if the pair is undefined.
    public init?(
        zone: Byte,
        port: UInt4
    ) {
        guard let parameter = HUIParameter.allCases
            .first(where: {
                $0.zoneAndPort.zone == zone
                    && $0.zoneAndPort.port == port
            })
        else { return nil }
        
        self = parameter
    }
}
