//
//  MTCGenerator.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
@_implementationOnly import MIDIKitInternals
import TimecodeKit

/// MTC sync generator.
public final class MTCGenerator: SendsMIDIEvents {
    // MARK: - Public properties
        
    public private(set) var name: String
        
    /// The MTC SMPTE frame rate (24, 25, 29.97d, or 30) that was last transmitted by the generator.
    ///
    /// This property should only be inspected purely for developer informational or diagnostic
    /// purposes. For production code or any logic related to MTC, it should be ignored -- only the
    /// local ``timecode``.`frameRate` property is used for automatic selection of MTC SMPTE frame
    /// rate and scaling of outgoing timecode accordingly.
    public var mtcFrameRate: MTCFrameRate {
        var getMTCFrameRate: MTCFrameRate!
            
        queue.sync {
            getMTCFrameRate = encoder.mtcFrameRate
        }
            
        return getMTCFrameRate
    }
        
    @ThreadSafeAccess
    public private(set) var state: State = .idle
        
    /// Internal var
    @ThreadSafeAccess
    private var shouldStart = true
        
    /// Property updated whenever outgoing MTC timecode changes.
    public var timecode: Timecode {
        var getTimecode: Timecode!
            
        queue.sync {
            getTimecode = encoder.timecode
        }
            
        return getTimecode
    }
        
    public var localFrameRate: TimecodeFrameRate {
        var getFrameRate: TimecodeFrameRate!
            
        queue.sync {
            getFrameRate = encoder.localFrameRate
        }
            
        return getFrameRate
    }
        
    /// Behavior determining when MTC Full-Frame MIDI messages should be generated.
    ///
    /// ``MTCEncoder/FullFrameBehavior/ifDifferent`` is recommended and suitable for most
    /// implementations.
    @ThreadSafeAccess
    public var locateBehavior: MTCEncoder.FullFrameBehavior = .ifDifferent
        
    // MARK: - Stored closures
        
    /// Closure called every time a MIDI message needs to be transmitted by the generator.
    ///
    /// - Note: Handler is called on a dedicated thread so do not make UI updates from it.
    public var midiOutHandler: MIDIOutHandler?
        
    // MARK: - init
        
    public init(
        name: String? = nil,
        midiOutHandler: MIDIOutHandler? = nil
    ) {
        // handle init arguments
            
        let name = name ?? UUID().uuidString
            
        self.name = name
            
        self.midiOutHandler = midiOutHandler
            
        // queue
            
        queue = DispatchQueue(
            label: "midikit.mtcgenerator.\(name)",
            qos: .userInitiated
        )
            
        // timer
            
        timer = SafeDispatchTimer(
            rate: .seconds(1.0), // default, will be changed later
            queue: queue,
            eventHandler: { }
        )
            
        timer.setEventHandler { [weak self] in
                
            guard let strongSelf = self else { return }
                
            strongSelf.timerFired()
        }
            
        queue.sync {
            // encoder setup
                
            encoder = MTCEncoder()
                
            encoder.midiOutHandler = { [weak self] midiEvents in
                    
                guard let strongSelf = self else { return }
                    
                strongSelf.midiOut(midiEvents)
            }
        }
    }
        
    // MARK: - Queue (internal)
        
    /// Maintain a high-priority internal thread
    internal var queue: DispatchQueue
        
    // MARK: - Encoder (internal)
        
    internal var encoder = MTCEncoder()
        
    // MARK: - Timer (internal)
        
    internal var timer: SafeDispatchTimer
        
    /// Internal: Fired from our timer object.
    internal func timerFired() {
        encoder.increment()
    }
        
    /// Sets timer rate to corresponding MTC quarter-frame duration in Hz.
    internal func setTimerRate(from frameRate: TimecodeFrameRate) {
        // const values generated from:
        // TCC(f: 1).toTimecode(at: frameRate).realTimeValue
        // double and quadruple rates use the same value as their 1x rate
        
        // duration in seconds for one quarter-frame
        let rate: Double
        
        switch frameRate {
        case ._23_976:      rate = 0.010427083333333333
        case ._24:          rate = 0.010416666666666666
        case ._24_98:       rate = 0.010009999999999998
        case ._25:          rate = 0.01
        case ._29_97:       rate = 0.008341666666666666
        case ._29_97_drop:  rate = 0.008341666666666666
        case ._30:          rate = 0.008333333333333333
        case ._30_drop:     rate = 0.008341666666666666
        case ._47_952:      rate = 0.010427083333333333 // _23_976
        case ._48:          rate = 0.010416666666666666 // _24
        case ._50:          rate = 0.01                 // _25
        case ._59_94:       rate = 0.008341666666666666 // _29_97
        case ._59_94_drop:  rate = 0.008341666666666666 // _29_97_drop
        case ._60:          rate = 0.008333333333333333 // _30
        case ._60_drop:     rate = 0.008341666666666666 // _30_drop
        case ._95_904:      rate = 0.010427083333333333 // _23_976
        case ._96:          rate = 0.010416666666666666 // _24
        case ._100:         rate = 0.01                 // _25
        case ._119_88:      rate = 0.008341666666666666 // _29_97
        case ._119_88_drop: rate = 0.008341666666666666 // _29_97_drop
        case ._120:         rate = 0.008333333333333333 // _30
        case ._120_drop:    rate = 0.008341666666666666 // _30_drop
        }
        
        timer.setRate(.seconds(rate))
    }
        
    // MARK: - Public methods
        
