//
//  ASCII String and Data.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension StringProtocol {
    /// Converts the string to ASCII-compatible raw `Data`.
    package func toASCIIData(lossy: Bool = false) -> Data {
        lossy
            ? data(using: .nonLossyASCII)
                ?? data(using: .ascii)
                ?? data(using: .utf8)
                ?? Data()
            : data(using: .nonLossyASCII)
                ?? Data()
    }
    
    /// Converts the string to ASCII-compatible raw bytes.
    package func toASCIIBytes(lossy: Bool = false) -> [UInt8] {
        [UInt8](toASCIIData(lossy: lossy))
    }
}

extension Data {
    /// Converts ASCII data to `String`.
    /// Returns `nil` if data is not valid ASCII.
    package func asciiDataToString() -> String? {
        String(
            data: self,
            encoding: .nonLossyASCII
        )
    }
    
    /// Converts ASCII data to `String`.
    /// Attempts to lossily convert the data if it is not valid ASCII.
    package func asciiDataToStringLossy() -> String {
        String(
            data: self,
            encoding: .nonLossyASCII
        )
            ?? String(
                data: self,
                encoding: .ascii
            )
            ?? String(
                data: self,
                encoding: .utf8
            )
            ?? String(repeating: "?", count: count)
    }
}

extension DataProtocol {
    /// Converts ASCII data to `String`.
    /// Returns `nil` if data is not valid ASCII.
    package func asciiDataToString() -> String? {
        String(
            data: Data(self),
            encoding: .nonLossyASCII
        )
    }
    
    /// Converts ASCII data to `String`.
    /// Attempts to lossily convert the data if it is not valid ASCII.
    package func asciiDataToStringLossy() -> String {
        let data = Data(self)
        
        // try standard String encoding inits first
        if let str = String(
            data: data,
            encoding: .nonLossyASCII
        )
            ?? String(
                data: data,
                encoding: .ascii
            )
            ?? String(
                data: data,
                encoding: .utf8
            )
        {
            return str
        }
        
        // otherwise, map characters
        let scalars = data.map { UnicodeScalar($0) }
        var str = ""
        str.unicodeScalars.append(contentsOf: scalars)
        
        return str
    }
}
