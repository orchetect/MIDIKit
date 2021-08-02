//
//  Group.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

extension MIDI.IO.ReceiveHandler {
    
    /// `ReceiveHandler` group.
    /// Can contain one or more `ReceiveHandler` in series.
    public struct Group: MIDIIOReceiveHandlerProtocol {
        
        public var receiveHandlers: [MIDI.IO.ReceiveHandler] = []
        
        @inline(__always) public func midiReadBlock(
            _ packetListPtr: UnsafePointer<MIDIPacketList>,
            _ srcConnRefCon: UnsafeMutableRawPointer?
        ) {
            
            receiveHandlers.forEach {
                $0.midiReadBlock(packetListPtr, srcConnRefCon)
            }
            
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public func midiReceiveBlock(
            _ eventListPtr: UnsafePointer<MIDIEventList>,
            _ srcConnRefCon: UnsafeMutableRawPointer?
        ) {
            
            receiveHandlers.forEach {
                $0.midiReceiveBlock(eventListPtr, srcConnRefCon)
            }
            
        }
        
        public init(_ receiveHandlers: [MIDI.IO.ReceiveHandler]) {
            
            self.receiveHandlers = receiveHandlers
            
        }
        
    }
    
}
