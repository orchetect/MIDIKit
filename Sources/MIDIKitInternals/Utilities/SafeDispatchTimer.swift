//
//  SafeDispatchTimer.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Dispatch
import Foundation

/// Simple custom safe `DispatchSourceTimer` wrapper.
///
/// Timer does not start automatically when initializing. Call ``start()`` after initialization to
/// begin the timer.
///
/// The timer will fire at intervals of a `rate` in Hz, starting immediately from the time at which
/// ``start()`` is called.
///
/// All timer methods are safe and can be called in any order without worrying about
/// `DispatchSourceTimer`-related peculiarities (start/suspend balancing or cancelling without
/// resuming).
package final class SafeDispatchTimer /* : Sendable */ {
    nonisolated(unsafe)
    var timer: DispatchSourceTimer
    
    /// (Read-only) Frequency in Hz of the timer
    public internal(set) nonisolated(unsafe) var rate: Rate = .seconds(1.0)
    
    public let leeway: DispatchTimeInterval
    
    /// (Read-only) State of whether timer is running or not
    nonisolated(unsafe)
    public internal(set) var running = false
    
    /// Initialize a new timer.
    /// - Parameters:
    ///   - rate: Frequency timer event intervals, expressed in Hertz
    ///   - leeway: Optionally specify custom leeway; default is 0 nanoseconds
    ///   - eventHandler: The closure to be called on each timer event
    public init(
        rate: Rate,
        leeway: DispatchTimeInterval = .nanoseconds(0),
        eventHandler: @escaping DispatchSource.DispatchSourceHandler = { }
    ) {
        self.rate = rate
    
        self.leeway = leeway
    
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: .global())
    
        // schedule the timer's start time to be the time of the class initialization
    
        timer.schedule(
            deadline: .now(),
            repeating: rate.secondsValue,
            leeway: leeway
        )
    
        timer.setEventHandler(handler: eventHandler)
    }
    
    /// Starts the timer. The timer will occur at intervals measured since the creation of the
    /// timer, regardless of when ``start()`` is called.
    ///
    /// If the timer has already started, this will have no effect.
    public func start() {
        guard !running else { return }
        running = true
        
        timer.resume()
    }
    
    /// Restarts the origin time (deadline) of the timer to "now".
    ///
    /// If the timer has already been started, the origin time will be set to "now" and the timer
    /// will continue to run at intervals from "now".
    ///
    /// If the timer has not yet been started or was previously suspended using ``stop()``, the
    /// timer
    /// will be restarted and the origin time will be set to "now".
    ///
    /// - Parameters:
    ///   - immediate: If `true`, restarts timer and fires immediately then again at each interval.
    ///     If `false`, restarts timer but first fire does not happen until the first interval is
    ///     reached then again at each subsequent interval.
    public func restart(firingNow: Bool = true) {
        // if timer is already running, reschedule the currently running timer
        // if timer is not running, schedule the timer then start it
        
        timer.schedule(
            deadline: firingNow ? .now() : .now() + rate.secondsValue,
            repeating: rate.secondsValue,
            leeway: leeway
        )
        
        if !running {
            start()
        }
    }
    
    /// Suspends the timer if it was running.
    ///
    /// The timer can be started again by calling ``start()``, preserving the origin time, or
    /// ``restart(firingNow:)`` to reset the origin time to "now".
    public func stop() {
        guard running else { return }
        running = false
        timer.suspend()
    }
    
    /// Sets the timer rate in Hz.
    /// Change only takes effect the next time `restart()` is called.
    public func setRate(_ newRate: Rate) {
        rate = newRate
    }
    
    /// Set the event handler closure that the timer executes
    public func setEventHandler(handler: @escaping DispatchSource.DispatchSourceHandler) {
        timer.setEventHandler(handler: handler)
    }
    
    deinit {
        timer.setEventHandler(handler: nil)
        
        // If the timer is suspended, calling cancel without resuming
        // triggers a crash. This is documented here:
        // https://forums.developer.apple.com/thread/15902
        
        if !running { timer.resume() }
        
        timer.cancel()
    }
}

extension SafeDispatchTimer {
    public enum Rate: Hashable {
        case hertz(Double)
        case seconds(Double)
    
        public var secondsValue: Double {
            let value: Double
    
            switch self {
            case let .hertz(hz):
                value = 1.0 / hz.clamped(to: 0.00001...)
    
            case let .seconds(secs):
                value = secs
            }
    
            return value.clamped(to: 0.000_000_001...) // 1 nanosecond min
        }
    }
}
