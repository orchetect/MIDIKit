//
//  Example Managed Objects.swift
//  MIDIKitTestHarness
//
//  Created by Steffan Andrews on 2021-03-01.
//

import Foundation

// ----------------------------------------
// MARK: - create an input port -----------
// ----------------------------------------

//	do {
//		let uID = UserDefaults.standard
//			.integerOptional(forKey: "MIDIKitTestHarness In - Unique ID")?
//			.int32
//
//		let newUniqueID = try midiManager.addInput(
//			name: "MIDIKitTestHarness In",
//			tag: "MIDIKitTestHarness In",
//			uniqueID: uID,
//			receiveHandler: .rawDataLogging(filterActiveSensingAndClock: true)
//				{ (rawDataBytesString) in
//					Log.debug("Received on 'MIDIKitTestHarness In':", rawDataBytesString)
//				}
//		)
//
//		// update stored unique ID for the port
//		UserDefaults.standard
//			.setValue(newUniqueID, forKey: "MIDIKitTestHarness In - Unique ID")
//	} catch {
//		Log.error(error)
//	}

// ----------------------------------------
// MARK: - form an input connection -------
// ----------------------------------------

//	do {
//		try midiManager.addInputConnection(
//			toOutput: .name("Port1"),
//			tag: "Port1",
//			receiveHandler: .rawDataLogging(filterActiveSensingAndClock: true)
//				{ (rawDataBytesString) in
//					Log.debug("Received from connection to 'Port1':", rawDataBytesString)
//				}
//		)
//	} catch {
//		Log.error(error)
//	}

// ----------------------------------------
// MARK: - create an output port ----------
// ----------------------------------------

// var midiOutTimer: SafeDispatchTimer? = nil
//
//	do {
//		let uID = UserDefaults.standard
//			.integerOptional(forKey: "MIDIKitTestHarness Out - Unique ID")?
//			.int32
//
//		let newUniqueID = try midiManager.addOutput(
//			name: "MIDIKitTestHarness Out",
//			tag: "MIDIKitTestHarness Out",
//			uniqueID: uID
//		)
//
//		// update stored unique ID for the port
//		UserDefaults.standard
//			.setValue(newUniqueID, forKey: "MIDIKitTestHarness Out - Unique ID")

//		// create a timer that sends a message every 1 second for debug purposes
//		midiOutTimer = SafeDispatchTimer(frequencyInHz: 1.0,
//										 queue: DispatchQueue.main,
//										 leeway: .milliseconds(10)) {
//
//			// Send MIDI CC #1 value int 64 on channel 1
//			try? midiManager.managedOutputs["MIDIKitTestHarness Out"]?
//				.send(rawMessage: [0xB0, 0x01, 0x40])
//
//		}
//
//		midiOutTimer?.start()
//	} catch {
//		Log.error(error)
//	}

// ----------------------------------------
// MARK: - form an output connection ------
// ----------------------------------------

//	do {
//		try midiManager.addOutputConnection(
//			toInput: .uniqueID(552453915), // .uniqueID(-2141357990), //.name("MIDI Monitor (Untitled)"),
//			tag: "MIDI Monitor"
//		)
//
//		// create a timer that sends a message every 1 second for debug purposes
//		midiOutTimer2 = SafeDispatchTimer(frequencyInHz: 1.0,
//										  queue: DispatchQueue.main,
//										  leeway: .milliseconds(10)) {
//
//			// Send MIDI CC #2 value int 64 on channel 1
//			try? midiManager.managedOutputConnections["MIDI Monitor"]?
//				.send(rawMessage: [0xB0, 0x02, 0x40])
//
//		}
//
//		midiOutTimer2?.start()
//	} catch {
//		Log.error(error)
//	}

// ----------------------------------------
// MARK: - form a thru connection ---------
// ----------------------------------------

//	do {
//		if
//			let outp = midiManager.endpoints.outputs
//				.filterBy(name: "Port1").first,
//			let inp = midiManager.endpoints.inputs
//				.filterBy(name: "MIDI Monitor (Untitled)").first {
//
//			try midiManager.addThruConnection(outputs: [outp],
//											  inputs: [inp],
//											  tag: "Thru")
//
//			midiOutTimer2 = SafeDispatchTimer(frequencyInHz: 1.0,
//											  queue: DispatchQueue.main,
//											  leeway: .milliseconds(10)) {
//
//				guard let conn = midiManager.managedThruConnections["Thru"] else {
//					Log.debug("Can't find managed Thru connection")
//					return
//				}
//
//				Log.debug("----")
//				Log.debug("Thru thruConnectionRef", conn.thruConnectionRef)
//				Log.debug("Thru Inputs:", conn.inputs)
//				Log.debug("Thru Outputs:", conn.inputs)
//				Log.debug("----")
//
//			}
//
//			midiOutTimer2?.start()
//
//		}
//		else {
//			Log.error("Can't find ports in system to create thru connection.")
//		}
//
//	} catch {
//		Log.error(error)
//	}

// ----------------------------------------
// MARK: - analyze thru connections -------
// ----------------------------------------

//	Log.debug("managedThruConnections:", midiManager.managedThruConnections)
//	Log.debug("unmanagedThruConnections:", (try? midiManager.unmanagedPersistentThrus(ownerID: "")) as Any)
