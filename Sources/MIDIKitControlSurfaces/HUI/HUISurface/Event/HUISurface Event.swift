//
//  HUISurface Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUISurface {
    /// HUI Surface Event.
    /// Atomic abstractions representing each control and display element of a HUI control surface.
    public enum Event: Hashable {
        // MARK: Ping
        
        /// HUI ping event
        case ping
        
        // MARK: Text Displays
        
        /// Large text display changed.
        ///
        /// - Parameters:
        ///   - top: String representing top row.
        ///   - bottom: String representing bottom row.
        case largeDisplay(
            top: String,
            bottom: String
        )
        
        /// Time display changed.
        ///
        /// - Parameters:
        ///   - timeString: String representing the full text read-out.
        case timeDisplay(timeString: String)
        
        /// An LED changed near the time display.
        case timeDisplayStatus(
            param: HUIParameter.TimeDisplay,
            state: Bool
        )
        
        /// Select Assign readout text changed.
        ///
        /// - Parameters:
        ///   - text: text string
        case selectAssignText(text: String)
        
        // MARK: Channel Strips
        
        /// A channel strip-related element was changed.
        ///
        /// - Parameters:
        ///   - channel: channel strip `0 ... 7`
        ///   - param: enum describing what control was changed
        case channelStrip(
            channel: Int,
            ChannelStripComponent
        )
        
        // MARK: Switches
        
        case hotKey(param: HUIParameter.HotKey, state: Bool)
        
        case paramEdit(ParamEditComponent)
        
        case functionKey(param: HUIParameter.FunctionKey, state: Bool)
        
        case autoEnable(param: HUIParameter.AutoEnable, state: Bool)
        
        case autoMode(param: HUIParameter.AutoMode, state: Bool)
        
        case statusAndGroup(param: HUIParameter.StatusAndGroup, state: Bool)
        
        case edit(param: HUIParameter.Edit, state: Bool)
        
        case numPad(param: HUIParameter.NumPad, state: Bool)
        
        case windowFunctions(param: HUIParameter.WindowFunction, state: Bool)
        
        case bankMove(param: HUIParameter.BankMove, state: Bool)
        
        case assign(param: HUIParameter.Assign, state: Bool)
        
        case cursor(param: HUIParameter.Cursor, state: Bool)
        
        case controlRoom(param: HUIParameter.ControlRoom, state: Bool)
        
        case transport(param: HUIParameter.Transport, state: Bool)
        
        case footswitchesAndSounds(param: HUIParameter.FootswitchesAndSounds, state: Bool)
        
        // MARK: Unhandled
        
        /// Unhandled/unrecognized switch.
        case unhandledSwitch(
            zone: UInt8,
            port: UInt4,
            state: Bool
        )
    }
}
