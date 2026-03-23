//
//  AnyMIDIFileHeaderChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
internal import MIDIKitInternals
internal import SwiftDataParsing

public struct AnyMIDIFileHeaderChunk {
    /// MIDI file format.
    public var format: MIDIFileFormat
    
    /// MIDI file timebase (for duration calculations).
    public var timebase: AnyMIDIFileTimebase
    
    /// Additional bytes found at the end of the header. Typically this should be left empty.
    ///
    /// The Standard MIDI File spec allows for additional bytes at the end of the file header.
    /// Technically additional bytes should only be used if they are defined at some point in
    /// a revision to the Standard MIDI File spec. However, until such event happens, file parsers
    /// should preserve and ignore these bytes.
    public var additionalBytes: Data? = nil
    
    public init(
        format: MIDIFileFormat = .multipleTracksSynchronous,
        timebase: AnyMIDIFileTimebase = .default()
    ) {
        self.format = format
        self.timebase = timebase
        self.additionalBytes = nil
    }
    
    public init(
        format: MIDIFileFormat = .multipleTracksSynchronous,
        timebase: AnyMIDIFileTimebase = .default(),
        additionalBytes: (some DataProtocol)?
    ) {
        self.format = format
        self.timebase = timebase
        self.additionalBytes = if let additionalBytes { Data(additionalBytes) } else { nil }
    }
}

extension AnyMIDIFileHeaderChunk: Equatable { }

extension AnyMIDIFileHeaderChunk: Hashable { }

extension AnyMIDIFileHeaderChunk: Sendable { }
