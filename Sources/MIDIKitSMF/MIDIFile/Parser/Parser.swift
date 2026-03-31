//
//  Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

extension MIDIFile {
    struct Parser<DataType: DataProtocol> where DataType: Sendable {
        let data: DataType
        
        let fileDescriptor: FileDescriptor
        
        init(data: DataType, options: MIDIFileDecodeOptions) throws(MIDIFileDecodeError) {
            self.data = data
            fileDescriptor = try Self.parseFileDescriptor(
                fileData: data,
                options: options
            )
            
            // print("Chunk descriptors:")
            // print(
            //     fileDescriptor.chunkDescriptors
            //         .map { "\($0.typeString) @ \($0.startOffset) (\($0.bodyByteLength) body bytes)" }
            //         .joined(separator: "\n")
            // )
        }
    }
}

extension MIDIFile.Parser: Sendable { }

// MARK: - Chunks Parsing

extension MIDIFile.Parser {
    /// Parses one chunk at a time and returns all chunks in order once all tracks have been parsed.
    func chunks(
        options: MIDIFileDecodeOptions,
        predicate: MIDIFile.DecodePredicate?
    ) throws(MIDIFileDecodeError) -> [MIDIFile.AnyChunk] {
        var newChunks: [MIDIFile.AnyChunk] = []
        for (index, chunkDescriptor) in fileDescriptor.chunkDescriptors.enumerated() {
            if let predicate {
                guard predicate(chunkDescriptor.identifier, index) else { continue }
            }
            
            let chunk = try data.withDataParser { parser throws(MIDIFileDecodeError) in
                try parser.toMIDIFileDecodeError(
                    try parser.seek(to: chunkDescriptor.bodyByteStartOffset)
                )
                let chunkData = try parser.toMIDIFileDecodeError(
                    try parser.read(bytes: chunkDescriptor.bodyByteLength)
                )
                return try Self.parseChunk(
                    chunkDescriptor: chunkDescriptor,
                    chunkIndex: index,
                    timebase: fileDescriptor.header.timebase,
                    options: options.trackDecodeOptions,
                    in: chunkData
                )
            }
            
            if let chunk {
                newChunks.append(chunk)
            }
        }
        return newChunks
    }
    
