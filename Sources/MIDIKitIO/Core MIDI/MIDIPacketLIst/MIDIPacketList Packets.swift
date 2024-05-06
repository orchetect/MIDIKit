//
//  MIDIPacketList Packets.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if compiler(>=5.10)
/* private */ import CoreMIDI
#else
@_implementationOnly import CoreMIDI
#endif

#if compiler(>=5.10)
/* private */ import MIDIKitInternals
#else
@_implementationOnly import MIDIKitInternals
#endif

extension UnsafePointer where Pointee == CoreMIDI.MIDIPacketList {
    /// Internal:
    /// Returns array of MIDIKit ``MIDIPacketData`` instances.
    func packets(
        refCon: UnsafeMutableRawPointer?,
        refConKnown: Bool
    ) -> [MIDIPacketData] {
        if pointee.numPackets == 0 {
            return []
        }
    
        // prefer newer Core MIDI API if platform supports it
    
        if #available(macOS 10.15, iOS 13.0, macCatalyst 13.0, *) {
            return unsafeSequence().map {
                MIDIPacketData($0, refCon: refCon, refConKnown: refConKnown)
            }
        } else {
            var packetDatas: [MIDIPacketData] = []
            pointee.packetPointerIterator {
                packetDatas.append(MIDIPacketData($0, refCon: refCon, refConKnown: refConKnown))
            }
            return packetDatas
        }
    }
}

#endif
