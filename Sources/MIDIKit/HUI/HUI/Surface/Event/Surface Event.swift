//
//  Surface Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.HUI.Surface {
    
    /// HUI Surface Event
    public enum Event: Hashable {
        
        // MARK: Ping
        
        /// HUI ping event
        case ping
        
        // MARK: Text Displays
        
        /// Large text display changed.
        /// - `top`: String representing top row.
        /// - `bottom`: String representing bottom row.
        case largeDisplay(top: String,
                          bottom: String)
        
        /// Time display changed.
        /// - `timeString`: String representing the full text read-out.
        case timeDisplay(timeString: String)
        
        /// An LED changed near the time display.
        case timeDisplay(param: MIDI.HUI.Parameter.TimeDisplay,
                         state: Bool)
        
        /// Select Assign readout text changed
        /// - `text`: text string
        case selectAssignText(text: String)
        
        // MARK: Channel Strips
        
        /// A channel strip-related element was changed.
        /// - `channel`: channel strip 0...7
        /// - `param`: enum describing what control was changed
        case channelStrip(channel: Int,
                          component: ChannelStripComponent)
        
        // MARK: Switches
        
        case hotKey(param: MIDI.HUI.Parameter.HotKey, state: Bool)
        
        case paramEdit(param: MIDI.HUI.Parameter.ParameterEdit, state: Bool)
        
        case functionKey(param: MIDI.HUI.Parameter.FunctionKey, state: Bool)
        
        case autoEnable(param: MIDI.HUI.Parameter.AutoEnable, state: Bool)
        
        case autoMode(param: MIDI.HUI.Parameter.AutoMode, state: Bool)
        
        case statusAndGroup(param: MIDI.HUI.Parameter.StatusAndGroup, state: Bool)
        
        case edit(param: MIDI.HUI.Parameter.Edit, state: Bool)
        
        case numPad(param: MIDI.HUI.Parameter.NumPad, state: Bool)
        
        case windowFunctions(param: MIDI.HUI.Parameter.WindowFunction, state: Bool)
        
        case bankMove(param: MIDI.HUI.Parameter.BankMove, state: Bool)
        
        case assign(param: MIDI.HUI.Parameter.Assign, state: Bool)
        
        case cursor(param: MIDI.HUI.Parameter.Cursor, state: Bool)
        
        case controlRoom(param: MIDI.HUI.Parameter.ControlRoom, state: Bool)
        
        case transport(param: MIDI.HUI.Parameter.Transport, state: Bool)
        
        case footswitchesAndSounds(param: MIDI.HUI.Parameter.FootswitchesAndSounds, state: Bool)
        
        // MARK: Unhandled
        
        /// Unhandled/unrecognized switch
        case unhandledSwitch(zone: MIDI.Byte, port: MIDI.UInt4, state: Bool)
        
    }

}
