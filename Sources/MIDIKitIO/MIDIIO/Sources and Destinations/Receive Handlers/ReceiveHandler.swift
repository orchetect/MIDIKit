//
//  ReceiveHandler.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-22.
//

import CoreMIDI

@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

public protocol MIDIIOReceiveHandler {
	
	func midiReadBlock(
		_ packetListPtr: UnsafePointer<MIDIPacketList>,
		_ srcConnRefCon: UnsafeMutableRawPointer?
	)
	
}

extension MIDIIO {
	
	public struct ReceiveHandler {
		
		public var handler: MIDIIOReceiveHandler
		
		public func midiReadBlock(
			_ packetListPtr: UnsafePointer<MIDIPacketList>,
			_ srcConnRefCon: UnsafeMutableRawPointer?
		) {
			
			handler.midiReadBlock(packetListPtr, srcConnRefCon)
			
		}
		
		public init(_ handler: MIDIIOReceiveHandler) {
			
			self.handler = handler
			
		}
		
	}
	
}

extension MIDIIO.ReceiveHandler {
	
	public static func basic(
		_ handler: @escaping Basic.Handler
	) -> Self {
		
		Self(Basic(handler))
		
	}
	
	public static func rawDataLogging(
		filterActiveSensing: Bool = false,
		_ handler: RawDataLogging.Handler? = nil
	) -> Self {
		
		Self(RawDataLogging(filterActiveSensing: filterActiveSensing,
							handler))
		
	}
	
}

extension MIDIIO.ReceiveHandler {
	
	public struct Basic: MIDIIOReceiveHandler {
		
		public typealias Handler = (_ packets: [MIDIPacketData]) -> Void
		
		public var handler: Handler
		
		public func midiReadBlock(
			_ packetListPtr: UnsafePointer<MIDIPacketList>,
			_ srcConnRefCon: UnsafeMutableRawPointer?
		) {
			
			let packets = packetListPtr.pointee
				.map { $0.packetData }
			
			handler(packets)
			
		}
		
		public init(
			_ handler: @escaping Handler
		) {
			
			self.handler = handler
			
		}
		
	}
	
	public struct RawDataLogging: MIDIIOReceiveHandler {
		
		public typealias Handler = (_ eventDescription: String) -> Void
		
		public var handler: Handler
		
		public var filterActiveSensing = false
		
		public func midiReadBlock(
			_ packetListPtr: UnsafePointer<MIDIPacketList>,
			_ srcConnRefCon: UnsafeMutableRawPointer?
		) {
			
			for packet in packetListPtr.pointee {
				
				let bytes = packet.packetData.array
				
				if filterActiveSensing {
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
			filterActiveSensing: Bool = false,
			_ handler: Handler? = nil
		) {
			
			self.filterActiveSensing = filterActiveSensing
			
			self.handler = handler ?? { eventDescription in
				Log.debug(eventDescription)
			}
			
		}
		
	}
	
}
