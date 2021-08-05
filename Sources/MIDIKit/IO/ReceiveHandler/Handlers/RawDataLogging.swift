//
//  RawDataLogging.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

@_implementationOnly import SwiftRadix
import os.log

extension MIDI.IO.ReceiveHandler {
    
    /// Raw data logging handler (hex byte strings).
    /// If `handler` is nil, all raw packet data is logged to the console (but only in DEBUG builds, not in RELEASE builds).
    /// If `handler` is provided, the hex byte string is supplied as a parameter and not automatically logged.
    public class RawDataLogging: MIDIIOReceiveHandlerProtocol {
        
        public typealias Handler = (_ packetBytesString: String) -> Void
        
        @inline(__always) public var handler: Handler
        
        @inline(__always) public var filterActiveSensingAndClock = false
        
        @inline(__always) public func midiReadBlock(
            _ packetListPtr: UnsafePointer<MIDIPacketList>,
            _ srcConnRefCon: UnsafeMutableRawPointer?
        ) {
            
            for midiPacketPacketPtr in packetListPtr.mkUnsafeSequence() {
                let packetData = MIDI.Packet.PacketData(midiPacketPacketPtr)
                handleBytes(packetData.bytes)
            }
            
        }
        
        @available(macOS 11, iOS 14, macCatalyst 14, tvOS 14, watchOS 7, *)
        @inline(__always) public func midiReceiveBlock(
            _ eventListPtr: UnsafePointer<MIDIEventList>,
            _ srcConnRefCon: UnsafeMutableRawPointer?
        ) {
            
            for universalMIDIPacketPtr in eventListPtr.unsafeSequence() {
                let universalPacketData = MIDI.Packet.UniversalPacketData(universalMIDIPacketPtr)
                handleBytes(universalPacketData.bytes)
            }
            
        }
        
        internal init(
            filterActiveSensingAndClock: Bool = false,
            _ handler: Handler? = nil
        ) {
            
            self.filterActiveSensingAndClock = filterActiveSensingAndClock
            
            self.handler = handler ?? { packetBytesString in
                #if DEBUG
                os_log("%{public}@",
                       log: OSLog.default,
                       type: .debug,
                       packetBytesString)
                #endif
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
