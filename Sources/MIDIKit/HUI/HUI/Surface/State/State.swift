//
//  State.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.HUI.Surface {
    
    /// HUI Surface State.
    ///
    /// Represents state of an entire HUI surface (all controls, parameters, etc.)
    public struct State: Equatable, Hashable {
        
        public internal(set)var channels: [ChannelStrip] = []
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
        public internal(set)var internalUse = InternalUse()
        
        public init() {
            
            // populate arrays that hold unique class instances
            channels.removeAll()
            for _ in 0...7 {
                channels.append(ChannelStrip())
            }
            
        }
        
    }
    
}

extension MIDI.HUI.Surface.State.ChannelStrip {
    
    /// Enum describing a discrete component of a HUI channel strip
    public enum ComponentValue: Equatable, Hashable {
        
        case levelMeter(side: MIDI.HUI.Surface.State.StereoLevelMeter.Side, level: Int)
        case recordReady(Bool)
        case insert(Bool)
        case vPotSelect(Bool)
        case vPot(Int)
        case auto(Bool)
        case solo(Bool)
        case mute(Bool)
        case textDisplay(String)
        case select(Bool)
        case faderTouched(Bool)
        case faderLevel(Int)
        
    }
    
}

extension Array where Element == MIDI.HUI.Surface.State.ChannelStrip {
    
    public internal(set) subscript(_ idx: MIDI.UInt4) -> Element {
        get {
            self[idx.asInt]
        }
        set {
            self[idx.asInt] = newValue
        }
    }
    
}
