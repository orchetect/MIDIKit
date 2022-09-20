//
//  HUISmallDisplayString.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// HUI small text display 4-character string.
public struct HUISmallDisplayString: Equatable, Hashable {
    public static let defaultChars: [HUISmallDisplayCharacter] = .init(
        repeating: .default(),
        count: 4
    )
    
    /// HUI-encoded characters that make up the string.
    public var chars: [HUISmallDisplayCharacter] = defaultChars {
        didSet {
            // validation
            
            switch chars.count {
            case ..<4:
                chars.append(
                    contentsOf:
                    [HUISmallDisplayCharacter](
                        repeating: .default(),
                        count: 4 - chars.count
                    )
                )
                
            case 5...:
                chars = Array(chars.prefix(4))
                
            default: break
            }
        }
    }
    
    /// Initialize with empty string.
    public init() { }
    
    /// Initialize with HUI-encoded characters.
    public init(chars: [HUISmallDisplayCharacter]) {
        self.chars = chars
    }
    
    /// Initialize from a string.
    /// Characters will be converted or substituted if they are not contained in the ``HUISmallDisplayCharacter`` character set.
    /// String will be truncated to 4 characters if longer than 4.
    public init<S: StringProtocol>(lossy source: S) {
        let padded = (source + String(repeating: " ", count: 4)).prefix(4)
        let encoded: [HUISmallDisplayCharacter] = padded.map {
            HUISmallDisplayCharacter(String($0)) ?? .unknown()
        }
        chars = encoded
    }
    
    /// Return the characters as a concatenated human-readable string.
    public var stringValue: String {
        chars.map(\.string).joined()
    }
}