    /// Parses all chunks concurrently and returns all chunks in order once all tracks have been parsed.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    func chunks(
        options: MIDIFileDecodeOptions,
        predicate: MIDIFile.DecodePredicate?
    ) async throws(MIDIFileDecodeError) -> [MIDIFile.AnyChunk] {
        let result: Result<[MIDIFile.AnyChunk], MIDIFileDecodeError> = await withTaskGroup(
            of: Result<(index: Int, chunk: MIDIFile.AnyChunk?), MIDIFileDecodeError>.self,
            returning: Result<[MIDIFile.AnyChunk], MIDIFileDecodeError>.self
        ) { group in
            var newChunks: [Int: MIDIFile.AnyChunk] = [:]
            
            for (index, chunkDescriptor) in fileDescriptor.chunkDescriptors.enumerated() {
                if let predicate {
                    guard predicate(chunkDescriptor.identifier, index) else { continue }
                }
                
                group.addTask {
                    do throws(MIDIFileDecodeError) {
                        let chunk = try data.withDataParser { parser throws(MIDIFileDecodeError) in
                            try parser.toMIDIFileDecodeError(
                                try parser.seek(to: chunkDescriptor.bodyByteStartOffset)
                            )
                            let chunkData = try parser.toMIDIFileDecodeError(
                                try parser.read(bytes: chunkDescriptor.bodyByteLength)
                            )
                            return try Self.parseChunk(
                                chunkDescriptor: chunkDescriptor,
                                chunkIndex: index,
                                timebase: fileDescriptor.header.timebase,
                                options: options.trackDecodeOptions,
                                in: chunkData
                            )
                        }
                        
                        return .success((index: index, chunk: chunk))
                    } catch {
                        return .failure(error)
                    }
                }
            }
            
            for await result in group {
                switch result {
                case let .success((index, chunk)):
                    newChunks[index] = chunk
                case let .failure(error):
                    return .failure(error)
                }
            }
            
            let chunks = newChunks.sorted(by: { $0.key < $1.key }).map(\.value)
            return .success(chunks)
        }
        
        return try result.get()
    }
    
    /// Parses multiple chunks concurrently and emits them from an async sequence in random order.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    func chunksAsyncSequence(
        options: MIDIFileDecodeOptions,
        predicate: MIDIFile.DecodePredicate?
    ) -> AsyncStream<(index: Int, result: Result<MIDIFile.AnyChunk, MIDIFileDecodeError>)> {
        AsyncStream { continuation in
            Task { [data, options, predicate, continuation] in
                await withTaskGroup(
                    of: (index: Int, result: Result<MIDIFile.AnyChunk, MIDIFileDecodeError>)?.self,
                    returning: Void.self
                ) { [data, options, predicate, continuation] group in
                    for (index, chunkDescriptor) in fileDescriptor.chunkDescriptors.enumerated() {
                        if let predicate {
                            guard predicate(chunkDescriptor.identifier, index) else { continue }
                        }
                        
                        group.addTask {
                            do throws(MIDIFileDecodeError) {
                                let chunk = try data.withDataParser { parser throws(MIDIFileDecodeError) in
                                    try parser.toMIDIFileDecodeError(
                                        try parser.seek(to: chunkDescriptor.bodyByteStartOffset)
                                    )
                                    let chunkData = try parser.toMIDIFileDecodeError(
                                        try parser.read(bytes: chunkDescriptor.bodyByteLength)
                                    )
                                    return try Self.parseChunk(
                                        chunkDescriptor: chunkDescriptor,
                                        chunkIndex: index,
                                        timebase: fileDescriptor.header.timebase,
                                        options: options.trackDecodeOptions,
                                        in: chunkData
                                    )
                                }
                                
                                if let chunk {
                                    return (index: index, result: .success(chunk))
                                } else {
                                    return nil
                                }
                            } catch {
                                return (index: index, result: .failure(error))
                            }
                        }
                    }
                    
                    for await result in group {
                        if let result {
                            continuation.yield(with: .init { result })
                        }
                        
                        if Task.isCancelled {
                            group.cancelAll()
                            continuation.finish()
                            return
                        }
                    }
                    
                    continuation.finish()
                }
            }
        }
    }
}

// MARK: - Parsing Utilities

