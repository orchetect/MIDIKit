//
//  MIDIEventList Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import CoreMIDI

extension CoreMIDI.MIDIEventList {
    /// Assembles a Core MIDI `MIDIEventList` containing single Core MIDI `MIDIEventPacket` from a Universal MIDI Packet
    /// `UInt32` word.
    @_disfavoredOverload @inlinable
    @available(macOS 11, iOS 14, macCatalyst 14, *)
    public init(
        protocol midiProtocol: CoreMIDI.MIDIProtocolID,
        packetWords: [UInt32],
        timeStamp: UInt64 = mach_absolute_time()
    ) throws {
        let packet = try CoreMIDI.MIDIEventPacket(
            words: packetWords,
            timeStamp: timeStamp
        )
    
        self = CoreMIDI.MIDIEventList(
            protocol: midiProtocol,
            numPackets: 1,
            packet: packet
        )
    }
}

#endif
