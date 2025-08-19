//
//  EventHolder.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
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
    
    @ThreadSafeAccess
    private var expirationTask: /* Task<Void, any Error> */ Any? // can't strongly type as Task because of package back-compat
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    private var expirationTaskTyped: Task<Void, any Error>? {
        get { expirationTask as? Task<Void, any Error> }
        set { expirationTask = newValue }
    }
    
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
        self.timeOut = timeOut.clamped(to: 0...)
        self.storedEventWrapper = storedEventWrapper
        self.timerExpired = timerExpired
    }
}

extension EventHolder {
    func restartTimer() {
        invalidate()
        
        // prefer using Task over Timer.
        // Timer uses old-school runloop which interferes with Swift Concurrency and in some contexts may not work correctly.
        if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            let nsec = UInt64(timeOut * TimeInterval(NSEC_PER_SEC))
            expirationTaskTyped = Task { [weak self] in
                try await Task.sleep(nanoseconds: nsec)
                try Task.checkCancellation()
                self?.callTimerExpired()
                self?.reset()
            }
        } else {
            expirationTimer = Timer.scheduledTimer(
                withTimeInterval: timeOut,
                repeats: false
            ) { [weak self] timer in
                self?.callTimerExpired()
                self?.reset()
            }
        }
    }
    
    func reset() {
        invalidate()
        storedEvent = nil
    }
    
    func fireStored() {
        if storedEvent != nil {
            callTimerExpired()
        }
        storedEvent = nil
    }
    
    func fireStoredAndReset() {
        invalidate()
        fireStored()
    }
    
    func invalidate() {
        if #available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *) {
            expirationTaskTyped?.cancel()
            expirationTask = nil
        } else {
            expirationTimer?.invalidate()
        }
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
