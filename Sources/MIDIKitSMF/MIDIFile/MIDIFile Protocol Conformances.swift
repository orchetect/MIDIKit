//
//  MIDIFile Protocol Conformances.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension MIDIFile: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.header == rhs.header &&
            lhs.format == rhs.format &&
            lhs.timeBase == rhs.timeBase &&
            lhs.chunks == rhs.chunks
    }
}

extension MIDIFile: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(header)
        hasher.combine(format)
        hasher.combine(timeBase)
        hasher.combine(chunks)
    }
}

extension MIDIFile: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        var outputString = ""

        outputString += "MIDIFile(".newLined
        outputString += "  format: \(format)".newLined
        outputString += "  timebase: \(timeBase)".newLined
        outputString += "  chunks (\(chunks.count)): ".newLined

        chunks.enumerated().forEach {
            // indent each line with additional spaces
            outputString += "Chunk #\($0.offset + 1): \($0.element.description)"
                .split(separator: "\n")
                .reduce("") { $0 + "    \($1)".newLined }
        }

        outputString += ")"

        return outputString
    }

    public var debugDescription: String {
        var outputString = ""

        outputString += "MIDIFile(".newLined
        outputString += "  format: \(format.debugDescription)".newLined
        outputString += "  timebase: \(timeBase.debugDescription)".newLined
        outputString += "  chunks (\(chunks.count)): ".newLined

        chunks.enumerated().forEach {
            // indent each line with additional spaces
            outputString += "#\($0.offset + 1): \($0.element.debugDescription)"
                .split(separator: "\n")
                .reduce("") { $0 + "    \($1)".newLined }
        }

        outputString += ")"

        return outputString
    }
}
