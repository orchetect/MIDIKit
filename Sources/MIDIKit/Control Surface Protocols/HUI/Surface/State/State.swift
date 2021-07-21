//
//  State.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.HUI.Surface {
    
    /// HUI Surface State.
    ///
    /// Represents state of an entire HUI surface (all controls, parameters, etc.)
    public struct State: Equatable, Hashable {
        
        /// Channel strips. (0...7)
        public internal(set)var channelStrips: [ChannelStrip] = []
        
        public internal(set)var timeDisplay = TimeDisplay()
        public internal(set)var largeDisplay = LargeDisplay()
        public internal(set)var transport = Transport()
        public internal(set)var hotKeys = HotKeys()
        public internal(set)var windowFunctions = WindowFunctions()
        public internal(set)var bankMove = BankMove()
        public internal(set)var assign = Assign()
        public internal(set)var cursor = Cursor()
        public internal(set)var controlRoom = ControlRoom()
        public internal(set)var numPad = NumPad()
        public internal(set)var autoEnable = AutoEnable()
        public internal(set)var autoMode = AutoMode()
        public internal(set)var statusAndGroup = StatusAndGroup()
        public internal(set)var edit = Edit()
        public internal(set)var functionKey = FunctionKey()
        public internal(set)var parameterEdit = ParameterEdit()
        public internal(set)var footswitchesAndSounds = FootswitchesAndSounds()
        
        public init() {
            
            // populate arrays that hold unique class instances
            channelStrips.removeAll()
            for _ in 0...7 {
                channelStrips.append(ChannelStrip())
            }
            
        }
        
    }
    
}
