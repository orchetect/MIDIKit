//
//  HUISurfaceModelState WindowFunctions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurfaceModelState {
    /// State storage representing Window Functions.
    public struct WindowFunctions: Equatable, Hashable {
        public var mix = false
        public var edit = false
        public var transport = false
        public var memLoc = false
        public var status = false
        public var alt = false
    }
}

extension HUISurfaceModelState.WindowFunctions: HUISurfaceModelStateProtocol {
    public typealias Switch = HUISwitch.Window

    public func state(of huiSwitch: Switch) -> Bool {
        switch huiSwitch {
        case .mix:        return mix
        case .edit:       return edit
        case .transport:  return transport
        case .memLoc:     return memLoc
        case .status:     return status
        case .alt:        return alt
        }
    }
    
    public mutating func setState(of huiSwitch: Switch, to state: Bool) {
        switch huiSwitch {
        case .mix:        mix = state
        case .edit:       edit = state
        case .transport:  transport = state
        case .memLoc:     memLoc = state
        case .status:     status = state
        case .alt:        alt = state
        }
    }
}