    /// Locate to a new timecode, while not generating continuous playback MIDI message stream.
    /// Sends a MTC full-frame message.
    ///
    /// - Note: `timecode` may contain `subframes > 0`. Subframes will be stripped prior to
    /// transmitting the full-frame message since the resolution of MTC full-frame messages is 1
    /// frame.
    public func locate(to timecode: Timecode) {
        queue.sync {
            encoder.locate(to: timecode, transmitFullFrame: locateBehavior)
            setTimerRate(from: encoder.localFrameRate)
        }
    }
        
    /// Locate to a new timecode, while not generating continuous playback MIDI message stream.
    /// Sends a MTC full-frame message.
    ///
    /// > Note: `components` may contain `subframes > 0`. Subframes will be stripped prior to
    /// transmitting the full-frame message since the resolution of MTC full-frame messages is 1
    /// frame.
    public func locate(to components: Timecode.Components) {
        queue.sync {
            encoder.locate(to: components, transmitFullFrame: locateBehavior)
            setTimerRate(from: encoder.localFrameRate)
        }
    }
        
    /// Starts generating MTC continuous playback MIDI message stream events.
    /// Call this method at the exact time that `timecode` occurs.
    ///
    /// Frame rate will be derived from the `timecode` instance passed in.
    ///
    /// > Note: It is not necessary to send a ``locate(to:)-1u162`` message simultaneously or
    /// immediately prior, and is actually undesirable as it can confuse the receiving entity.
    ///
    /// Call ``stop()`` to stop generating events.
    public func start(now timecode: Timecode) {
        queue.sync {
            shouldStart = true
                
            // if subframes == 0, no scheduling is required
                
            if timecode.subFrames == 0 {
                locateAndStart(
                    now: timecode.components,
                    frameRate: timecode.frameRate
                )
                return
            }
        }
            
        // if subframes > 0, scheduling is required to synchronize
        // MTC generation start to be at the exact start of the next frame
            
        // pass it on to the start method that handles scheduling
            
        start(
            now: timecode.realTimeValue,
            frameRate: timecode.frameRate
        )
    }
        
    /// Starts generating MTC continuous playback MIDI message stream events.
    /// Call this method at the exact time that `realTime` occurs.
    ///
    /// > Note: It is not necessary to send a ``locate(to:)-1u162`` message simultaneously or
    /// immediately prior, and is actually undesirable as it can confuse the receiving entity.
    ///
    /// Call ``stop()`` to stop generating events.
    public func start(
        now components: Timecode.Components,
        frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase
    ) {
        queue.sync {
            shouldStart = true
        }
            
        let tc = Timecode(
            rawValues: components,
            at: frameRate,
            base: base
        )
            
        start(now: tc)
    }
        
    /// Starts generating MTC continuous playback MIDI message stream events.
    /// Call this method at the exact time that `realTime` occurs.
    ///
    /// > Note: It is not necessary to send a ``locate(to:)-1u162`` message simultaneously or
    /// immediately prior, and is actually undesirable as it can confuse the receiving entity.
    ///
    /// Call ``stop()`` to stop generating events.
    public func start(
        now realTime: TimeInterval,
        frameRate: TimecodeFrameRate
    ) {
        // since realTime can be between frames,
        // we need to ensure that MTC quarter-frames begin generating
        // on the start of an exact frame.
        // this may involve scheduling the start of MTC generation
        // to be in the near future (on the order of milliseconds)
            
        let nsInDispatchTime = DispatchTime.now().uptimeNanoseconds
            
        queue.sync {
            shouldStart = true
        }
            
        // convert real time to timecode at the given frame rate
        guard let inRTtoTimecode = try? Timecode(
            realTime: realTime,
            at: frameRate,
            limit: ._24hours,
            base: ._100SubFrames // base doesn't matter, just for calculation
        ) else { return }
            
        // if subframes == 0, no scheduling is required
            
        if inRTtoTimecode.subFrames == 0 {
            locateAndStart(
                now: inRTtoTimecode.components,
                frameRate: inRTtoTimecode.frameRate
            )
            return
        }
            
        // otherwise, we have to schedule MTC start for the near future
        // (the exact start of the next frame)
            
        // truncate subframes and advance 1 frame
        var tcAtNextEvenFrame = inRTtoTimecode
        tcAtNextEvenFrame.subFrames = 0
        tcAtNextEvenFrame.add(wrapping: TCC(f: 1))
            
        let secsToStartOfNextFrame = tcAtNextEvenFrame.realTimeValue - realTime
            
        let nsecsToStartOfNextFrame = UInt64(secsToStartOfNextFrame * 1_000_000_000)
            
        let nsecsDeadline = nsInDispatchTime + nsecsToStartOfNextFrame
            
        queue.asyncAfter(
            deadline: .init(uptimeNanoseconds: nsecsDeadline),
            qos: .userInitiated
        ) {
            guard self.shouldStart else { return }
                
            self.locateAndStart(
                now: tcAtNextEvenFrame.components,
                frameRate: tcAtNextEvenFrame.frameRate
            )
        }
    }
        
    /// Internal: called from all other `start(...)` methods when they are finally ready to initiate
    /// the start of MTC generation.
    /// - Note: This method assumes `subframes == 0`.
    /// - Important: This must be called on `self.queue`.
    internal func locateAndStart(
        now components: Timecode.Components,
        frameRate: TimecodeFrameRate
    ) {
        encoder.locate(
            to: components,
            frameRate: frameRate,
            transmitFullFrame: .never
        )
            
        if state == .generating {
            timer.stop()
        }
            
        state = .generating
            
        setTimerRate(from: encoder.localFrameRate)
        timer.restart()
    }
        
    /// Stops generating MTC continuous playback MIDI message stream events.
    public func stop() {
        shouldStart = false
            
        queue.sync {
            state = .idle
                
            timer.stop()
        }
    }
}
