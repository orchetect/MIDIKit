//
//  HUISurfaceModelState.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol allowing reading and writing of ``HUISurfaceModel`` state by way of methods that
/// accept a strongly-typed enum case.
public protocol HUISurfaceModelState where Switch: HUISwitchProtocol {
    associatedtype Switch
    
    /// Return the state of a HUI switch.
    func state(of huiSwitch: Switch) -> Bool
    
    /// Set the state of a HUI switch.
    mutating func setState(of huiSwitch: Switch, to state: Bool)
}
