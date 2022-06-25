//
//  MIDIEventList Packets.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import CoreMIDI

@available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
extension UnsafePointer where Pointee == MIDIEventList {
    
    /// Internal:
    /// Returns array of MIDIKit `UniversalPacketData` instances.
    @inline(__always)
    internal func packets() -> [MIDI.IO.Packet.UniversalPacketData] {
        
        if pointee.numPackets == 0 {
            return []
        }
        
        let sequencedPackets = unsafeSequence()
            .map {
                (words: $0.sequence().map { $0 },
                 timeStamp: $0.pointee.timeStamp)
            }
        
        var packets: [MIDI.IO.Packet.UniversalPacketData] = []
        
        // using unsafeSequence() does not guarantee that each packet
        // only contains one UMP, it may contain multiple UMPs.
        // our solution is to manually parse the words and split them
        // into individual UMPs.
        
        for sequencedPacket in sequencedPackets {
            for umpWords in parse(packetWords: sequencedPacket.words) {
                let ump = MIDI.IO.Packet.UniversalPacketData(words: umpWords,
                                                          timeStamp: sequencedPacket.timeStamp)
                packets.append(ump)
            }
        }
        
        return packets
        
    }
    
    /// Internal:
    /// Parses an EventPacket's words and splits it into individual UMP messages.
    @inline(__always)
    fileprivate func parse(packetWords: [MIDI.UMPWord]) -> [[MIDI.UMPWord]] {
        
        guard !packetWords.isEmpty else { return [] }
        
        var results: [[MIDI.UMPWord]] = []
        
        var curWord = 0
        
        let wordsRemain = { packetWords.count - curWord }
        
        // iterate through words, chunking into UMPs based on
        // expected number of words for the UMP Message Type
        while curWord < packetWords.count {
            guard let mt = MIDI.Nibble(exactly: packetWords[curWord] >> 28),
                  let mtype = MIDI.IO.Packet.UniversalPacketData.MessageType(rawValue: mt),
                  wordsRemain() >= mtype.wordLength
            else { curWord = packetWords.count ; continue }
            
            let expectedWordCount = mtype.wordLength
            
            let umpWords = packetWords[curWord ..< curWord + expectedWordCount]
            
            results.append(Array(umpWords))
            
            curWord += expectedWordCount
        }
        
        return results
        
    }

}
