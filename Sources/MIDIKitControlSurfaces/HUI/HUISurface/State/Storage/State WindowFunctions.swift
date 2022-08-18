//
//  State WindowFunctions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension HUISurface.State {
    /// State storage representing Window Functions
    public struct WindowFunctions: Equatable, Hashable {
        public var mix = false
        public var edit = false
        public var transport = false
        public var memLoc = false
        public var status = false
        public var alt = false
    }
}

extension HUISurface.State.WindowFunctions: HUISurfaceStateProtocol {
    public typealias Param = HUIParameter.WindowFunction

    public func state(of param: Param) -> Bool {
        switch param {
        case .mix:        return mix
        case .edit:       return edit
        case .transport:  return transport
        case .memLoc:     return memLoc
        case .status:     return status
        case .alt:        return alt
        }
    }
    
    public mutating func setState(of param: Param, to state: Bool) {
        switch param {
        case .mix:        mix = state
        case .edit:       edit = state
        case .transport:  transport = state
        case .memLoc:     memLoc = state
        case .status:     status = state
        case .alt:        alt = state
        }
    }
}
