//
//  MTCReceiver SyncPolicy.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKit
import TimecodeKit

extension MTCReceiver {
    /// Options defining behavior of the receiver
    public struct SyncPolicy: Equatable, Codable {
        // MARK: - Public properties
        
        /// Sets the number of received continuous timecode frames that must elapse prior to establishing synchronization
        public var lockFrames: Int = 0
        
        /// Sets the number of timecode frames that must be missed until the receiver enters the stopped/idle state
        public var dropOutFrames: Int = 0
        
        // MARK: - Init
        
        public init(lockFrames: Int = 16, dropOutFrames: Int = 10) {
            setLockFrames(lockFrames)
            setDropOutFramesFrames(dropOutFrames)
        }
        
        // MARK: - Internal Methods
        
        internal mutating func setLockFrames(_ value: Int) {
            lockFrames = min(max(0, value), 100)
        }
        
        internal mutating func setDropOutFramesFrames(_ value: Int) {
            dropOutFrames = min(max(0, value), 100)
        }
        
        // MARK: - Public Methods
        
        /// Returns real time duration in seconds of the `lockFrames` property.
        public func lockDuration(at rate: Timecode.FrameRate) -> Double {
            let tc = Timecode(wrapping: TCC(f: lockFrames), at: rate)
            return tc.realTimeValue
        }
        
        /// Returns real time duration in seconds of the `dropOutFrames` property.
        public func dropOutDuration(at rate: Timecode.FrameRate) -> Double {
            let tc = Timecode(wrapping: TCC(f: dropOutFrames), at: rate)
            return tc.realTimeValue
        }
    }
}
