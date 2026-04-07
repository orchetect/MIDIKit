//
//  MIDI1File Protocol Conformances.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

extension MIDI1File: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.header == rhs.header &&
            lhs.chunks == rhs.chunks
    }
}

extension MIDI1File: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(header)
        hasher.combine(chunks)
    }
}

extension MIDI1File: Identifiable {
    // `id` property is stored instance property
}

extension MIDI1File: CustomStringConvertible {
    public var description: String {
        description(maxEventCount: 10) // by default, limit number of events
    }
    
    /// Generate a description of the track, optionally limiting the number of events from each track in the output.
    public func description(maxEventCount: Int?) -> String {
        descriptionBuilder(
            formatDesc: { $0.description },
            timebaseDesc: { $0.description },
            chunkDesc: {
                switch $0 {
                case let .track(track): track.description(maxEventCount: maxEventCount)
                case let .undefined(chunk): chunk.description
                }
            }
        )
    }
}

extension MIDI1File: CustomDebugStringConvertible {
    public var debugDescription: String {
        debugDescription(maxEventCount: 10) // by default, limit number of events
    }
    
    /// Generate a debug description of the track, optionally limiting the number of events from each track in the output.
    public func debugDescription(maxEventCount: Int?) -> String {
        descriptionBuilder(
            formatDesc: { $0.description },
            timebaseDesc: { $0.description },
            chunkDesc: {
                switch $0 {
                case let .track(track): track.debugDescription(maxEventCount: maxEventCount)
                case let .undefined(chunk): chunk.debugDescription
                }
            }
        )
    }
}

extension MIDI1File {
    func descriptionBuilder(
        formatDesc: (MIDI1FileFormat) -> String,
        timebaseDesc: (Timebase) -> String,
        chunkDesc: (_ chunk: AnyChunk) -> String
    ) -> String {
        var outputString = ""
        
        outputString += "MIDI1File(".newLined
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
