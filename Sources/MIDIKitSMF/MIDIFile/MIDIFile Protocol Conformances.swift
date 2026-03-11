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
        description(trackMaxEventCount: 5) // by default, limit number of events
    }
    
    /// Generate a description of the track, optionally limiting the number of events from each track in the output.
    public func description(trackMaxEventCount: Int?) -> String {
        descriptionBuilder(
            formatDesc: { $0.description },
            timebaseDesc: { $0.description },
            chunkDesc: {
                switch $0 {
                case let .track(track): track.description(maxEventCount: trackMaxEventCount)
                case let .other(unrecognizedChunk): unrecognizedChunk.description
                }
            }
        )
    }
}

extension MIDIFile: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescription(trackMaxEventCount: 10) // by default, limit number of events
    }
    
    /// Generate a debug description of the track, optionally limiting the number of events from each track in the output.
    public func debugDescription(trackMaxEventCount: Int?) -> String {
        descriptionBuilder(
            formatDesc: { $0.description },
            timebaseDesc: { $0.description },
            chunkDesc: {
                switch $0 {
                case let .track(track): track.debugDescription(maxEventCount: trackMaxEventCount)
                case let .other(unrecognizedChunk): unrecognizedChunk.debugDescription
                }
            }
        )
    }
}

extension MIDIFile {
    func descriptionBuilder(
        formatDesc: (Format) -> String,
        timebaseDesc: (Timebase) -> String,
        chunkDesc: (_ chunk: Chunk) -> String
    ) -> String {
        var outputString = ""
        
        outputString += "MIDIFile(".newLined
        outputString += "  format: \(formatDesc(format))".newLined
        outputString += "  timebase: \(timebaseDesc(timebase))".newLined
        outputString += "  chunks (\(chunks.count)): ".newLined
        
        for chunk in chunks.enumerated() {
            let chunkDebugDesc = chunkDesc(chunk.element)
            
            // indent each line with additional spaces
            outputString += "#\(chunk.offset + 1): \(chunkDebugDesc)"
                .split(separator: "\n")
                .reduce("") { $0 + "    \($1)".newLined }
        }
        
        outputString += ")"
        
        return outputString
    }
}
