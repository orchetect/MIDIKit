//
//  EventHolder.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import MIDIKitCore

/// Event Holder.
final class EventHolder<T: MIDIParameterNumberEvent>: @unchecked Sendable { // @unchecked required for @ThreadSafeAccess use
    // MARK: - Options
    
    typealias TimerExpiredHandler = @Sendable (_ storedEvent: ReturnedStoredEvent) -> Void
    let timerExpired: TimerExpiredHandler?
    
    let timeOut: TimeInterval
    
    typealias StoredEventWrapper = @Sendable (T) -> MIDIEvent
    let storedEventWrapper: StoredEventWrapper
    
    // MARK: - Parser State
    
    @ThreadSafeAccess
    private var expirationTimer: Timer?
    
    typealias StoredEvent = (
        event: T,
        timeStamp: CoreMIDITimeStamp,
        source: MIDIOutputEndpoint?
    )
    
    @ThreadSafeAccess
    var storedEvent: StoredEvent?
    
    typealias ReturnedStoredEvent = (
        event: MIDIEvent,
        timeStamp: CoreMIDITimeStamp,
        source: MIDIOutputEndpoint?
    )
    
    init(
        timeOut: TimeInterval = 0.05,
        storedEventWrapper: @escaping StoredEventWrapper,
        timerExpired: TimerExpiredHandler? = nil
    ) {
        self.timeOut = timeOut
        self.storedEventWrapper = storedEventWrapper
        self.timerExpired = timerExpired
    }
}

extension EventHolder {
    func restartTimer() {
        expirationTimer?.invalidate()
        expirationTimer = Timer.scheduledTimer(
            withTimeInterval: timeOut,
            repeats: false
        ) { [self] timer in
            callTimerExpired()
            reset()
        }
    }
    
    func reset() {
        expirationTimer?.invalidate()
        storedEvent = nil
    }
    
    func fireStored() {
        if storedEvent != nil {
            callTimerExpired()
        }
        storedEvent = nil
    }
    
    func fireStoredAndReset() {
        expirationTimer?.invalidate()
        fireStored()
    }
    
    func returnStoredAndReset() -> ReturnedStoredEvent? {
        let storedEvent = returnedStoredEvent()
        reset()
        return storedEvent
    }
    
    func callTimerExpired() {
        guard let storedEvent = returnedStoredEvent() else { return }
        timerExpired?(storedEvent)
    }
    
    func returnedStoredEvent() -> ReturnedStoredEvent? {
        guard let storedEvent else { return nil }
        let wrapped = storedEventWrapper(storedEvent.event)
        return (
            event: wrapped,
            timeStamp: storedEvent.timeStamp,
            source: storedEvent.source
        )
    }
}

#endif
