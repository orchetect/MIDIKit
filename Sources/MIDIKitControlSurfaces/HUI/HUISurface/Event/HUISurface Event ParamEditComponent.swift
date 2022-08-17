//
//  HUISurface Event ParamEditComponent.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension HUISurface.Event {
    /// A discrete component of a the param edit section and it state/value.
    public enum ParamEditComponent: Equatable, Hashable {
        case assign(Bool)
        case compare(Bool)
        case bypass(Bool)
        
        case param1Select(Bool)
        case param1VPotLevel(UInt7)
        
        case param2Select(Bool)
        case param2VPotLevel(UInt7)
        
        case param3Select(Bool)
        case param3VPotLevel(UInt7)
        
        case param4Select(Bool)
        case param4VPotLevel(UInt7)
        
        case insertOrParam(Bool)
    }
}
