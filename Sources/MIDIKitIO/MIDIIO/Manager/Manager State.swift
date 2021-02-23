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
		
		let status = MIDIClientCreateWithBlock(clientName as CFString, &clientRef)
		{ [weak self] notificationPtr in
			guard let self = self else { return }
			self.notificationHandler(notificationPtr)
		}
		
		guard status == noErr else {
			throw MIDIIO.OSStatusResult(rawValue: status)
		}
		
	}
	
	internal func notificationHandler(_ pointer: UnsafePointer<MIDINotification>) {
		
		let notification = Notification(pointer)
		
		switch notification {
		case .added, .removed:
			
			// refresh internal states of all sources and destinations
			// and reconnect any disconnected connections if an endpoint has reappeared
			
			for source in connectedSources.values {
				_ = try? source.refreshConnection(self)
			}
			
			for destination in connectedDestinations.values {
				_ = try? destination.refreshConnection(self)
			}
			
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

