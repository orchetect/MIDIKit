//
//  HUIEvent ParamEditComponent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension HUIEvent {
    /// A discrete component of a the param edit section and its state change.
    public enum ParamEditComponent: Equatable, Hashable {
        case assign(state: Bool)
        case compare(state: Bool)
        case bypass(state: Bool)
        
        case param1Select(state: Bool)
        case param1VPotLevel(delta: UInt7)
        
        case param2Select(state: Bool)
        case param2VPotLevel(delta: UInt7)
        
        case param3Select(state: Bool)
        case param3VPotLevel(delta: UInt7)
        
        case param4Select(state: Bool)
        case param4VPotLevel(delta: UInt7)
        
        case insertOrParam(state: Bool)
        case paramScroll(delta: UInt7)
    }
}
