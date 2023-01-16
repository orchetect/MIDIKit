//
//  MIDIPacketList Packets.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import CoreMIDI

extension CoreMIDI.MIDIPacketList {
    /// Iterates packets in a `MIDIPacketList` and calls the closure for each packet.
    /// This is confirmed working on macOS Mojave thru macOS Ventura.
    /// There were numerous difficulties in reading `MIDIPacketList` on Mojave and earlier and this
    /// solution was stable.
    @_disfavoredOverload
    public func packetPointerIterator(_ closure: (UnsafeMutablePointer<MIDIPacket>) -> Void) {
        withUnsafePointer(to: packet) { ptr in
            var idx: UInt32 = 0
            var p = UnsafeMutablePointer(mutating: ptr)
            while idx < numPackets {
                closure(p)
                if numPackets - idx > 0 { p = MIDIPacketNext(p) }
                idx += 1
            }
        }
    }
}

#endif
