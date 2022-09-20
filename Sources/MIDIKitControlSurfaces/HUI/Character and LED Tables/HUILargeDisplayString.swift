//
//  HUILargeDisplayString.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// HUI large text display 40-character string.
public struct HUILargeDisplayString: Equatable, Hashable {
    public static let defaultChars: [HUILargeDisplayCharacter] = .init(
        repeating: .default(),
        count: 4
    )
    
    /// HUI-encoded characters that make up the string.
    public var chars: [HUILargeDisplayCharacter] {
        didSet {
            // validation
            
            switch chars.count {
            case ..<40:
                chars.append(
                    contentsOf:
                    [HUILargeDisplayCharacter](
                        repeating: .default(),
                        count: 40 - chars.count
                    )
                )
                
            case 41...:
                chars = Array(chars.prefix(40))
                
            default: break
            }
        }
    }
    
    /// Returns the 40-character sequence as four 10-character slices.
    var slices: [[HUILargeDisplayCharacter]] {
        chars.split(every: 10).map { Array($0) }
    }
    
    /// Initialize with empty string.
    public init() {
        self.chars = Self.defaultChars
    }
    
    /// Initialize with HUI-encoded characters.
    public init(chars: [HUILargeDisplayCharacter]) {
        self.chars = chars
    }
    
    /// Initialize from a string.
    /// Characters will be converted or substituted if they are not contained in the ``HUILargeDisplayCharacter`` character set.
    /// String will be truncated to 40 characters if longer than 40.
    public init<S: StringProtocol>(lossy source: S) {
        let padded = (source + String(repeating: " ", count: 40)).prefix(40)
        let encoded: [HUILargeDisplayCharacter] = padded.map {
            HUILargeDisplayCharacter(String($0)) ?? .unknown()
        }
        chars = encoded
    }
    
    /// Return the characters as a concatenated human-readable string.
    public var stringValue: String {
        chars.map(\.string).joined()
    }
}
