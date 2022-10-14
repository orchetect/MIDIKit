//
//  MIDIKit-0.6.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

// Symbols that were renamed or removed.

// MARK: Category Extensions for Type conversion

extension BinaryInteger {
    @available(*, unavailable, renamed: "toUInt4")
    public var toMIDIUInt4: UInt4 { fatalError() }
    
    @available(*, unavailable, renamed: "toUInt4Exactly")
    public var toMIDIUInt4Exactly: UInt4? { fatalError() }
}

extension BinaryInteger {
    @available(*, unavailable, renamed: "toUInt7")
    public var toMIDIUInt7: UInt7 { fatalError() }
    
    @available(*, unavailable, renamed: "toUInt7Exactly")
    public var toMIDIUInt7Exactly: UInt7? { fatalError() }
}

extension BinaryInteger {
    @available(*, unavailable, renamed: "toUInt9")
    public var toMIDIUInt9: UInt9 { fatalError() }
    
    @available(*, unavailable, renamed: "toUInt9Exactly")
    public var toMIDIUInt9Exactly: UInt9? { fatalError() }
}

extension BinaryInteger {
    @available(*, unavailable, renamed: "toUInt14")
    public var toMIDIUInt14: UInt14 { fatalError() }
    
    @available(*, unavailable, renamed: "toUInt14Exactly")
    public var toMIDIUInt14Exactly: UInt14? { fatalError() }
}

extension BinaryInteger {
    @available(*, unavailable, renamed: "toUInt25")
    public var toMIDIUInt25: UInt25 { fatalError() }
    
    @available(*, unavailable, renamed: "toUInt25Exactly")
    public var toMIDIUInt25Exactly: UInt25? { fatalError() }
}
