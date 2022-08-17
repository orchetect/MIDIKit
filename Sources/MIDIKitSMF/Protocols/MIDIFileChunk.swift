//
//  MIDIFileChunk.swift
//  MIDIKitSMF • https://github.com/orchetect/MIDIKitSMF
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import struct SwiftASCII.ASCIIString

public protocol MIDIFileChunk {
    /// 4-character ASCII string identifying the chunk.
    ///
    /// For standard MIDI tracks, this is MTrk.
    /// For non-track chunks, any 4-character identifier can be used except for "MTrk".
    var identifier: ASCIIString { get }

    // TODO: add init from raw data, passing in midi header timing info etc.
}
