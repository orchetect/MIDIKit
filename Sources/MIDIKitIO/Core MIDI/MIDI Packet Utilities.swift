//
//  MIDI Packet Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation
@_implementationOnly import CoreMIDI

/// Utility:
/// Attempts to extract data from a refCon pointer supplied by `CoreMIDI.MIDIReceiveBlock` and `CoreMIDI.MIDIReadBlock` identifying the sender of the event packets.
///
/// This pointer is untyped and Optional, and is not expected to contain data of any certain type unless is it a refCon that is created by MIDIKit.
internal func unpackMIDIRefCon(
    refCon: UnsafeMutableRawPointer?,
    known: Bool
) -> MIDIOutputEndpoint? {
    // we can only safely use refCons that we set originally
    guard known else { return nil }
    
    guard let refCon = refCon else { return nil }
    
    // note that this is only stable if we already know
    // that this is the pointer type, which is guaranteed
    // if it originates from MIDIInputConnection
    let srcRefNS = Unmanaged<NSNumber>.fromOpaque(refCon).takeUnretainedValue()
    let srcRef = UInt32(truncating: srcRefNS)
    
    // filter out invalid ref data
    let uID = getUniqueID(of: srcRef)
    guard uID != .invalidMIDIIdentifier else { return nil }

    return MIDIOutputEndpoint(from: srcRef)
}
