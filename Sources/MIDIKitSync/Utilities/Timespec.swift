//
//  Timespec.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// ------------------------------------------------------------------------------------
/// ------------------------------------------------------------------------------------
/// Borrowed from [OTCore 1.4.2](https://github.com/orchetect/OTCore) under MIT license.
/// ------------------------------------------------------------------------------------
/// ------------------------------------------------------------------------------------

#if canImport(Darwin)

import Darwin

// Apple docs:
//
// CLOCK_MONOTONIC
// clock that increments monotonically, tracking the time since an arbitrary point, and will continue to increment while the system is asleep.
//
// CLOCK_MONOTONIC_RAW
// clock that increments monotonically, tracking the time since an arbitrary point like CLOCK_MONOTONIC. However, this clock is unaffected by frequency or time adjustments. It should not be compared to other system time sources.
//
// CLOCK_MONOTONIC_RAW_APPROX
// like CLOCK_MONOTONIC_RAW, but reads a value cached by the system at context switch. This can be read faster, but at a loss of accuracy as it may return values that are milliseconds old.
//
// CLOCK_UPTIME_RAW
// clock that increments monotonically, in the same manner as CLOCK_MONOTONIC_RAW, but that does not increment while the system is asleep. The returned value is identical to the result of mach_absolute_time() after the appropriate mach_timebase conversion is applied.

/// Returns high-precision system uptime
///
/// This is preferable to using `mach_absolute_time()` since `mach_absolute_time()` is macOS-only.
///
/// - returns: `timespec(tv_sec: Int, tv_nsec: Int)` where `tv_sec` is seconds and `tc_nsec` is nanoseconds
@available(OSX 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)
@_disfavoredOverload
internal func clock_gettime_monotonic_raw() -> timespec {
    var uptime = timespec()
    
    if clock_gettime(CLOCK_MONOTONIC_RAW, &uptime) != 0 {
        fatalError("Could not execute clock_gettime, errno: \(errno)")
    }
    
    return uptime
}

// MARK: - Timespec constructors

extension timespec {
    /// Convenience constructor from floating point seconds value
    @_disfavoredOverload
    internal init<T: BinaryFloatingPoint>(seconds floatingPoint: T) {
        self.init()
        
        let intVal = Int(floatingPoint * 1_000_000_000)
        
        tv_nsec = intVal % 1_000_000_000
        
        tv_sec = intVal / 1_000_000_000
    }
}

// MARK: - Timespec operators and comparison

/// Add two instances of `timespec`
@_disfavoredOverload
internal func + (lhs: timespec, rhs: timespec) -> timespec {
    let nsRaw = rhs.tv_nsec + lhs.tv_nsec
    
    let ns = nsRaw % 1_000_000_000
    
    let s = lhs.tv_sec + rhs.tv_sec + (nsRaw / 1_000_000_000)
    
    return timespec(tv_sec: s, tv_nsec: ns)
}

/// Subtract two instances of `timespec`
@_disfavoredOverload
internal func - (lhs: timespec, rhs: timespec) -> timespec {
    let nsRaw = lhs.tv_nsec - rhs.tv_nsec
    
    if nsRaw >= 0 {
        let ns = nsRaw % 1_000_000_000
        
        let s = lhs.tv_sec - rhs.tv_sec + (nsRaw / 1_000_000_000)
        
        return timespec(tv_sec: s, tv_nsec: ns)
        
    } else {
        // roll under
        
        let ns = 1_000_000_000 - (-nsRaw % 1_000_000_000)
        
        let s = lhs.tv_sec - rhs.tv_sec - 1 - (-nsRaw / 1_000_000_000)
        
        return timespec(tv_sec: s, tv_nsec: ns)
    }
}

extension timespec /* : Equatable */ {
    @_disfavoredOverload
    internal static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.tv_sec == rhs.tv_sec &&
            lhs.tv_nsec == rhs.tv_nsec
    }
    
    @_disfavoredOverload
    internal static func != (lhs: Self, rhs: Self) -> Bool {
        !(lhs == rhs)
    }
}

extension timespec /* : Comparable */ {
    @_disfavoredOverload
    internal static func < (lhs: timespec, rhs: timespec) -> Bool {
        if lhs.tv_sec < rhs.tv_sec { return true }
        if lhs.tv_sec > rhs.tv_sec { return false }
        
        // seconds equate; now test nanoseconds
        
        if lhs.tv_nsec < rhs.tv_nsec { return true }
        
        return false
    }
    
    @_disfavoredOverload
    internal static func > (lhs: timespec, rhs: timespec) -> Bool {
        !(lhs < rhs)
    }
}

#endif

#if canImport(Foundation)

import Foundation

extension timespec {
    /// Convenience constructor from `TimeInterval`
    @_disfavoredOverload
    internal init(_ interval: TimeInterval) {
        self.init(seconds: interval)
    }
}

extension timespec {
    /// Return a `TimeInterval`
    @_disfavoredOverload
    internal var doubleValue: TimeInterval {
        Double(tv_sec) + (Double(tv_nsec) / 1_000_000_000)
    }
}

#endif
