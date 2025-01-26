//
//  HUISwitch.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// HUI Switch.
/// Identifiers for all possible HUI toggle/boolean controls: Buttons, LEDs, and auxiliary
/// capabilities like external footswitch toggles and beep sounds. These are all collectively
/// referred to as HUI switches.
///
/// > Note: Not all switches are relevant for both host and surface. Some only apply to one or the
/// > other. But most apply to both.
/// >
/// > - An LED has a state of on (`true`) and off (`false`).
/// > - When a user engages a switch on a HUI control surface (ie: presses a button or touches a
/// >   fader cap) it has a state of pressed/touched (`true`) and unpressed/untouched (`false`).
/// >   Which means if a user momentarily pushes and releases a button it will result in two
/// >   immediately successive `true` then `false` state messages. If a user presses and holds a
/// >   button, it will result in a `true` state message upon press and then the `false` state
/// >   message only upon button release.
public enum HUISwitch {
    /// Channel strip component.
    case channelStrip(UInt4, ChannelStrip)
    
    /// Keyboard hotkeys.
    case hotKey(HotKey)
    
    /// Window functions.
    case window(Window)
    
    /// Bank and channel navigation.
    case bankMove(BankMove)
    
    /// Assign section (buttons to top left of channel strips).
    case assign(Assign)
    
    /// Cursor Movement / Mode / Scrub / Shuttle.
    case cursor(Cursor)
    
    /// Transport section.
    case transport(Transport)
    
    /// Control Room section.
    case controlRoom(ControlRoom)
    
    /// Numeric entry pad.
    case numPad(NumPad)
    
    /// Time display.
    case timeDisplayStatus(TimeDisplayStatus)
    
    /// Auto Enable section (to the right of the channel strips).
    case autoEnable(AutoEnable)
    
    /// Auto Mode section (to the right of the channel strips).
    case autoMode(AutoMode)
    
    /// Status/Group section (to the right of the channel strips).
    case statusAndGroup(StatusAndGroup)
    
    /// Edit section (to the right of the channel strips).
    case edit(Edit)
    
    /// Function keys (to the right of the channel strips).
    case functionKey(FunctionKey)
    
    /// Param Edit section.
    case paramEdit(ParameterEdit)
    
    /// Footswitches and Sounds - no LEDs or buttons associated.
    case footswitchesAndSounds(FootswitchesAndSounds)
    
    /// Undefined HUI switch.
    case undefined(zone: HUIZone, port: HUIPort)
}

extension HUISwitch: Equatable { }

extension HUISwitch: Hashable { }

extension HUISwitch: Sendable { }

extension HUISwitch: CaseIterable {
    public typealias AllCases = [Self]
    
    public static let allCases: [HUISwitch] = [
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
        .timeDisplayStatus(.timecode),
        .timeDisplayStatus(.feet),
        .timeDisplayStatus(.beats),
        .timeDisplayStatus(.rudeSolo),
        
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
        .paramEdit(.insertOrParam),
        .paramEdit(.assign),
        .paramEdit(.param1Select),
        .paramEdit(.param2Select),
        .paramEdit(.param3Select),
        .paramEdit(.param4Select),
        .paramEdit(.bypass),
        .paramEdit(.compare),
        
        // Zone 0x1D
        // Functions only - no LEDs or buttons
        .footswitchesAndSounds(.footswitchRelay1),
        .footswitchesAndSounds(.footswitchRelay2),
        .footswitchesAndSounds(.click),
        .footswitchesAndSounds(.beep)
    ]
}

extension HUISwitch: HUISwitchProtocol {
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

        case let .timeDisplayStatus(param):
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

        case let .paramEdit(param):
            return param.zoneAndPort

        case let .footswitchesAndSounds(param):
            return param.zoneAndPort
            
        case let .undefined(zone: zone, port: port):
            return (zone: zone, port: port)
        }
    }
}

extension HUISwitch: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .channelStrip(channelStrip, param):
            return "channelStrip(\(channelStrip), \(param))"

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

        case let .timeDisplayStatus(param):
            return "timeDisplayStatus(\(param))"

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

        case let .paramEdit(param):
            return "paramEdit(\(param))"

        case let .footswitchesAndSounds(param):
            return "footswitchesAndSounds(\(param))"
            
        case let .undefined(zone: zone, port: port):
            return "undefined(zone: \(zone), port: \(port))"
        }
    }
}

extension HUISwitch {
    /// Initialize from a HUI zone and port pair.
    public init(
        zone: HUIZone,
        port: HUIPort
    ) {
        if let parameter = HUISwitch.allCases.first(where: {
            $0.zoneAndPort.zone == zone
                && $0.zoneAndPort.port == port
        }) {
            self = parameter
        } else {
            self = .undefined(zone: zone, port: port)
        }
    }
}
