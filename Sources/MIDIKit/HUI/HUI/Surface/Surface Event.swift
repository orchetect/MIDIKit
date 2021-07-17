//
//  Surface Event.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.HUI.Surface {
    
    /// HUI Surface Event
    public enum Event: Hashable {
        
        /// Large text display changed.
        /// - `top`: String representing top row.
        /// - `bottom`: String representing bottom row.
        case largeDisplay(top: String, bottom: String)
        
        /// Time display changed.
        /// - `timeString`: String representing the full text read-out.
        case timeDisplay(timeString: String)
        
        /// An LED changed near the time display.
        case timeDisplay(param: MIDI.HUI.Parameter, state: Bool)
        
        /// Select Assign readout text changed
        /// - `text`: text string
        case selectAssignText(text: String)
        
        /// A channel strip-related element was changed.
        /// - `channel`: channel strip 0-7
        /// - `param`: enum describing what control was changed
        case channelStrip(channel: Int, param: MIDI.HUI.ChannelStripComponent)
        
        // switches
        
        case hotKey(param: MIDI.HUI.Parameter, state: Bool)
        case windowFunctions(param: MIDI.HUI.Parameter, state: Bool)
        case bankMove(param: MIDI.HUI.Parameter, state: Bool)
        case assign(param: MIDI.HUI.Parameter, state: Bool)
        case cursor(param: MIDI.HUI.Parameter, state: Bool)
        case transport(param: MIDI.HUI.Parameter, state: Bool)
        case controlRoom(param: MIDI.HUI.Parameter, state: Bool)
        
        /// Switch state was changed.
        /// - `switch`: `Parameter` describing the switch that was changed
        /// - `state`: on (true) or off (false)
        case unhandledSwitch(switchName: MIDI.HUI.Parameter, state: Bool)
        
    }

}
