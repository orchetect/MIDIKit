//
//  State.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.HUI.Surface {
    
    /// HUI Surface State.
    ///
    /// Represents state of an entire HUI surface (all controls, parameters, etc.)
    public struct State: Hashable {
        
        public internal(set)var channels: [ChannelStrip] = []
        public internal(set)var timeDisplay = TimeDisplay()
        public internal(set)var largeDisplay = LargeDisplay()
        public internal(set)var transport = Transport()
        public internal(set)var hotKeys = Hotkeys()
        public internal(set)var windowFunctions = WindowFunctions()
        public internal(set)var bankMove = BankMove()
        public internal(set)var assign = Assign()
        public internal(set)var cursor = Cursor()
        public internal(set)var controlRoom = ControlRoom()
        
        public init() {
            
            // populate arrays that hold unique class instances
            channels.removeAll()
            for _ in 0...7 {
                channels.append(ChannelStrip())
            }
            
        }
        
    }
    
}

extension MIDI.HUI {
    
    /// Enum describing a discrete component of a HUI channel strip
    public enum ChannelStripComponent: Hashable {
        
        case levelMeter(side: LevelMetersSide, level: Int)
        case recordReady(Bool)
        case insert(Bool)
        case vPotSelect(Bool)
        case vPot(Int)
        case auto(Bool)
        case solo(Bool)
        case mute(Bool)
        case textDisplay(String)
        case select(Bool)
        //case faderTouch(Bool) // ***** may not need this
        case faderLevel(Int)
        
    }
    
    /// Enum describing the side of a stereo level meter
    public enum LevelMetersSide: Int {
        
        case left = 0
        case right = 1
        
    }
    
}

extension MIDI.HUI.Surface.State {
    
    /// Abstraction subclass representing a single HUI channel strip and its components
    public struct ChannelStrip: Hashable {
        
        public var levelMeter = StereoLevelMeter()
        
        public var recordReady = false
        public var insert = false
        
        public var vPotSelect = false
        public var vPotLevel: Int = 0
        
        public var auto = false // (automation)
        public var solo = false
        public var mute = false
        
        public var textDisplayString: String = "    " // "small display"
        
        public var select = false
        
        public var fader = Fader()
        
    }
    
    /// Abstraction subclass representing the state/values of a HUI channel strip fader
    public struct Fader: Hashable {
        
        public var level: Int = 0
        public var touched: Bool = false
        
        // basic info
        
        /// Constant: minimum `level` value
        public static let levelMin: Int = 0
        
        /// Constant: maximum `level` value
        public static let levelMax: Int = 0x3fff // 16383
        
    }
    
    /// Abstraction subclass representing the state/values of a stereo HUI level meter
    public struct StereoLevelMeter: Hashable {
        
        public var left: Int = 0
        public var right: Int = 0
        
        // basic info
        public static let levelMin: Int = 0
        public static let levelMax: Int = 12
        
    }
    
}


// MARK: HUI Additional Abstraction Classes

extension MIDI.HUI.Surface.State {
    
    // MARK: HUI Time Display
    
    /// Abstraction subclass
    public struct TimeDisplay: Hashable {
        
        /// Returns the individual string components that make up the full time display `stringValue`
        public var components = [String](repeating: "", count: 8)
        
        // LEDs
        public var timecode = false
        public var feet = false
        public var beats = false
        
        public var rudeSolo = false
        
        /// Returns the full time display string
        public var stringValue: String {
            components.reduce("", +)
        }
        
        // /// Returns the 2-digit hours segment of time display string
        // public var hoursString: String {
        //     return components[0] + components[1]
        // }
        //
        // /// Returns the 2-digit minutes segment of time display string
        // public var minutesString: String {
        //     return components[2] + components[3]
        // }
        //
        // /// Returns the 2-digit seconds segment of time display string
        // public var secondsString: String {
        //     return components[4] + components[5]
        // }
        //
        // /// Returns the 2-digit frames segment of time display string
        // public var framesString: String {
        //     return components[6] + components[7]
        // }
        
    }
    
    
    // MARK: HUI Large Display
    
    /// Abstraction subclass
    public struct LargeDisplay: Hashable {
        
        /// Returns the individual string components that make up the large display contents
        var components = [String](repeating: "", count: 8)
        
        /// Returns the full concatenated top string
        public var topStringValue: String {
            components[0...3].reduce("", +)
        }
        /// Returns the full concatenated bottom string
        public var bottomStringValue: String {
            components[4...7].reduce("", +)
        }
        
    }
    
    
    // MARK: Hotkeys
    
    /// Abstraction subclass
    public struct Hotkeys: Hashable {
        
        public var shift = false
        public var ctrl = false
        public var option = false
        public var cmd = false
        
        public var undo = false
        public var save = false
        
        public var editMode = false
        public var editTool = false
        
    }
    
    // MARK: Window Functions
    
    /// Abstraction subclass
    public struct WindowFunctions: Hashable {
        
        public var mix = false
        public var edit = false
        public var transport = false
        public var memLoc = false
        public var status = false
        public var alt = false
        
    }
    
    // MARK: Bank move
    
    /// Abstraction subclass
    public struct BankMove: Hashable {
        
        public var channelLeft = false
        public var channelRight = false
        public var bankLeft = false
        public var bankRight = false
        
    }
    
    // MARK: Bank move
    
    /// Abstraction subclass
    public struct Assign: Hashable {
        
        public var textDisplay = "   "
        
        public var recordReadyAll = false
        public var bypass = false
        
        public var sendA = false
        public var sendB = false
        public var sendC = false
        public var sendD = false
        public var sendE = false
        public var pan = false
        
        public var mute = false
        public var shift = false
        
        public var input = false
        public var output = false
        public var assign = false
        
        public var suspend = false
        public var `default` = false
        
    }
    
    // MARK: Cursor
    
    /// Abstraction subclass
    public struct Cursor: Hashable {
        
        // down, up, left, right: no LED, just command buttons
        public var mode = false // button in the middle of arrow cursor buttons
        
        public var scrub = false
        public var shuttle = false
        
    }
    
    // MARK: Transport
    
    /// Abstraction subclass
    public struct Transport: Hashable {
        
        public var rewind = false
        public var stop = false
        public var play = false
        public var fastFwd = false
        public var record = false
        
        public var talkback = false
        
        public var punch_audition = false
        public var punch_pre = false
        public var punch_in = false
        public var punch_out = false
        public var punch_post = false
        public var rtz = false
        public var end = false
        public var online = false
        public var loop = false
        public var quickPunch = false
        
    }
    
    // MARK: Transport
    
    /// Abstraction subclass
    public struct ControlRoom: Hashable {
        
        public var input1 = false
        public var input2 = false
        public var input3 = false
        public var discrete = false
        public var mute = false
        
        public var output1 = false
        public var output2 = false
        public var output3 = false
        public var dim = false
        public var mono = false
        
    }
    
}
