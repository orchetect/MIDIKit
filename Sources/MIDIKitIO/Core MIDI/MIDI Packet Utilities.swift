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
/// This pointer is untyped and Optional, and is not expected to contain data of any certain type unless is it a refcon that is created by MIDIKit.
internal func unpackMIDIRefCon(
    refCon: UnsafeMutableRawPointer?
) -> MIDIOutputEndpoint? {
    guard let refCon = refCon else { return nil }
    let srcRef = refCon.load(as: MIDIEndpointRef.self)
    
    // this may not be necessary but could help filter out invalid ref data
    let uID = getUniqueID(of: srcRef)
    guard uID != .invalidMIDIIdentifier else { return nil }
    
    return MIDIOutputEndpoint(from: srcRef)
}
