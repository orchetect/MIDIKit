//
//  MIDIPacketList PacketListIterator.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI
@_implementationOnly import MIDIKitC

/// aka `UnsafePointer<MIDIPacketList>`
/// allows iteration on the pointer directly, ie:
///
///     func parse(_ ptr: UnsafePointer<MIDIPacketList>) {
///         for packet in ptr {
///             // ...
///         }
///     }
///
/// This must be performed on the `UnsafePointer` returned by CoreMIDI and not on `.pointee` (concrete `CoreMIDI` `MIDIPacketList`) to avoid `CoreMIDI`-related crashes.
///
/// See the workaround `safePacketUnwrapper` method for more details.
extension UnsafePointer: Sequence where Pointee == MIDIPacketList {
    
    public typealias Element = MIDI.Packet.PacketData
    
    public typealias Iterator = PacketListIterator
    
    /// Create a generator from the packet list
    @inline(__always) public func makeIterator() -> Iterator {
        
        Iterator(self)
        
    }
    
    /// Custom iterator to iterate `MIDIPacket`s within a `CoreMIDI` `MIDIPacketList`.
    public struct PacketListIterator: IteratorProtocol {
        
        public typealias Element = MIDI.Packet.PacketData
        
        var index = 0
        
        var packets: [Element] = []
        
        /// Initialize the packet list generator with a packet list
        /// - Parameter packetList: MIDI Packet List
        @inline(__always) public init(_ packetListPtr: UnsafePointer<MIDIPacketList>) {
            
            // Call custom C method wrapping MIDIPacketNext
            // This workaround is needed due to a variety of crashes that can occur when either the thread sanitizer is on, or large/malformed MIDI packet lists / packets arrive
            
            CMIDIPacketListIterate(packetListPtr) {
                guard let unwrappedPtr = $0 else { return }
                packets.append(safePacketUnwrapper(unwrappedPtr))
            }
            
        }
        
        @inline(__always) public mutating func next() -> Element? {
            
            guard !packets.isEmpty else { return nil }
            
            guard index < packets.count else { return nil }
            
            defer { index += 1 }
            
            return packets[index]
            
        }
        
    }
    
    @inline(__always) fileprivate
    static let midiPacketDataOffset: Int = MemoryLayout.offset(of: \MIDIPacket.data)!
    
    @inline(__always) fileprivate
    static func safePacketUnwrapper(_ packetPtr: UnsafePointer<MIDIPacket>) -> MIDI.Packet.PacketData {
        
        let packetDataCount = Int(packetPtr.pointee.length)
        
        guard packetDataCount > 0 else {
            return MIDI.Packet.PacketData(
                bytes: [],
                timeStamp: packetPtr.pointee.timeStamp
            )
        }
        
        // Access the raw memory instead of using the .pointee
        // This workaround is needed due to a variety of crashes that can occur when either the thread sanitizer is on, or large/malformed MIDI packet lists / packets arrive
        let rawMIDIPacketDataPtr = UnsafeRawBufferPointer(
            start: UnsafeRawPointer(packetPtr) + midiPacketDataOffset,
            count: packetDataCount
        )
        
        return MIDI.Packet.PacketData(
            bytes: Array<MIDI.Byte>(rawMIDIPacketDataPtr),
            timeStamp: packetPtr.pointee.timeStamp
        )
        
    }
    
}
