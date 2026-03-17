//
//  MIDIKitSMF-API-0.12.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation

// MARK: - MIDIFile

extension MIDIFile {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "Timebase")
    public typealias TimeBase = Timebase
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "timebase")
    public var timeBase: Timebase { timebase }
}

extension MIDIFile {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(format:timebase:chunks:)")
    @_disfavoredOverload
    public init(
        format: Format = .multipleTracksSynchronous,
        timeBase: Timebase = .default(),
        chunks: [Chunk] = []
    ) {
        self.init(format: format, timebase: timeBase, chunks: chunks)
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(data:)")
    @_disfavoredOverload
    public init(
        rawData: Data
    ) throws {
        try self.init(data: rawData)
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(path:)")
    @_disfavoredOverload
    public init(
        midiFile path: String
    ) throws {
        try self.init(path: path)
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(url:)")
    @_disfavoredOverload
    public init(
        midiFile url: URL
    ) throws {
        try self.init(url: url)
    }
}

extension MIDIFile.Chunk.Header {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "timebase")
    public var timeBase: MIDIFile.Timebase { timebase }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(format:timebase:)")
    public init(
        format: MIDIFile.Format,
        timeBase: MIDIFile.Timebase
    ) {
        self.init(format: format, timebase: timeBase)
    }
}

// MARK: - MIDIFile.Timebase

extension MIDIFile.Timebase {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(rawData:)")
    public init?(rawBytes bytes: [UInt8]) { self.init(rawData: bytes) }
}
