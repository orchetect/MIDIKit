//
//  AnyMIDIFile+Encoding.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore

extension AnyMIDIFile {
    /// Returns encoded raw MIDI file data.
    /// Throws an error if a problem occurs.
    public func rawData() throws(MIDIFileEncodeError) -> Data {
        switch self {
        case let .musical(midiFile): try midiFile.rawData()
        case let .smpte(midiFile): try midiFile.rawData()
        }
    }
    
    /// Returns encoded raw MIDI file data.
    /// Throws an error if a problem occurs.
    public func rawData<D: MutableDataProtocol>(as dataType: D.Type) throws(MIDIFileEncodeError) -> D {
        switch self {
        case let .musical(midiFile): try midiFile.rawData(as: dataType)
        case let .smpte(midiFile): try midiFile.rawData(as: dataType)
        }
    }
    
    /// Returns encoded raw MIDI file data, encoding chunks concurrently for improved performance.
    /// Throws an error if a problem occurs.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func rawData() async throws(MIDIFileEncodeError) -> Data {
        switch self {
        case let .musical(midiFile): try await midiFile.rawData()
        case let .smpte(midiFile): try await midiFile.rawData()
        }
    }
    
    /// Returns encoded raw MIDI file data, encoding chunks concurrently for improved performance.
    /// Throws an error if a problem occurs.
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public func rawData<D: MutableDataProtocol & Sendable>(as dataType: D.Type) async throws(MIDIFileEncodeError) -> D {
        switch self {
        case let .musical(midiFile): try await midiFile.rawData(as: dataType)
        case let .smpte(midiFile): try await midiFile.rawData(as: dataType)
        }
    }
}
