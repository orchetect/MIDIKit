//
//  MIDIFile.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

private let fileManager = FileManager.default

/// Standard MIDI Files (SMF) object. Read or write MIDI file contents.
public struct MIDIFile: Equatable {
    // MARK: - Properties
        
    internal var header: Chunk.Header = .init()
        
    /// MIDI File Format to use when writing MIDI file.
    public var format: Format {
        get { header.format }
        set { header.format = newValue }
    }
        
    /// Specify whether the MIDI file stores time values in bars & beats (musical) or timecode
    public var timeBase: TimeBase {
        get { header.timeBase }
        set { header.timeBase = newValue }
    }
        
    /// Storage for tracks in the MIDI file
    public var chunks: [Chunk] = []
        
    // MARK: - Init
        
    /// Initialize with default values.
    public init() { }
        
    /// Initialize by loading the contents of a MIDI file's raw data.
    public init(rawData: Data) throws {
        try decode(rawData: rawData)
    }
        
    /// Initialize by loading the contents of a MIDI file from disk.
    public init(midiFile path: String) throws {
        guard fileManager.fileExists(atPath: path) else {
            throw DecodeError.fileNotFound
        }
            
        guard let url = URL(string: path) else {
            throw DecodeError.malformedURL
        }
            
        try self.init(midiFile: url)
    }
        
    /// Initialize by loading the contents of a MIDI file from disk.
    public init(midiFile url: URL) throws {
        let data = try Data(contentsOf: url)
            
        try decode(rawData: data)
    }
        
    /// Returns raw MIDI file data. Throws an error if a problem occurs.
    public func rawData() throws -> Data {
        try encode()
    }
}
