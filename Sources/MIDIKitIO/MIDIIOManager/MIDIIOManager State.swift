//
//  MIDIIOManager State.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import Foundation
import CoreMIDI

extension MIDIIOManager {
	
	/// Starts the manager and registers itself with the CoreMIDI subsystem.
	/// Call this method once after initializing a new instance.
	public func start() throws {
		
		let status = MIDIClientCreateWithBlock(clientName as CFString, &clientRef)
		{ [weak self] notificationPtr in
			guard let self = self else { return }
			self.notificationHandler(notificationPtr)
		}
		
		guard status == noErr else {
			throw OSStatusResult(rawValue: status)
		}
		
	}
	
	internal func notificationHandler(_ pointer: UnsafePointer<MIDINotification>) {
		
		let notification = Notification(pointer)
		
		#warning("> handle notifications")
		
		switch notification {
		case .setupChanged:
			break
			
		case .added(let parent, let parentType, let child, let childType):
			break
			
		case .removed(let parent, let parentType, let child, let childType):
			break
			
		case .propertyChanged(let ref, let refType, let propertyName):
			break
			
		case .thruConnectionChanged:
			break
			
		case .serialPortOwnerChanged:
			break
			
		case .ioError(let device, let error):
			break
			
		case .other(let messageIDrawValue):
			break
			
		}
		
	}
	
}

