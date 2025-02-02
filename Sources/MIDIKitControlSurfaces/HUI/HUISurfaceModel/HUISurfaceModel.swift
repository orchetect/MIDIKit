//
//  HUISurfaceModel.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// HUI State Model.
///
/// Represents state of an entire HUI control surface (all controls, display elements, etc.).
///
/// The same model is used for:
/// - The main control surface unit (including extra functions and control room section)
/// - Any additional 8-fader bank extension units (except that the extra functions that don't exist
///   on these hardware units simply don't apply and are ignored)
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@Observable public class HUISurfaceModel {
    // MARK: - State Storage
    
    /// State storage representing channel 8 strips and their components. (`0 ... 7`)
    @ObservationIgnored
    public internal(set) var channelStrips: [HUISurfaceModelState.ChannelStrip] = (0 ... 7)
        .map { _ in HUISurfaceModelState.ChannelStrip() }
    
    /// State storage representing the Main Time Display LCD and surrounding status LEDs.
    public var timeDisplay = HUISurfaceModelState.TimeDisplay()
    
    /// State storage representing the Large Text Display (40 x 2 character matrix).
    public var largeDisplay = HUISurfaceModelState.LargeDisplay()
    
    /// State storage representing the Transport section.
    public var transport = HUISurfaceModelState.Transport()
    
    /// State storage representing HotKeys (keyboard shortcut keys).
    public var hotKeys = HUISurfaceModelState.HotKeys()
    
    /// State storage representing Window Functions.
    public var windowFunctions = HUISurfaceModelState.WindowFunctions()
    
    /// State storage representing bank and channel navigation.
    public var bankMove = HUISurfaceModelState.BankMove()
    
    /// State storage representing the Assign controls.
    public var assign = HUISurfaceModelState.Assign()
    
    /// State storage representing Cursor Movement / Mode / Scrub / Shuttle.
    public var cursor = HUISurfaceModelState.Cursor()
    
    /// State storage representing the Control Room section.
    public var controlRoom = HUISurfaceModelState.ControlRoom()
    
    /// State storage representing Number Pad Keys on the HUI surface.
    public var numPad = HUISurfaceModelState.NumPad()
    
    /// State storage representing the Auto Enable section.
    public var autoEnable = HUISurfaceModelState.AutoEnable()
    
    /// State storage representing the Auto Mode section.
    public var autoMode = HUISurfaceModelState.AutoMode()
    
    /// State storage representing the Status/Group section.
    public var statusAndGroup = HUISurfaceModelState.StatusAndGroup()
    
    /// State storage representing the Edit section.
    public var edit = HUISurfaceModelState.Edit()
    
    /// State storage representing the Function Key section.
    public var functionKey = HUISurfaceModelState.FunctionKey()
    
    /// State storage representing the Parameter Edit section.
    public var parameterEdit = HUISurfaceModelState.ParameterEdit()
    
    /// State storage representing footswitches and sounds.
    public var footswitchesAndSounds = HUISurfaceModelState.FootswitchesAndSounds()
    
    // MARK: - Init
    
    /// Initialize with default state.
    public init() { }
}
