//
//  HUISurfaceModelState Cursor.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing Cursor Movement / Mode / Scrub / Shuttle.
    @available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
    @Observable public class Cursor {
        // up    - no LED, just command button
        // left  - no LED, just command button
        // right - no LED, just command button
        // down  - no LED, just command button
        
        /// Mode Button (in the middle of arrow cursor buttons).
        public var mode = false
        
        public var scrub = false
        public var shuttle = false
    }
}

@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
extension HUISurfaceModelState.Cursor: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.Cursor
    
    @inlinable
    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .up:      false
        case .left:    false
        case .right:   false
        case .down:    false
        case .mode:    mode
        case .scrub:   scrub
        case .shuttle: shuttle
        }
    }
    
    @inlinable
    public func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .up:      return
        case .left:    return
        case .right:   return
        case .down:    return
        case .mode:    mode = state
        case .scrub:   scrub = state
        case .shuttle: shuttle = state
        }
    }
}
