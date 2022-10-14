//
//  MIDIPacketList Packets.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
@_implementationOnly import CoreMIDI

extension UnsafePointer where Pointee == CoreMIDI.MIDIPacketList {
    /// Internal:
    /// Returns array of MIDIKit ``MIDIPacketData`` instances.
    internal func packets(
        refCon: UnsafeMutableRawPointer?
    ) -> [MIDIPacketData] {
        if pointee.numPackets == 0 {
            return []
        }
    
        // prefer newer Core MIDI API if platform supports it
    
        if #available(macOS 10.15, iOS 13.0, macCatalyst 13.0, *) {
            return unsafeSequence().map {
                MIDIPacketData($0, refCon: refCon)
            }
        } else {
            var packetDatas: [MIDIPacketData] = []
            pointee.forEachPacket {
                packetDatas.append(MIDIPacketData($0, refCon: refCon))
            }
            return packetDatas
        }
    }
}

extension CoreMIDI.MIDIPacketList {
    /// Iterates packets in a `MIDIPacketList` and calls the closure for each packet.
    /// This is confirmed working on Mojave.
    /// There were numerous difficulties in reading `MIDIPacketList` on Mojave and earlier and this solution was stable.
    fileprivate func forEachPacket(_ closure: (UnsafeMutablePointer<MIDIPacket>) -> Void) {
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
