//
//  Types.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

/// Universal MIDI Packet Word: Type representing four 8-bit bytes.
public typealias UMPWord = UInt32

// note: this is a duplicate typealias to allow MIDIKitInternals to use it.
// see /MIDIKitCore/Types/UMPWord.swift for extensions
