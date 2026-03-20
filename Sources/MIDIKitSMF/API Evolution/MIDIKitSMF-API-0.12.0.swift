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
        chunks: [AnyChunk] = []
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

// MARK: - MIDIFile.AnyChunk

extension MIDIFile {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "AnyChunk")
    public typealias Chunk = AnyChunk
}

extension MIDIFile.AnyChunk {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "HeaderChunk")
    public typealias Header = MIDIFile.HeaderChunk
}

// MARK: - MIDIFile.HeaderChunk

extension MIDIFile.HeaderChunk {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "timebase")
    public var timeBase: MIDIFile.Timebase { timebase }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(format:timebase:)")
    @_disfavoredOverload
    public init(
        format: MIDIFile.Format,
        timeBase: MIDIFile.Timebase
    ) {
        self.init(format: format, timebase: timeBase)
    }
}

extension MIDIFile.AnyChunk.Track {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "eventsAtQuarterNotePositions(atPPQ:)")
    @_disfavoredOverload
    public func eventsAtBeatPositions(ppq: UInt16) -> [(beat: Double, event: MIDIFileEvent)] {
        eventsAtQuarterNotePositions(atPPQ: ppq)
    }
}

// MARK: - MIDIFile.AnyChunk.UnrecognizedChunk

extension MIDIFile.AnyChunk.UnrecognizedChunk {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(identifier:data:)")
    @_disfavoredOverload
    public init(id: String, rawData: Data? = nil) {
        self.init(identifier: .init(lossy: id), data: rawData)
    }
}

extension MIDIFile.AnyChunk {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "unrecognized(identifier:data:)")
    @_disfavoredOverload
    public static func other(id: String, rawData: Data? = nil) -> Self {
        .unrecognized(.init(identifier: .init(lossy: id), data: rawData))
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "unrecognized(_:)")
    @_disfavoredOverload
    public static func other(_ chunk: UnrecognizedChunk) -> Self {
        .unrecognized(chunk)
    }
}

// MARK: - MIDIFile.Timebase

extension MIDIFile.Timebase {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(data:)")
    @_disfavoredOverload
    public init?(rawBytes bytes: [UInt8]) {
        self.init(data: bytes)
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(data:)")
    @_disfavoredOverload
    public init?(rawData data: some DataProtocol) {
        self.init(data: data)
    }
}

// MARK: - MIDIFileEvent.DeltaTime

extension MIDIFileEvent.DeltaTime {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(ticks:)")
    @_disfavoredOverload
    public init?(
        ticks: UInt32,
        using timebase: MIDIFile.Timebase
    ) {
        self.init(ticks: ticks)
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "ticks")
    @_disfavoredOverload
    public func ticksValue(using timebase: MIDIFile.Timebase) -> UInt32 {
        ticks
    }
}

// MARK: - MIDIFileEvent.KeySignature

extension MIDIFileEvent.KeySignature {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "isMajor")
    @_disfavoredOverload
    public var majorKey: Bool {
        isMajor
    }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(flatsOrSharps:isMajor:)")
    @_disfavoredOverload
    public init(
        flatsOrSharps: Int8,
        majorKey: Bool
    ) {
        self = Self(flatsOrSharps: flatsOrSharps, isMajor: majorKey) ?? .cMajor
    }
}

extension MIDIFileEvent {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "keySignature(delta:flatsOrSharps:isMajor:)")
    @_disfavoredOverload
    public static func keySignature(
        delta: DeltaTime = .none,
        flatsOrSharps: Int8,
        majorKey: Bool
    ) -> Self {
        .keySignature(delta: delta, flatsOrSharps: flatsOrSharps, isMajor: majorKey)
            ?? .keySignature(delta: delta, event: .cMajor)
    }
}
