//
//  HUITimeDisplayString.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// HUI time display string, comprised of 8 digits.
///
/// The time display consists of eight 7-segment displays (called digits). Every digit except the last (rightmost) has the ability to show a trailing decimal point (dot).
public struct HUITimeDisplayString: Equatable, Hashable {
    /// HUI-encoded the digits that make up the full time display.
    public var digits: [HUITimeDisplayCharacter] = .defaultDigits {
        didSet {
            switch digits.count {
            case ...7:
                digits.append(
                    contentsOf: [HUITimeDisplayCharacter](
                        repeating: .space,
                        count: 8 - digits.count
                    )
                )
            case 9...:
                digits = Array(digits.prefix(8))
            default:
                break
            }
        }
    }
    
    /// Initialize with empty string.
    public init() {
        self.digits = .defaultDigits
    }
    
    /// Initialize with HUI-encoded digits.
    public init(digits: [HUITimeDisplayCharacter]) {
        self.digits = digits
    }
    
    /// Initialize from a string.
    /// String will be truncated to 8 digits if longer than 8.
    public init<S: StringProtocol>(lossy source: S) {
        var digits: [HUITimeDisplayCharacter] = []
        
        // ensure there's at least one character in the source string
        guard var idx = source.indices.first else {
            self.digits = digits
            return
        }
        
        repeat {
            var digitStr = String(source[idx])
            idx = source.index(after: idx)
            
            if idx != source.indices.last {
                let nextIdx = source.index(after: idx)
                if source[nextIdx] == "." {
                    digitStr += "."
                    idx = source.index(after: idx)
                }
            }
            
            let digit = HUITimeDisplayCharacter(digitStr) ?? .default()
            digits.append(digit)
        } while idx != source.indices.last
        
        self.digits = digits
    }
    
    /// Return the digits as a concatenated human-readable string.
    public var stringValue: String {
        digits.map(\.string).joined()
    }
}

extension [HUITimeDisplayCharacter] {
    /// Empty display digits.
    /// Equivalent to: "        "
    public static let blankDigits: [HUITimeDisplayCharacter] = [
        .space,
        .space,
        .space,
        .space,
        .space,
        .space,
        .space,
        .space
    ]
    
    /// Default display digits.
    /// Equivalent to: "00.00.00.00"
    public static let defaultDigits: [HUITimeDisplayCharacter] = [
        ._0,
        ._0dot,
        ._0,
        ._0dot,
        ._0,
        ._0dot,
        ._0,
        ._0
    ]
}
