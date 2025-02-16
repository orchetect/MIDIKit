//
//  MTCReceiver.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Darwin
import Foundation
import MIDIKitCore
import MIDIKitIO
internal import MIDIKitInternals
import TimecodeKitCore

// MARK: - Receiver

/// MTC sync receiver wrapper for ``MTCDecoder``.
///
/// > Note:
/// >
/// > - A running MTC data stream (during playback) only updates the frame number every 2 frames, so
/// > this data stream should not be relied on for deriving exact frame position, but rather as a
/// > mechanism for displaying running timecode to the user on screen or synchronizing playback to
/// > the incoming MTC data stream.
/// >
/// > - MTC full frame messages (which only some DAWs support) will however transmit frame-accurate
/// > timecodes when scrubbing or locating to different times.
public final class MTCReceiver: @unchecked Sendable { // @unchecked required for @ThreadSafeAccess use
    // MARK: - Public properties
    
    public let name: String
    
    @ThreadSafeAccess
    public private(set) var state: State = .idle {
        didSet {
            let state = state // read once to avoid engaging lock twice
            if state != oldValue {
                stateChangedHandler?(state)
            }
        }
    }
    
    /// Property updated whenever incoming MTC timecode changes.
    @ThreadSafeAccess
    public private(set) var timecode: Timecode
    
    /// The frame rate the local system is using.
    /// Remember to also set this any time the local frame rate changes so the receiver can
    /// interpret the incoming MTC accordingly.
    public var localFrameRate: TimecodeFrameRate? {
        get { receiveQueue.sync { decoder.localFrameRate } }
        set { receiveQueue.sync { decoder.localFrameRate = newValue } }
    }
    
    /// The frame rate the local system is using.
    /// Remember to also set this any time the local frame rate changes so the receiver can
    /// interpret the incoming MTC accordingly.
    public func setLocalFrameRate(_ newFrameRate: TimecodeFrameRate?) {
        localFrameRate = newFrameRate
    }
    
    /// The SMPTE frame rate (24, 25, 29.97d, or 30) that was last received by the receiver.
    ///
    /// This property should only be inspected purely for developer informational or diagnostic
    /// purposes. For production code or any logic related to MTC, it should be ignored -- only the
    /// ``localFrameRate`` property is used for automatic validation and scaling of incoming
    /// timecode.
    public var mtcFrameRate: MTCFrameRate {
        receiveQueue.sync { decoder.mtcFrameRate }
    }
    
    /// Status of the direction of MTC quarter-frames received.
    public var direction: MTCDirection {
        receiveQueue.sync { decoder.direction }
    }
    
    /// Behavior governing how locking occurs prior to chase.
    public let syncPolicy: SyncPolicy
    
    // MARK: - Stored closures
    
    /// Called when a meaningful change to the timecode has occurred which would require its display
    /// to be updated.
    ///
    /// Implement this closure for when you only want to display timecode and do not need to sync to
    /// MTC.
    ///
    /// > Important:
    /// >
    /// > This closure may be executed on a background thread. If the logic in the closure results in
    /// > user interface updates, ensure that they are performed on the main actor/thread.
    ///
    /// - Parameters:
    ///   - timecode: Current display timecode.
    ///   - event: The MTC event that triggered the callback.
    ///   - direction: The current MTC playback or scrub direction.
    ///   - isFrameChanged: Boolean indicating that there has been a change to the four main timecode
    ///     components (`HH:MM:SS:FF`, ignoring subframes) since the last time this callback was called.
    nonisolated(unsafe) var timecodeChangedHandler: (@Sendable (
        _ timecode: Timecode,
        _ event: MTCMessageType,
        _ direction: MTCDirection,
        _ isFrameChanged: Bool
    ) -> Void)?
    
    /// Called when a meaningful change to the timecode has occurred which would require its display
    /// to be updated.
    ///
    /// Implement this closure for when you only want to display timecode and do not need to sync to
    /// MTC.
    ///
    /// > Important:
    /// >
    /// > This closure may be executed on a background thread. If the logic in the closure results in
    /// > user interface updates, ensure that they are performed on the main actor/thread.
    ///
    /// - Parameters:
    ///   - handler: Closure containing the following parameters:
    ///     - `timecode`: Current display timecode.
    ///     - `event`: The MTC event that triggered the callback.
    ///     - `direction`: The current MTC playback or scrub direction.
    ///     - `isFrameChanged`: Boolean indicating that there has been a change to the four main timecode
    ///       components (`HH:MM:SS:FF`, ignoring subframes) since the last time this callback was called.
    public func setTimecodeChangedHandler(
        _ handler: (@Sendable (
            _ timecode: Timecode,
            _ event: MTCMessageType,
            _ direction: MTCDirection,
            _ isFrameChanged: Bool
        ) -> Void)?
    ) {
        receiveQueue.sync {
            self.timecodeChangedHandler = handler
        }
    }
    
