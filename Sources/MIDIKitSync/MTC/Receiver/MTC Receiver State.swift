//
//  MTC Receiver State.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2020-12-21.
//

import Dispatch
import TimecodeKit

// MARK: - State

extension MTC.Receiver {
	
	/// MTC data stream receive state
	public enum State: Equatable {
		
		/// Idle:
		/// No activity (incoming continuous data stream stopped).
		case idle
		
		/// Pre-Sync:
		/// MTC quarter-frames are being received in the pre-sync phase prior to transitioning to `.chasing`.
		case preSync(predictedLockTime: DispatchTime, lockTimecode: Timecode)
		
		/// Sync:
		/// Pre-sync phase is complete and timecode is now synchronized.
		/// This state is then maintained while MTC data stream is actively being received.
		case sync
		
		/// Freewheeling:
		/// Incoming MTC data is experiencing jitter (drop out) or data stream has stopped and receiver is in the freewheeling state.
		case freewheeling
		
		/// Incompatible Frame Rate:
		/// The incoming MTC frame rate is not compatible with the `localFrameRate` and therefore sync is not possible.
		case incompatibleFrameRate
	}
	
}

extension MTC.Receiver.State: CustomStringConvertible {
	
	public var description: String {
		
		switch self {
		case .idle:
			return "idle"
		case .preSync(_, _):
			return "preSync"
		case .sync:
			return "chasing"
		case .freewheeling:
			return "freewheeling"
		case .incompatibleFrameRate:
			return "incompatibleFrameRate"
		}
		
	}
	
}
