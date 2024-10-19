//
//  MTCReceiver SyncPolicy.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import TimecodeKitCore

extension MTCReceiver {
    /// Options defining behavior of the receiver.
    public struct SyncPolicy: Equatable, Codable {
        // MARK: - Public properties
        
        /// Sets the number of received continuous timecode frames that must elapse prior to
        /// establishing synchronization.
        public var lockFrames: Int = 0
        
        /// Sets the number of timecode frames that must be missed until the receiver enters the
        /// stopped/idle state.
        public var dropOutFrames: Int = 0
        
        // MARK: - Init
        
        public init(lockFrames: Int = 16, dropOutFrames: Int = 10) {
            setLockFrames(lockFrames)
            setDropOutFramesFrames(dropOutFrames)
        }
        
        // MARK: - Internal Methods
        
        mutating func setLockFrames(_ value: Int) {
            lockFrames = min(max(0, value), 100)
        }
        
        mutating func setDropOutFramesFrames(_ value: Int) {
            dropOutFrames = min(max(0, value), 100)
        }
        
        // MARK: - Public Methods
        
        /// Returns real time duration in seconds of the ``lockFrames`` property.
        public func lockDuration(at rate: TimecodeFrameRate) -> TimeInterval {
            let tc = Timecode(.components(f: lockFrames), at: rate, by: .wrapping)
            return tc.realTimeValue
        }
        
        /// Returns real time duration in seconds of the ``dropOutFrames`` property.
        public func dropOutDuration(at rate: TimecodeFrameRate) -> TimeInterval {
            let tc = Timecode(.components(f: dropOutFrames), at: rate, by: .wrapping)
            return tc.realTimeValue
        }
    }
}

extension MTCReceiver.SyncPolicy: Sendable { }