    /// Called when the MTC receiver's state changes.
    ///
    /// > Important:
    /// >
    /// > This closure may be executed on a background thread. If the logic in the closure results in
    /// > user interface updates, ensure that they are performed on the main actor/thread.
    nonisolated(unsafe) var stateChangedHandler: (@Sendable (_ state: State) -> Void)?
    
    /// Called when the MTC receiver's state changes.
    ///
    /// > Important:
    /// >
    /// > This closure may be executed on a background thread. If the logic in the closure results in
    /// > user interface updates, ensure that they are performed on the main actor/thread.
    public func setStateChangedHandler(
        _ handler: (@Sendable (_ state: State) -> Void)?
    ) {
        receiveQueue.sync {
            self.stateChangedHandler = handler
        }
    }
    
    // MARK: - Init
    
    /// Initialize a new MTC Receiver instance.
    ///
    /// > Important:
    /// >
    /// > The handler closures may be executed on a background thread. If the logic in these
    /// > closures results in user interface updates, ensure that they are performed on the main
    /// > actor/thread.
    ///
    /// - Parameters:
    ///   - name: Optionally supply a simple, unique alphanumeric name for the instance, used
    ///     internally to identify the dispatch thread. A random UUID will be used if `nil`.
    ///   - initialLocalFrameRate: Set an initial local frame rate.
    ///   - syncPolicy: Set the MTC sync policy.
    ///   - timecodeChanged: Timecode changed callback handler. See ``setTimecodeChangedHandler(_:)``
    ///     for more information.
    ///   - stateChanged: Receiver state change callback handler.
    public init(
        name: String? = nil,
        initialLocalFrameRate: TimecodeFrameRate? = nil,
        syncPolicy: SyncPolicy = .init(),
        timecodeChanged: (@Sendable (
            _ timecode: Timecode,
            _ event: MTCMessageType,
            _ direction: MTCDirection,
            _ isFrameChanged: Bool
        ) -> Void)? = nil,
        stateChanged: (@Sendable (_ state: State) -> Void)? = nil
    ) {
        // handle init arguments
        
        let name = name ?? UUID().uuidString
        self.name = name
        self.syncPolicy = syncPolicy
        timecode = Timecode(.zero, at: initialLocalFrameRate ?? .fps30)
        
        // queues
        
        let receiveQueueName = (Bundle.main.bundleIdentifier ?? "com.orchetect.midikit")
            + ".mtcReceiver." + name + ".receive"
        receiveQueue = DispatchQueue(label: receiveQueueName, qos: .userInitiated)
        
        // store handler closures
        
        timecodeChangedHandler = receiveQueue.sync { timecodeChanged }
        stateChangedHandler = receiveQueue.sync { stateChanged }
        
        // set up decoder reset timer
        // we're accounting for the largest reasonable interval of time we are willing to wait until
        // we assume non-contiguous MTC stream has stopped or failed
        // it would be reasonable to allow for the slowest frame rate (23.976fps) and round up by a
        // modest margin:
        // 1 frame @ 23.976 = 41.7... ms
        // 1 quarter-frame = 41.7/4 = 10.4... ms
        // Timer checking twice per QF = ~5.0ms intervals = 200Hz
        
        timer = SafeDispatchTimer(
            rate: .hertz(200.0),
            queue: receiveQueue,
            eventHandler: { }
        )
        
        // decoder setup
        
        decoder = receiveQueue.sync {
            MTCDecoder(
                initialLocalFrameRate: initialLocalFrameRate
            )
        }
        
        // set up handlers after self is initialized so we can capture reference to self
        
        timer.setEventHandler { [weak self] in
            self?.timerFired()
        }
        
        decoder.setTimecodeChangedHandler { [weak self] timecode, messageType, direction, isFrameChanged in
            self?.timecodeDidChange(
                to: timecode,
                event: messageType,
                direction: direction,
                isFrameChanged: isFrameChanged
            )
        }
    }
    
    // MARK: - Queue (internal)
    
    private let receiveQueue: DispatchQueue
    
    // MARK: - Decoder (internal)
    
    nonisolated(unsafe)
    var decoder: MTCDecoder!
    
    @ThreadSafeAccess
    public private(set) var timeLastQuarterFrameReceived: timespec = .init()
    
    @ThreadSafeAccess
    private var freewheelPreviousTimecode: Timecode = .init(.zero, at: .fps30)
    
    @ThreadSafeAccess
    private var freewheelSequentialFrames: Int = 0
    
    // MARK: - Timer (internal)
    
    private nonisolated(unsafe) let timer: SafeDispatchTimer
    
