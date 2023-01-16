//
//  HUISurfaceModel.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

/// HUI State Model.
///
/// Represents state of an entire HUI control surface (all controls, display elements, etc.).
///
/// The same model is used for:
/// - The main control surface unit (including extra functions and control room section)
/// - Any additional 8-fader bank extension units (except that the extra functions that don't exist
/// on these hardware units simply don't apply and are ignored)
public struct HUISurfaceModel: Equatable, Hashable {
    // MARK: - State Storage
    
    /// State storage representing channel 8 strips and their components. (`0 ... 7`)
    private var _channelStrips: [ChannelStrip] = (0 ... 7).map { _ in ChannelStrip() }
    public var channelStrips: [ChannelStrip] {
        get {
            _channelStrips
        }
        set {
            // array count validation
            if newValue.count == 8 { _channelStrips = newValue }
        }
        _modify {
            // mutate
            yield &_channelStrips

            // array count validation
            if _channelStrips.count < 8 {
                _channelStrips.append(
                    contentsOf: [ChannelStrip](
                        repeating: ChannelStrip(),
                        count: 8 - _channelStrips.count
                    )
                )
            } else if _channelStrips.count > 8 {
                _channelStrips.removeLast(_channelStrips.count - 8)
            }
        }
    }
    
    /// State storage representing the Main Time Display LCD and surrounding status LEDs.
    public var timeDisplay = TimeDisplay()
    
    /// State storage representing the Large Text Display (40 x 2 character matrix).
    public var largeDisplay = LargeDisplay()
    
    /// State storage representing the Transport section.
    public var transport = Transport()
    
    /// State storage representing HotKeys (keyboard shortcut keys).
    public var hotKeys = HotKeys()
    
    /// State storage representing Window Functions.
    public var windowFunctions = WindowFunctions()
    
    /// State storage representing bank and channel navigation.
    public var bankMove = BankMove()
    
    /// State storage representing the Assign controls.
    public var assign = Assign()
    
    /// State storage representing Cursor Movement / Mode / Scrub / Shuttle.
    public var cursor = Cursor()
    
    /// State storage representing the Control Room section.
    public var controlRoom = ControlRoom()
    
    /// State storage representing Number Pad Keys on the HUI surface.
    public var numPad = NumPad()
    
    /// State storage representing the Auto Enable section.
    public var autoEnable = AutoEnable()
    
    /// State storage representing the Auto Mode section.
    public var autoMode = AutoMode()
    
    /// State storage representing the Status/Group section.
    public var statusAndGroup = StatusAndGroup()
    
    /// State storage representing the Edit section.
    public var edit = Edit()
    
    /// State storage representing the Function Key section.
    public var functionKey = FunctionKey()
    
    /// State storage representing the Parameter Edit section.
    public var parameterEdit = ParameterEdit()
    
    /// State storage representing footswitches and sounds.
    public var footswitchesAndSounds = FootswitchesAndSounds()
    
    // MARK: - Init
    
    /// Initialize with default state.
    public init() { }
}
