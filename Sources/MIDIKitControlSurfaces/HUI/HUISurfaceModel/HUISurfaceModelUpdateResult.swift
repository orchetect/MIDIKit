//
//  HUISurfaceModelUpdateResult.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Result returned from ``HUISurfaceModel/updateState(from:)``.
public enum HUISurfaceModelUpdateResult {
    /// The received HUI host event resulted in a change to the HUI surface model.
    case changed(HUISurfaceModelNotification)
    
    /// The received HUI host event did not result in any changes to the HUI surface model.
    case unchanged
    
    /// The HUI host event is unhandled, and no model changes occurred.
    case unhandled(HUIHostEvent)
}