extension MIDIFile.Parser {
    static func parseFileDescriptor(
        fileData: some DataProtocol,
        options: MIDIFileDecodeOptions
    ) throws(MIDIFileDecodeError) -> FileDescriptor {
        guard !fileData.isEmpty else {
            throw .malformed("MIDI data is empty (contains no bytes).")
        }
        
        return try fileData.withDataParser { parser throws(MIDIFileDecodeError) in
            // ____ Header ____
            
            let headerStream = try parser.toMIDIFileDecodeError(
                malformedReason: "Error reading data for MIDI file header.",
                try parser.read(advance: false)
            )
            let (header, expectedTrackCount, headerLength) = try MIDIFile.HeaderChunk.initFrom(
                midi1SMFRawBytesStream: headerStream,
                allowMultiTrackFormat0: options.allowMultiTrackFormat0
            )
            try parser.toMIDIFileDecodeError(
                malformedReason: "Error reading data past MIDI file header.",
                try parser.seek(by: headerLength)
            )
            
            // chunks
            
            var isParsing = true
            var chunkDescriptors: [ChunkDescriptor] = []
            
            // gather chunk references before parsing their contents
            
            while isParsing {
                do throws(MIDIFileDecodeError) {
                    // chunk header
                    let chunkStartByteOffset = parser.readOffset
                    guard let identifierBytes = try? parser.read(bytes: 4),
                          let identifierString = identifierBytes.asciiDataToString(),
                          let identifier = AnyMIDIFileChunkIdentifier(string: identifierString)
                    else {
                        let offsetString = parser.readOffset.hexString(prefix: true)
                        throw .malformed(
                            "There was a problem reading chunk header at byte offset \(offsetString). Encountered end of file early or chunk identifier may be malformed."
                        )
                    }
                    
                    // chunk length
                    guard var chunkLength = (try? parser.read(bytes: 4))?
                        .toUInt32(from: .bigEndian)
                    else {
                        let offsetString = parser.readOffset.hexString(prefix: true)
                        throw .malformed(
                            "There was a problem reading chunk length at byte offset \(offsetString)"
                        )
                    }
                    
                    // grab body data offset
                    let dataBodyOffset = parser.readOffset
                    
                    // advance parser
                    var discard = false
                    do throws(MIDIFileDecodeError) {
                        try parser.toMIDIFileDecodeError(
                            malformedReason: "There was a problem reading data while parsing the chunk that starts at byte offset \(chunkStartByteOffset.hexString(prefix: true)). Attempted to read byte offset \((parser.readOffset + Int(chunkLength)).hexString(prefix: true)) but encountered end of file early.",
                            try parser.seek(by: Int(chunkLength))
                        )
                    } catch {
                        // not enough bytes - EOF reached
                        switch options.trackDecodeOptions.errorStrategy {
                        case .allowLossyRecovery:
                            // fix chunk length to end at the last byte available
                            chunkLength = UInt32(exactly: parser.remainingByteCount.clamped(to: 0...)) ?? 0
                            isParsing = false
                        case .discardTracksWithErrors:
                            discard = true
                            isParsing = false
                        case .throwOnError:
                            throw error
                        }
                    }
                    
                    // append chunk descriptor
                    if !discard {
                        let chunkDescriptor = ChunkDescriptor(
                            identifier: identifier.wrapped,
                            startOffset: chunkStartByteOffset,
                            bodyByteStartOffset: dataBodyOffset,
                            bodyByteLength: Int(chunkLength)
                        )
                        chunkDescriptors.append(chunkDescriptor)
                    }
                } catch {
                    // a parsing error here could be a legitimately malformed file. however, if there's
                    // more bytes remaining but we've already parsed all of the expected tracks,
                    // then as long as `ignoreBytesPastEOF` is true we will ignore any spurious bytes
                    // that follow that are not properly encoded chunks.
                    // if `ignoreBytesPastEOF` is false, then consider the file malformed and throw the error.
                    if chunkDescriptors.filter({ $0.identifier == .track }).count == expectedTrackCount,
                       isParsing,
                       options.ignoreBytesPastEOF
                    {
                        isParsing = false
                    } else {
                        // rethrow the error
                        throw error
                    }
                }
                
                // test for end of file
                if parser.readOffset >= fileData.count {
                    isParsing = false
                }
            }
            
            return FileDescriptor(header: header, chunkDescriptors: chunkDescriptors)
        }
    }
    
    static func parseChunk(
        chunkDescriptor: ChunkDescriptor,
        chunkIndex: Int,
        timebase: Timebase,
        options: MIDIFileTrackDecodeOptions,
        in chunkData: some DataProtocol
    ) throws(MIDIFileDecodeError) -> MIDIFile.AnyChunk? {
        do throws(MIDIFileDecodeError) {
            switch chunkDescriptor.identifier {
            case is MIDIFile.TrackChunk.Identifier:
                let track = try MIDIFile.TrackChunk(
                    midi1SMFRawBytes: chunkData,
                    timebase: timebase,
                    options: options
                )
                return if let track { .track(track) } else { nil }
                
            case let identifier as MIDIFile.UndefinedChunk.Identifier:
                // as per Standard MIDI File 1.0 Spec:
                // undefined chunks should be skipped and not throw an error
                
                let newUndefinedChunk = MIDIFile.UndefinedChunk(
                    identifier: identifier,
                    data: chunkData.toData()
                )
                return .undefined(newUndefinedChunk)
                
            default:
                // TODO: this is where we would handle custom chunks implemented by end-users
                assertionFailure("Unhandled chunk identifier: \(chunkDescriptor.identifier.string)")
                return nil
            }
        } catch {
            // append some context for the error and rethrow it
            switch error {
            case let .malformed(verboseError):
                let offsetString = chunkDescriptor.startOffset.hexString(prefix: true)
                throw .malformed(
                    "There was a problem reading track data at byte offset \(offsetString) for chunk index \(chunkIndex). \(verboseError)"
                )
                
            default:
                throw error
            }
        }
    }
}
