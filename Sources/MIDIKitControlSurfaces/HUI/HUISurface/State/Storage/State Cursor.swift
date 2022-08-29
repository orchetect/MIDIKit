//
//  State Cursor.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurface.State {
    /// State storage representing Cursor Movement / Mode / Scrub / Shuttle.
    public struct Cursor: Equatable, Hashable {
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

extension HUISurface.State.Cursor: HUISurfaceStateProtocol {
    public typealias Param = HUIParameter.Cursor

    public func state(of param: Param) -> Bool {
        switch param {
        case .up:       return false
        case .left:     return false
        case .right:    return false
        case .down:     return false
        case .mode:     return mode
        case .scrub:    return scrub
        case .shuttle:  return shuttle
        }
    }
    
    public mutating func setState(of param: Param, to state: Bool) {
        switch param {
        case .up:       return
        case .left:     return
        case .right:    return
        case .down:     return
        case .mode:     mode = state
        case .scrub:    scrub = state
        case .shuttle:  shuttle = state
        }
    }
}
