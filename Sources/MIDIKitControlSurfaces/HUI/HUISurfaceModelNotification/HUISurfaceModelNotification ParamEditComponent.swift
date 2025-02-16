//
//  HUISurfaceModelNotification ParamEditComponent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUISurfaceModelNotification {
    /// A discrete component of a the Param Edit section and its state change.
    public enum ParamEditComponent {
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

extension HUISurfaceModelNotification.ParamEditComponent: Equatable { }

extension HUISurfaceModelNotification.ParamEditComponent: Hashable { }

extension HUISurfaceModelNotification.ParamEditComponent: Sendable { }

extension HUISurfaceModelNotification.ParamEditComponent: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .assign(state):
            "assign(state: \(state))"
        case let .compare(state):
            "compare(state: \(state))"
        case let .bypass(state):
            "bypass(state: \(state))"
        case let .param1Select(state):
            "param1Select(state: \(state))"
        case let .param1VPot(display):
            "param1VPot(\(display))"
        case let .param2Select(state):
            "param2Select(state: \(state))"
        case let .param2VPot(display):
            "param2VPot(\(display))"
        case let .param3Select(state):
            "param3Select(state: \(state))"
        case let .param3VPot(display):
            "param3VPot(\(display))"
        case let .param4Select(state):
            "param4Select(state: \(state))"
        case let .param4VPot(display):
            "param4VPot(\(display))"
        case let .insertOrParam(state):
            "insertOrParam(state: \(state))"
        }
    }
}
