//
//  Manager State.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI

extension MIDIIO.Manager {
	
	/// Starts the manager and registers itself with the CoreMIDI subsystem.
	/// Call this method once after initializing a new instance.
	/// Subsequent calls will not have any effect.
	public func start() throws {
		
		// if start() was already called, return
		guard clientRef == MIDIClientRef() else { return }
		
		try MIDIClientCreateWithBlock(clientName as CFString, &clientRef)
		{ [weak self] notificationPtr in
			guard let self = self else { return }
			self.notificationHandler(notificationPtr)
		}
		.throwIfOSStatusErr()
		
		// initial cache of endpoints
		
		updateObjectsCache()
		
	}
	
	internal func notificationHandler(_ pointer: UnsafePointer<MIDINotification>) {
		
		let notification = InternalNotification(pointer)
		
		switch notification {
		case .setupChanged,
			 .added,
			 .removed,
			 .propertyChanged:
			
			updateObjectsCache()
			
		default:
			break
		}
		
		switch notification {
		case .setupChanged, .added, .removed:
			
			// refresh internal states of all outputs and inputs
			// and reconnect any disconnected connections if an endpoint has reappeared
			
			for outputConnection in managedOutputConnections.values {
				_ = try? outputConnection.refreshConnection(in: self)
			}
			
			for inputConnection in managedInputConnections.values {
				_ = try? inputConnection.refreshConnection(in: self)
			}
			
			// thru connections
			
		default:
			break
		}
		
//		switch notification {
//		case .setupChanged:
//			break
//
//		case .added(let parent, let parentType, let child, let childType):
//			break
//
//		case .removed(let parent, let parentType, let child, let childType):
//			break
//
//		case .propertyChanged(let ref, let refType, let propertyName):
//			break
//
//		case .thruConnectionChanged:
//			break
//
//		case .serialPortOwnerChanged:
//			break
//
//		case .ioError(let device, let error):
//			break
//
//		case .other(let messageIDrawValue):
//			break
//
//		}
		
	}
	
}

