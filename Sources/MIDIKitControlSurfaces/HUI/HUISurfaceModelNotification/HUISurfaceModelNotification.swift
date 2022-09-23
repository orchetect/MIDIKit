//
//  HUISurfaceModelNotification.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// Atomic strongly-typed event abstraction representing each control and display element of a HUI control surface.
///
/// > This event can be used in either direction (to client surface or to host) but not all events are relevant.
/// >
/// > For example:
/// >
/// > - Both a host and client surface can send channel strip Solo state to each other. The host sends the state to the client surface, and the client surface updates its state and UI to reflect it. Then the user can interact with the client surface at any time to toggle the Solo button which sends the same message back to the host, causing the host to toggle the corresponding track Solo.
/// > - A host can send a time display change to a client surface, but a client surface cannot send any time display changes back to the host. It is a read-only display on the client surface and there is no way to interact with it.
public enum HUISurfaceModelNotification: Hashable {
    // MARK: Ping
    
    /// HUI ping event.
    case ping
    
    // MARK: Text Displays
    
    /// Large text display.
    ///
    /// - Parameters:
    ///   - top: String representing top row.
    ///   - bottom: String representing bottom row.
    case largeDisplay(
        top: HUILargeDisplayString,
        bottom: HUILargeDisplayString
    )
    
    /// Time display.
    ///
    /// - Parameters:
    ///   - timeString: String representing the full text read-out.
    case timeDisplay(timeString: HUITimeDisplayString)
    
    /// An LED changed near the time display.
    case timeDisplay(
        param: HUISwitch.TimeDisplay,
        state: Bool
    )
    
    /// Select Assign text display.
    ///
    /// - Parameters:
    ///   - text: text string
    case selectAssignDisplay(text: HUISmallDisplayString)
        
    // MARK: Channel Strips
    
    /// A channel strip-related element.
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
    case hotKey(param: HUISwitch.HotKey, state: Bool)
    
    /// Param Edit section.
    case paramEdit(ParamEditComponent)
    
    /// Function keys (to the right of the channel strips).
    case functionKey(param: HUISwitch.FunctionKey, state: Bool)
    
    /// Auto Enable section (to the right of the channel strips).
    case autoEnable(param: HUISwitch.AutoEnable, state: Bool)
    
    /// Auto Mode section (to the right of the channel strips).
    case autoMode(param: HUISwitch.AutoMode, state: Bool)
    
    /// Status/Group section (to the right of the channel strips).
    case statusAndGroup(param: HUISwitch.StatusAndGroup, state: Bool)
    
    /// Edit section (to the right of the channel strips).
    case edit(param: HUISwitch.Edit, state: Bool)
    
    /// Numeric entry pad.
    case numPad(param: HUISwitch.NumPad, state: Bool)
    
    /// Window functions.
    case window(param: HUISwitch.Window, state: Bool)
    
    /// Bank and channel navigation.
    case bankMove(param: HUISwitch.BankMove, state: Bool)
    
    /// Assign section (buttons to top left of channel strips).
    case assign(param: HUISwitch.Assign, state: Bool)
    
    /// Cursor Movement / Mode / Scrub / Shuttle.
    case cursor(param: HUISwitch.Cursor, state: Bool)
    
    /// Control Room section.
    case controlRoom(param: HUISwitch.ControlRoom, state: Bool)
    
    /// Transport section.
    case transport(param: HUISwitch.Transport, state: Bool)
    
    /// Footswitches and Sounds - no LEDs or buttons associated.
    case footswitchesAndSounds(param: HUISwitch.FootswitchesAndSounds, state: Bool)
    
    // MARK: Unhandled
    
    /// Undefined/unrecognized switch.
    case undefinedSwitch(
        zone: HUIZone,
        port: HUIPort,
        state: Bool
    )
}
