//
//  HUIEvent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// Atomic abstractions representing each control and display element of a HUI control surface.
public enum HUIEvent: Hashable {
    // MARK: Ping
    
    /// HUI ping event.
    case ping
    
    // MARK: Text Displays
    
    /// Large text display changed.
    ///
    /// - Parameters:
    ///   - top: String representing top row.
    ///   - bottom: String representing bottom row.
    case largeDisplay(
        top: HUILargeDisplayString,
        bottom: HUILargeDisplayString
    )
    
    /// Time display changed.
    ///
    /// - Parameters:
    ///   - timeString: String representing the full text read-out.
    case timeDisplay(timeString: HUITimeDisplayString)
    
    /// An LED changed near the time display.
    case timeDisplayStatus(
        param: HUIParameter.TimeDisplay,
        state: Bool
    )
    
    /// Select Assign readout text changed.
    ///
    /// - Parameters:
    ///   - text: text string
    case selectAssignText(text: HUISmallDisplayString)
        
    // MARK: Channel Strips
    
    /// A channel strip-related element was changed.
    ///
    /// - Parameters:
    ///   - channel: channel strip `0 ... 7`
    ///   - param: enum describing what control was changed
    case channelStrip(
        channel: UInt4,
        ChannelStripComponent
    )
    
    // MARK: Switches
    
    /// Keyboard hotkeys.
    case hotKey(param: HUIParameter.HotKey, state: Bool)
    
    /// Param Edit section.
    case paramEdit(ParamEditComponent)
    
    /// Function keys (to the right of the channel strips).
    case functionKey(param: HUIParameter.FunctionKey, state: Bool)
    
    /// Auto Enable section (to the right of the channel strips).
    case autoEnable(param: HUIParameter.AutoEnable, state: Bool)
    
    /// Auto Mode section (to the right of the channel strips).
    case autoMode(param: HUIParameter.AutoMode, state: Bool)
    
    /// Status/Group section (to the right of the channel strips).
    case statusAndGroup(param: HUIParameter.StatusAndGroup, state: Bool)
    
    /// Edit section (to the right of the channel strips).
    case edit(param: HUIParameter.Edit, state: Bool)
    
    /// Numeric entry pad.
    case numPad(param: HUIParameter.NumPad, state: Bool)
    
    /// Window functions.
    case windowFunctions(param: HUIParameter.WindowFunction, state: Bool)
    
    /// Bank and channel navigation.
    case bankMove(param: HUIParameter.BankMove, state: Bool)
    
    /// Assign (buttons to top left of channel strips).
    case assign(param: HUIParameter.Assign, state: Bool)
    
    /// Cursor Movement / Mode / Scrub / Shuttle.
    case cursor(param: HUIParameter.Cursor, state: Bool)
    
    /// Control Room section.
    case controlRoom(param: HUIParameter.ControlRoom, state: Bool)
    
    /// Transport section.
    case transport(param: HUIParameter.Transport, state: Bool)
    
    /// Footswitches and Sounds - no LEDs or buttons associated.
    case footswitchesAndSounds(param: HUIParameter.FootswitchesAndSounds, state: Bool)
    
    // MARK: Unhandled
    
    /// Unhandled/unrecognized switch.
    case unhandledSwitch(
        zone: HUIZone,
        port: HUIPort,
        state: Bool
    )
}
