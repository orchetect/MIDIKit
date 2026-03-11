//
//  MIDIKitSMF-API-0.12.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "Timebase")
    public typealias TimeBase = Timebase
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "timebase")
    public var timeBase: Timebase { timebase }
    
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(format:timebase:chunks:)")
    public init(
        format: Format = .multipleTracksSynchronous,
        timeBase: Timebase = .default(),
        chunks: [Chunk] = []
    ) {
        self.init(format: format, timebase: timeBase, chunks: chunks)
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
