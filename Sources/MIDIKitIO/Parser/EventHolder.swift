//
//  PNCombiner.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Event Holder.
final class EventHolder<T: MIDIParameterNumberEvent> {
    // MARK: - Options
    
    public typealias TimerExpiredHandler = (_ storedEvent: ReturnedStoredEvent) -> Void
    public var timerExpired: TimerExpiredHandler?
    public let timeOut: TimeInterval
    public var storedEventWrapper: (T) -> MIDIEvent
    
    // MARK: - Parser State
    
    private var expirationTimer: Timer?
    
    public typealias StoredEvent = (
        event: T,
        timeStamp: CoreMIDITimeStamp,
        source: MIDIOutputEndpoint?
    )
    var storedEvent: StoredEvent?
    
    public typealias ReturnedStoredEvent = (
        event: MIDIEvent,
        timeStamp: CoreMIDITimeStamp,
        source: MIDIOutputEndpoint?
    )
    
    init(
        timeOut: TimeInterval = 0.05,
        storedEventWrapper: @escaping (T) -> MIDIEvent,
        timerExpired: TimerExpiredHandler? = nil
    ) {
        self.timeOut = timeOut
        self.storedEventWrapper = storedEventWrapper
        self.timerExpired = timerExpired
    }
    
    func restartTimer() {
        expirationTimer?.invalidate()
        expirationTimer = Timer
            .scheduledTimer(withTimeInterval: timeOut, repeats: false) { [self] timer in
                defer { reset() }
                callTimerExpired()
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
        guard let storedEvent = storedEvent else { return nil }
        let wrapped = storedEventWrapper(storedEvent.event)
        return (
            event: wrapped,
            timeStamp: storedEvent.timeStamp,
            source: storedEvent.source
        )
    }
}

#endif
