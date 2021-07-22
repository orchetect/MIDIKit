//
//  CC Extensions.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.CC {
    
    @inline(__always)
    public static func == <T: BinaryInteger>(lhs: Self, rhs: T) -> Bool {
        
        lhs.controller.value == rhs
        
    }
    
    @inline(__always)
    public static func != <T: BinaryInteger>(lhs: Self, rhs: T) -> Bool {
        
        lhs.controller.value != rhs
        
    }
    
    @inline(__always)
    public static func == <T: BinaryInteger>(lhs: T, rhs: Self) -> Bool {
        
        lhs == rhs.controller.value
        
    }
    
    @inline(__always)
    public static func != <T: BinaryInteger>(lhs: T, rhs: Self) -> Bool {
        
        lhs != rhs.controller.value
        
    }
    
}
