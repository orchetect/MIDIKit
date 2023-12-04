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
    
    public typealias TimerExpiredHandler = (_ storedEvent: MIDIEvent) -> Void
    public var timerExpired: TimerExpiredHandler?
    
    public let timeOut: TimeInterval
    
    public var storedEventWrapper: (T) -> MIDIEvent
    
    // MARK: - Parser State
    
    private var expirationTimer: Timer?
    
    var storedEvent: T?
    
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
        expirationTimer = Timer.scheduledTimer(withTimeInterval: timeOut, repeats: false) { [self] timer in
            defer { reset() }
            guard let storedEvent = storedEvent else { return }
            timerExpired?(storedEventWrapper(storedEvent))
        }
    }
    
    func reset() {
        expirationTimer?.invalidate()
        storedEvent = nil
    }
    
    func fireStored() {
        if let storedEvent = storedEvent {
            timerExpired?(storedEventWrapper(storedEvent))
        }
        storedEvent = nil
    }
    
    func fireStoredAndReset() {
        expirationTimer?.invalidate()
        fireStored()
    }
    
    func returnStoredAndReset() -> T? {
        let storedEvent = storedEvent
        reset()
        return storedEvent
    }
}

#endif
