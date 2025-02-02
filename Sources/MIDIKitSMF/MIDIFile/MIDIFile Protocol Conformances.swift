//
//  MIDIFile Protocol Conformances.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension MIDIFile: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.header == rhs.header &&
            lhs.chunks == rhs.chunks
    }
}

extension MIDIFile: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(header)
        hasher.combine(chunks)
    }
}

extension MIDIFile: Identifiable {
    // `id` property is stored in MIDIFile struct
}

extension MIDIFile: CustomStringConvertible {
    public var description: String {
        var outputString = ""
        
        outputString += "MIDIFile(".newLined
        outputString += "  format: \(format)".newLined
        outputString += "  timebase: \(timeBase)".newLined
        outputString += "  chunks (\(chunks.count)): ".newLined
        
        for chunk in chunks.enumerated() {
            // indent each line with additional spaces
            outputString += "Chunk #\(chunk.offset + 1): \(chunk.element.description)"
                .split(separator: "\n")
                .reduce("") { $0 + "    \($1)".newLined }
        }
        
        outputString += ")"
        
        return outputString
    }
}

extension MIDIFile: CustomDebugStringConvertible {
    public var debugDescription: String {
        var outputString = ""

        outputString += "MIDIFile(".newLined
        outputString += "  format: \(format.debugDescription)".newLined
        outputString += "  timebase: \(timeBase.debugDescription)".newLined
        outputString += "  chunks (\(chunks.count)): ".newLined

        for chunk in chunks.enumerated() {
            // indent each line with additional spaces
            outputString += "#\(chunk.offset + 1): \(chunk.element.debugDescription)"
                .split(separator: "\n")
                .reduce("") { $0 + "    \($1)".newLined }
        }

        outputString += ")"

        return outputString
    }
}
