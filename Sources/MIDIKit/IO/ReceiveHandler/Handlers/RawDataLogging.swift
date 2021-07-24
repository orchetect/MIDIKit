//
//  RawDataLogging.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

extension MIDI.IO.ReceiveHandler {
    
    /// Raw data logging handler (hex byte strings).
    /// If `handler` is nil, all raw packet data is logged to the console (but only in DEBUG builds, not in RELEASE builds).
    /// If `handler` is provided, the hex byte string is supplied as a parameter and not automatically logged.
    public struct RawDataLogging: MIDIIOReceiveHandlerProtocol {
        
        public typealias Handler = (_ packetBytesString: String) -> Void
        
        @inline(__always) public var handler: Handler
        
        @inline(__always) public var filterActiveSensingAndClock = false
        
        @inline(__always) public func midiReadBlock(
            _ packetListPtr: UnsafePointer<MIDIPacketList>,
            _ srcConnRefCon: UnsafeMutableRawPointer?
        ) {
            
            packetListPtr.mkUnsafeSequence().forEach { midiPacketPacketPtr in
                let packetData = MIDI.Packet.PacketData(midiPacketPacketPtr)
                handleBytes(packetData.bytes)
            }
            
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public func midiReceiveBlock(
            _ eventListPtr: UnsafePointer<MIDIEventList>,
            _ srcConnRefCon: UnsafeMutableRawPointer?
        ) {
            
            eventListPtr.unsafeSequence().forEach { universalMIDIPacketPtr in
                let universalPacketData = MIDI.Packet.UniversalPacketData(universalMIDIPacketPtr)
                handleBytes(universalPacketData.bytes)
            }
            
        }
        
        public init(
            filterActiveSensingAndClock: Bool = false,
            _ handler: Handler? = nil
        ) {
            
            self.filterActiveSensingAndClock = filterActiveSensingAndClock
            
            self.handler = handler ?? { packetBytesString in
                Log.debug(packetBytesString)
            }
            
        }
        
        internal func handleBytes(_ bytes: [MIDI.Byte]) {
            
            if filterActiveSensingAndClock {
                guard bytes.first != 0xF8, // midi clock pulse
                      bytes.first != 0xFE  // active sensing
                else { return }
            }
            
            let stringOutput =
                bytes.hex
                .stringValues(padTo: 2, prefixes: false)
                .joined(separator: " ")
            
            handler(stringOutput)
            
        }
        
    }
    
}
