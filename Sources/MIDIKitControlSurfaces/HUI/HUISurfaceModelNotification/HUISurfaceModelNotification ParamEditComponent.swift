//
//  HUISurfaceModelNotification ParamEditComponent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUISurfaceModelNotification {
    /// A discrete component of a the Param Edit section and its state change.
    public enum ParamEditComponent: Equatable, Hashable {
        case assign(state: Bool)
        case compare(state: Bool)
        case bypass(state: Bool)
        
        case param1Select(state: Bool)
        case param1VPot(display: HUIVPotDisplay)
        
        case param2Select(state: Bool)
        case param2VPot(display: HUIVPotDisplay)
        
        case param3Select(state: Bool)
        case param3VPot(display: HUIVPotDisplay)
        
        case param4Select(state: Bool)
        case param4VPot(display: HUIVPotDisplay)
        
        case insertOrParam(state: Bool)
        
        // paramScroll rotary knob has no display, it's for surface → host user-input only
    }
}

extension HUISurfaceModelNotification.ParamEditComponent: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .assign(state):
            return "assign(state: \(state))"
        case let .compare(state):
            return "compare(state: \(state))"
        case let .bypass(state):
            return "bypass(state: \(state))"
        case let .param1Select(state):
            return "param1Select(state: \(state))"
        case let .param1VPot(display):
            return "param1VPot(\(display))"
        case let .param2Select(state):
            return "param2Select(state: \(state))"
        case let .param2VPot(display):
            return "param2VPot(\(display))"
        case let .param3Select(state):
            return "param3Select(state: \(state))"
        case let .param3VPot(display):
            return "param3VPot(\(display))"
        case let .param4Select(state):
            return "param4Select(state: \(state))"
        case let .param4VPot(display):
            return "param4VPot(\(display))"
        case let .insertOrParam(state):
            return "insertOrParam(state: \(state))"
        }
    }
}
