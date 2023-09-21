//
//  UInt7Pair.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

/// Type that holds a pair of `UInt7`s - one MSB `UInt7`, one LSB `UInt7`.
public struct UInt7Pair: Equatable, Hashable {
    public let msb: UInt7
    public let lsb: UInt7
    
    public init(msb: UInt7, lsb: UInt7) {
        self.msb = msb
        self.lsb = lsb
    }
    
    public var uInt14Value: UInt14 {
        .init(uInt7Pair: self)
    }
}

extension UInt7Pair: CustomStringConvertible {
    public var description: String {
        "[msb: \(msb.hexString(padTo: 2)), lsb: \(lsb.hexString(padTo: 2))]"
    }
}
