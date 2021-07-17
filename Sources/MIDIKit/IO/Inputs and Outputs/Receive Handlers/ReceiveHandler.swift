//
//  ReceiveHandler.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import CoreMIDI

@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

// MARK: - MIDIIOReceiveHandlerProtocol

public protocol MIDIIOReceiveHandlerProtocol {
	
	@inline(__always) func midiReadBlock(
		_ packetListPtr: UnsafePointer<MIDIPacketList>,
		_ srcConnRefCon: UnsafeMutableRawPointer?
	)
	
}

// MARK: - ReceiveHandler

extension MIDI.IO {
	
	public struct ReceiveHandler: MIDIIOReceiveHandlerProtocol {
		
		public typealias Handler = (_ packets: [MIDI.PacketData]) -> Void
		
		@inline(__always) public var handler: MIDIIOReceiveHandlerProtocol
		
		@inline(__always) public func midiReadBlock(
			_ packetListPtr: UnsafePointer<MIDIPacketList>,
			_ srcConnRefCon: UnsafeMutableRawPointer?
		) {
			
			handler.midiReadBlock(packetListPtr, srcConnRefCon)
			
		}
		
		public init(_ handler: MIDIIOReceiveHandlerProtocol) {
			
			self.handler = handler
			
		}
		
	}
	
}

// MARK: - Inline initializers

extension MIDI.IO.ReceiveHandler {
	
	/// Returns a new `SeriesGroup` receive handler instance.
	public static func seriesGroup(
		_ handlers: [MIDI.IO.ReceiveHandler]
	) -> Self {
		
		Self(SeriesGroup(handlers))
		
	}
	
	/// Returns a new `RawData` receive handler instance.
	public static func rawData(
		_ handler: @escaping RawData.Handler
	) -> Self {
		
		Self(RawData(handler))
		
	}
	
	/// Returns a new `RawDataLogging` receive handler instance.
	public static func rawDataLogging(
		filterActiveSensingAndClock: Bool = false,
		_ handler: RawDataLogging.Handler? = nil
	) -> Self {
		
		Self(RawDataLogging(filterActiveSensingAndClock: filterActiveSensingAndClock,
							handler))
		
	}
	
}

// MARK: - Pre-fab ReceiveHandlers

extension MIDI.IO.ReceiveHandler {
	
	/// Receive handler group.
	/// Can contain one or more `ReceiveHandler`s in series.
	public struct SeriesGroup: MIDIIOReceiveHandlerProtocol {
		
		public var handlers: [MIDI.IO.ReceiveHandler] = []
		
		@inline(__always) public func midiReadBlock(
			_ packetListPtr: UnsafePointer<MIDIPacketList>,
			_ srcConnRefCon: UnsafeMutableRawPointer?
		) {
			
			handlers.forEach { $0.midiReadBlock(packetListPtr, srcConnRefCon) }
			
		}
		
		public init(_ handlers: [MIDI.IO.ReceiveHandler]) {
			
			self.handlers = handlers
			
		}
		
	}
	
}

extension MIDI.IO.ReceiveHandler {
	
	/// Basic raw packet data receive handler.
	public struct RawData: MIDIIOReceiveHandlerProtocol {
		
		public typealias Handler = (_ packet: MIDI.PacketData) -> Void
		
		@inline(__always) public var handler: Handler
		
		@inline(__always) public func midiReadBlock(
			_ packetListPtr: UnsafePointer<MIDIPacketList>,
			_ srcConnRefCon: UnsafeMutableRawPointer?
		) {
			
			packetListPtr.forEach { handler($0) }
			
		}
		
		public init(
			_ handler: @escaping Handler
		) {
			
			self.handler = handler
			
		}
		
	}
	
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
			
			for packet in packetListPtr {
				
				let bytes = packet.data
				
				if filterActiveSensingAndClock {
					guard bytes.first != 0xF8, // midi clock pulse
						  bytes.first != 0xFE  // active sensing
					else { continue }
				}
				
				let stringOutput =
					bytes.hex
					.stringValues(padTo: 2, prefixes: false)
					.joined(separator: " ")
				
				handler(stringOutput)
				
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
		
	}
	
}
