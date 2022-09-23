//
//  HUISurfaceModelNotification ParamEditComponent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUISurfaceModelNotification {
    /// A discrete component of a the Param Edit section and its state change.
    public enum ParamEditComponent: Equatable, Hashable {
        case assign(state: Bool)
        case compare(state: Bool)
        case bypass(state: Bool)
        
        case param1Select(state: Bool)
        case param1VPot(value: HUIVPotValue)
        
        case param2Select(state: Bool)
        case param2VPot(value: HUIVPotValue)
        
        case param3Select(state: Bool)
        case param3VPot(value: HUIVPotValue)
        
        case param4Select(state: Bool)
        case param4VPot(value: HUIVPotValue)
        
        case insertOrParam(state: Bool)
        case paramScroll(delta: Int7)
    }
}
