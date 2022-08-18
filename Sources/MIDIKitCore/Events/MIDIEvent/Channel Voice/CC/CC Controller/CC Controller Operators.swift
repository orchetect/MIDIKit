//
//  CC Controller Operators.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.CC.Controller {
    public static func == <T: BinaryInteger>(lhs: Self, rhs: T) -> Bool {
        lhs.number.value == rhs
    }
    
    public static func != <T: BinaryInteger>(lhs: Self, rhs: T) -> Bool {
        lhs.number.value != rhs
    }
    
    public static func == <T: BinaryInteger>(lhs: T, rhs: Self) -> Bool {
        lhs == rhs.number.value
    }
    
    public static func != <T: BinaryInteger>(lhs: T, rhs: Self) -> Bool {
        lhs != rhs.number.value
    }
}
