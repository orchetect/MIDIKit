//
//  HUISurfaceStateProtocol.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

public protocol HUISurfaceStateProtocol where Param: HUIParameterProtocol {
    associatedtype Param
    
    /// Read the state of a parameter.
    func state(of param: Param) -> Bool
    
    /// Set the state of a parameter.
    mutating func setState(of param: Param, to state: Bool)
}
