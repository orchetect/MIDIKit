//
//  DataParser+MIDI1File.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
internal import SwiftDataParsing

extension DataParserProtocol where DataRange: DataProtocol {
    /// Convenience to decode a variable-length value.
    mutating func decodeSMF1VariableLengthValue() throws(MIDIFileDecodeError) -> Int {
        let readAheadCount = remainingByteCount.clamped(to: 1 ... 4)
        
        let lengthBytes = try toMIDIFileDecodeError(
            malformedReason: "Could not extract variable-length value length.",
            try read(bytes: readAheadCount, advance: false)
        )
        guard let valueAndLength = lengthBytes.decodeSMF1VariableLengthValue()
        else {
            throw .malformed(
                "Could not extract variable length."
            )
        }
        try toMIDIFileDecodeError(try seek(by: valueAndLength.byteLength))
        
        return valueAndLength.value
    }
}
