//
//  CC Controller Operators.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.CC.Controller {
    @inline(__always)
    public static func == <T: BinaryInteger>(lhs: Self, rhs: T) -> Bool {
        lhs.number.value == rhs
    }
    
    @inline(__always)
    public static func != <T: BinaryInteger>(lhs: Self, rhs: T) -> Bool {
        lhs.number.value != rhs
    }
    
    @inline(__always)
    public static func == <T: BinaryInteger>(lhs: T, rhs: Self) -> Bool {
        lhs == rhs.number.value
    }
    
    @inline(__always)
    public static func != <T: BinaryInteger>(lhs: T, rhs: Self) -> Bool {
        lhs != rhs.number.value
    }
}
