//
//  MIDI File CustomStringConvertible.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
@_implementationOnly import OTCore

extension MIDIFile: CustomStringConvertible,
                    CustomDebugStringConvertible {
    public var description: String {
        var outputString = ""

        outputString += "MIDIFile(".newLined
        outputString += "  format: \(format)".newLined
        outputString += "  timebase: \(timeBase)".newLined
        outputString += "  chunks (\(chunks.count)): ".newLined

        chunks.enumerated().forEach {
            // indent each line with additional spaces
            outputString += "Chunk #\($0.offset + 1): \($0.element.description)"
                .split(separator: Character.newLine)
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
                .split(separator: Character.newLine)
                .reduce("") { $0 + "    \($1)".newLined }
        }

        outputString += ")"

        return outputString
    }
}
