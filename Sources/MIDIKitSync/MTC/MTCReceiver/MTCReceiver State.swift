//
//  MTCReceiver State.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Dispatch
import MIDIKitCore
import TimecodeKit

// MARK: - State

extension MTCReceiver {
    /// MTC data stream receive state
    public enum State: Equatable {
        /// Idle:
        /// No activity (incoming continuous data stream stopped).
        case idle
        
        /// Pre-Sync:
        /// MTC quarter-frames are being received in the pre-sync phase prior to transitioning to
        /// ``sync``.
        case preSync(predictedLockTime: DispatchTime, lockTimecode: Timecode)
        
        /// Sync:
        /// Pre-sync phase is complete and timecode is now synchronized.
        /// This state is then maintained while MTC data stream is actively being received.
        case sync
        
        /// Freewheeling:
        /// Incoming MTC data is experiencing jitter (drop out) or data stream has stopped and
        /// receiver is in the freewheeling state.
        case freewheeling
        
        /// Incompatible Frame Rate:
        /// The incoming MTC frame rate is not compatible with the ``MTCReceiver/localFrameRate``
        /// and therefore sync is not possible.
        case incompatibleFrameRate
    }
}

extension MTCReceiver.State: Sendable { }

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
