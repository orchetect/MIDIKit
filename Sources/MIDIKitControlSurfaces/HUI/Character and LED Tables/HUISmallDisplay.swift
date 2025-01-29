//
//  HUISmallDisplay.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

/// Enum describing a HUI surface small text display.
public enum HUISmallDisplay: Equatable, Hashable {
    case channel(UInt4)
    case selectAssign
    
    /// Initialize from raw value for encoding/decoding HUI message.
    @inlinable
    init?(rawValue: UInt8) {
        switch rawValue {
        case 0x0 ... 0x7:
            let uInt4 = UInt4(rawValue)
            self = .channel(uInt4)
        case 0x8:
            self = .selectAssign
        default:
            return nil
        }
    }
    
    /// Raw value for encoding/decoding HUI message.
    @inlinable
    var rawValue: UInt7 {
        switch self {
        case let .channel(uInt4):
            return uInt4.toUInt7
        case .selectAssign:
            return 8
        }
    }
}

extension HUISmallDisplay: Sendable { }
