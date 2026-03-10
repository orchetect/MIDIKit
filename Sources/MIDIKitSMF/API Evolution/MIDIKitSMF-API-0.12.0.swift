//
//  MIDIKitSMF-API-0.12.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

// MARK: - MIDIFile.TimeBase

extension MIDIFile.TimeBase {
    @_documentation(visibility: internal)
    @available(*, deprecated, renamed: "init(rawData:)")
    public init?(rawBytes bytes: [UInt8]) { self.init(rawData: bytes) }
}