    /// Internal: Fired from our timer object.
    func timerFired() {
        // this will be called by the timer which operates on our internal queue, so we don't need
        // to wrap this in queue.async { }
        
        let timeNow = clock_gettime_monotonic_raw()
        
        let clockDiff = timeNow - timeLastQuarterFrameReceived
        
        // increment state from preSync to chasing once requisite frames have elapsed
        
        switch state {
        case let .preSync(_, prTimecode):
            if timecode >= prTimecode {
                state = .sync
            }
        default: break
        }
        
        // timer timeout condition
        let continuousQFTimeout = timespec(
            tv_sec: 0,
            tv_nsec: 50_000_000
        )
        
        let dropOutFramesDuration =
            Timecode(
                .components(f: syncPolicy.dropOutFrames),
                at: decoder.localFrameRate ?? .fps30,
                by: .wrapping
            )
            .realTimeValue
        
        let freewheelTimeout = timespec(dropOutFramesDuration)
        
        // if >20ms window of time since last quarter frame, assume MTC message stream has been
        // stopped/interrupted or being received at a speed less than realtime (ie: when Pro Tools
        // plays back at half-speed) and reset our internal tracker
        if clockDiff > continuousQFTimeout,
           clockDiff < freewheelTimeout
        {
            decoder.resetQFBuffer()
            
            state = .freewheeling
                
        } else if clockDiff > freewheelTimeout {
            state = .idle
            timer.stop()
        }
    }
}

// MARK: - ReceivesMIDIEvents

extension MTCReceiver: ReceivesMIDIEvents {
    public nonisolated func midiIn(event: MIDIEvent) {
        receiveQueue.async {
            self.decoder.midiIn(event: event)
        }
    }
}

// MARK: - Handler Methods

extension MTCReceiver {
    /// Internal: MTCDecoder handler proxy method
    func timecodeDidChange(
        to incomingTC: Timecode,
        event: MTCMessageType,
        direction: MTCDirection,
        isFrameChanged: Bool
    ) {
        // determine frame rate compatibility
        var frameRateIsCompatible = true
        
        if let localFrameRate = decoder.localFrameRate,
           !incomingTC.frameRate.isCompatible(with: localFrameRate)
        {
            frameRateIsCompatible = false
        }
        
        if event == .fullFrame,
           !frameRateIsCompatible
        {
            return
        }
        
        if event == .quarterFrame {
            // assess if MTC frame rate and local frame rate are compatible with each other
            if !frameRateIsCompatible {
                state = .incompatibleFrameRate
            } else if state == .incompatibleFrameRate {
                state = .freewheeling
            }
            
            // log quarter-frame timestamp
            let timeNow = clock_gettime_monotonic_raw()
            timeLastQuarterFrameReceived = timeNow
            
            // update state
            if state == .idle {
                state = .freewheeling
            }
            
            // start timer
            if !timer.running {
                timer.restart()
            }
        }
        
        // update class property
        timecode = incomingTC
        
        // notify handler to update display
        timecodeChangedHandler?(
            incomingTC,
            event,
            direction,
            isFrameChanged
        )
        
        if event == .quarterFrame {
            // update state
            if state == .freewheeling {
                if incomingTC - freewheelPreviousTimecode
                    == (try? Timecode(
                        .components(f: 1),
                        at: decoder.localFrameRate ?? incomingTC.frameRate
                    ))
                {
                    freewheelSequentialFrames += 1
                } else {
                    freewheelSequentialFrames = 0
                }
            }
            
            if state == .freewheeling,
               freewheelSequentialFrames <= syncPolicy.lockFrames
            {
                // enter preSync phase
                
                freewheelSequentialFrames = 0
                
                // calculate time until lock
                
                let preSyncFrames = Timecode(
                    .components(f: syncPolicy.lockFrames),
                    at: decoder.localFrameRate ?? incomingTC.frameRate,
                    by: .wrapping
                )
                let prerollDuration = Int(preSyncFrames.realTimeValue * 1_000_000) // microseconds
                
                let now = DispatchTime.now() // same as DispatchTime(rawValue: mach_absolute_time())
                let durationUntilLock = DispatchTimeInterval.microseconds(prerollDuration)
                let futureTime = now + durationUntilLock
                
                let lockTimecode = incomingTC.advanced(by: syncPolicy.lockFrames)
                
                // change receiver state
                
                state = .preSync(
                    predictedLockTime: futureTime,
                    lockTimecode: lockTimecode
                )
                
            } else if freewheelSequentialFrames >= syncPolicy.lockFrames {
                // enter chasing phase
                
                switch state {
                case .preSync:
                    state = .sync
                default: break
                }
            }
            
            // update registers
            freewheelPreviousTimecode = incomingTC
        }
    }
}
