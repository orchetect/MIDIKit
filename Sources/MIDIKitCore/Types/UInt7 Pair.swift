//
//  UInt7 Pair.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Type that holds a pair of `UInt7`s - one MSB `UInt7`, one LSB `UInt7`.
public struct UInt7Pair: Equatable, Hashable {
    public let msb: UInt7
    public let lsb: UInt7
    
    @inline(__always)
    public init(msb: UInt7, lsb: UInt7) {
        self.msb = msb
        self.lsb = lsb
    }
    
    public var uInt14Value: UInt14 {
        .init(uInt7Pair: self)
    }
}
