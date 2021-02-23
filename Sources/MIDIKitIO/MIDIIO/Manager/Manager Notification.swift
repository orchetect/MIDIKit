//
//  Manager Notification.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-02-21.
//

import CoreMIDI

extension MIDIIO.Manager {
	
	internal enum Notification {
		
		case setupChanged
		
		case added(parent: MIDIObjectRef, parentType: MIDIObjectType,
				   child: MIDIObjectRef, childType: MIDIObjectType)
		
		case removed(parent: MIDIObjectRef, parentType: MIDIObjectType,
					 child: MIDIObjectRef, childType: MIDIObjectType)
		
		case propertyChanged(forRef: MIDIObjectRef, forRefType: MIDIObjectType,
							 propertyName: String)
		
		case thruConnectionChanged
		
		case serialPortOwnerChanged
		
		case ioError(device: MIDIDeviceRef, error: MIDIIO.OSStatusResult)
		
		/// Typically will never happen unless Apple adds additional cases to CoreMIDI's `MIDINotificationMessageID` enum.
		case other(messageIDrawValue: Int32)
		
	}
	
}

extension MIDIIO.Manager.Notification {
	
	internal init(_ message: UnsafePointer<MIDINotification>) {
		
		let messageID = message.pointee.messageID
		
		switch messageID {
		case .msgSetupChanged:
			
			self = .setupChanged
			
		case .msgObjectAdded,
			 .msgObjectRemoved:
			
			self = message.withMemoryRebound(
				to: MIDIObjectAddRemoveNotification.self,
				capacity: 1
			) { (message) in
				
				let m = message.pointee
				
				if messageID == .msgObjectAdded {
					return .added(parent: m.parent, parentType: m.parentType,
								  child: m.child, childType: m.childType)
				} else {
					return .removed(parent: m.parent, parentType: m.parentType,
									child: m.child, childType: m.childType)
				}
				
			}
			
		case .msgPropertyChanged:
			
			self = message.withMemoryRebound(
				to: MIDIObjectPropertyChangeNotification.self,
				capacity: 1
			) { (message) in
				
				let m = message.pointee
				
				return .propertyChanged(
					forRef: m.object,
					forRefType: m.objectType,
					propertyName: m.propertyName.takeUnretainedValue() as String
				)
				
			}
			
		case .msgThruConnectionsChanged:
			
			self = .thruConnectionChanged
			
		case .msgSerialPortOwnerChanged:
			
			self = .serialPortOwnerChanged
			
		case .msgIOError:
			
			self = message.withMemoryRebound(
				to: MIDIIOErrorNotification.self,
				capacity: 1
			) { (message) in
				
				let m = message.pointee
				
				return .ioError(
					device: m.driverDevice,
					error: .init(rawValue: m.errorCode)
				)
				
			}
			
		@unknown default:
			
			self = .other(messageIDrawValue: messageID.rawValue)
			
		}
		
	}
	
}
