//
//  MTCReceiver State.swift
//  MIDIKitSync • https://github.com/orchetect/MIDIKitSync
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Dispatch
import MIDIKit
import TimecodeKit

// MARK: - State

extension MTCReceiver {
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

extension MTCReceiver.State: CustomStringConvertible {
    public var description: String {
        switch self {
        case .idle:
            return "idle"
        case .preSync:
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
