//
//  MTCGenerator.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitCore
import MIDIKitIO
internal import MIDIKitInternals
import SwiftTimecodeCore

/// MTC sync generator.
public final class MTCGenerator: SendsMIDIEvents, @unchecked Sendable { // @unchecked required for @PThreadMutex use
    // MARK: - Public properties
    
    public let name: String
    
    /// The MTC SMPTE frame rate (24, 25, 29.97d, or 30) that was last transmitted by the generator.
    ///
    /// This property should only be inspected purely for developer informational or diagnostic
    /// purposes. For production code or any logic related to MTC, it should be ignored -- only the
    /// local ``timecode``.`frameRate` property is used for automatic selection of MTC SMPTE frame
    /// rate and scaling of outgoing timecode accordingly.
    public var mtcFrameRate: MTCFrameRate {
        generateQueue.sync { encoder.mtcFrameRate }
    }
    
    /// Generator state.
    @PThreadMutex
    public private(set) var state: State = .idle
    
    /// Internal flag
    @PThreadMutex
    private var shouldStart: Bool = true
    
    /// Property updated whenever outgoing MTC timecode changes.
    public var timecode: Timecode {
        generateQueue.sync { encoder.timecode }
    }
    
    public var localFrameRate: TimecodeFrameRate {
        generateQueue.sync { encoder.localFrameRate }
    }
    
    /// Behavior determining when MTC Full-Frame MIDI messages should be generated.
    ///
    /// ``MTCEncoder/FullFrameBehavior/ifDifferent`` is recommended and suitable for most
    /// implementations.
    @PThreadMutex
    public var locateBehavior: MTCEncoder.FullFrameBehavior = .ifDifferent
    
    // MARK: - Stored closures
    
    /// Closure called every time a MIDI message needs to be transmitted by the generator.
    ///
    /// - Note: Handler is called on a dedicated thread so do not make UI updates from it.
    public nonisolated(unsafe) var midiOutHandler: MIDIOutHandler?
    
    /// Set the closure called every time a MIDI message needs to be transmitted by the generator.
    ///
    /// - Note: Handler is called on a dedicated thread so do not make UI updates from it.
    public nonisolated func setMIDIOutHandler(_ handler: MIDIOutHandler?) {
        midiOutHandler = handler
    }
    
    // MARK: - init
    
    public init(
        name: String? = nil,
        midiOutHandler: MIDIOutHandler? = nil
    ) {
        // handle init arguments
        
        let name = name ?? UUID().uuidString
        self.name = name
        
        self.midiOutHandler = midiOutHandler
        
        // queues
        
        let generateQueueName = (Bundle.main.bundleIdentifier ?? "com.orchetect.midikit")
            + ".mtcGenerator." + name + ".generate"
        generateQueue = DispatchQueue(label: generateQueueName, qos: .userInitiated)
        
        // timer
        
        let newTimer = SafeDispatchTimer(
            rate: .seconds(1.0), // default, will be changed later
            queue: generateQueue,
            eventHandler: { }
        )
        timer = newTimer
        
        // encoder setup
        encoder = generateQueue.sync { MTCEncoder() }
        
        // set up handlers after self is initialized so we can capture reference to self
        
        newTimer.setEventHandler { [weak self] in
            self?.timerFired()
        }
        
        encoder.setMIDIOutHandler { [weak self] midiEvents in
            self?.midiOut(midiEvents)
        }
    }
    
    // MARK: - Queue (internal)
    
    private let generateQueue: DispatchQueue
    
    // MARK: - Encoder (internal)
    
    private let encoder: MTCEncoder
    
    // MARK: - Timer (internal)
    
    private nonisolated(unsafe) let timer: SafeDispatchTimer
    
    /// Internal: Fired from our timer object.
    func timerFired() {
        encoder.increment()
    }
    
    /// Sets timer rate to corresponding MTC quarter-frame duration in Hz.
    func setTimerRate(from frameRate: TimecodeFrameRate) {
        // const values generated from:
        // Timecode(.components(f: 1), at: frameRate).realTimeValue
        // double and quadruple rates use the same value as their 1x rate
        
        // duration in seconds for one quarter-frame
        let rate = switch frameRate {
        case .fps23_976:  0.010427083333333333
        case .fps24:      0.010416666666666666
        case .fps24_98:   0.010009999999999998
        case .fps25:      0.01
        case .fps29_97:   0.008341666666666666
        case .fps29_97d:  0.008341666666666666
        case .fps30:      0.008333333333333333
        case .fps30d:     0.008341666666666666
        case .fps47_952:  0.010427083333333333 // _23_976
        case .fps48:      0.010416666666666666 // _24
        case .fps50:      0.01                 // _25
        case .fps59_94:   0.008341666666666666 // _29_97
        case .fps59_94d:  0.008341666666666666 // _29_97_drop
        case .fps60:      0.008333333333333333 // _30
        case .fps60d:     0.008341666666666666 // _30_drop
        case .fps90:      0.008333333333333333 // _30
        case .fps95_904:  0.010427083333333333 // _23_976
        case .fps96:      0.010416666666666666 // _24
        case .fps100:     0.01                 // _25
        case .fps119_88:  0.008341666666666666 // _29_97
        case .fps119_88d: 0.008341666666666666 // _29_97_drop
        case .fps120:     0.008333333333333333 // _30
        case .fps120d:    0.008341666666666666 // _30_drop
        }
        
        timer.setRate(.seconds(rate))
    }
    
    // MARK: - Public methods
    
    /// Locate to a new timecode, while not generating continuous playback MIDI message stream.
    /// Sends a MTC full-frame message.
    ///
    /// > Note:
    /// >
    /// >`timecode` may contain `subframes > 0`. Subframes will be stripped prior to
    /// > transmitting the full-frame message since the resolution of MTC full-frame messages is 1
    /// > frame.
    public func locate(to timecode: Timecode) {
        encoder.locate(to: timecode, transmitFullFrame: locateBehavior)
        setTimerRate(from: encoder.localFrameRate)
    }
    
    /// Locate to a new timecode, while not generating continuous playback MIDI message stream.
    /// Sends a MTC full-frame message.
    ///
    /// > Note:
    /// >
    /// >`components` may contain `subframes > 0`. Subframes will be stripped prior to
    /// > transmitting the full-frame message since the resolution of MTC full-frame messages is 1
    /// > frame.
    public func locate(to components: Timecode.Components) {
        encoder.locate(to: components, transmitFullFrame: locateBehavior)
        setTimerRate(from: encoder.localFrameRate)
    }
    
    /// Starts generating MTC continuous playback MIDI message stream events.
    /// Call this method at the exact time that `timecode` occurs.
    ///
    /// Frame rate will be derived from the `timecode` instance passed in.
    ///
    /// > Note: It is not necessary to send a ``locate(to:)-18i4`` message simultaneously or
    /// > immediately prior, and is actually undesirable as it can confuse the receiving entity.
    ///
    /// Call ``stop()`` to stop generating events.
    public func start(now timecode: Timecode) {
        shouldStart = true
        
        // if subframes == 0, no scheduling is required
        
        if timecode.subFrames == 0 {
            generateQueue.sync {
                locateAndStart(
                    now: timecode.components,
                    frameRate: timecode.frameRate
                )
            }
            return
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
    /// > Note: It is not necessary to send a ``locate(to:)-18i4`` message simultaneously or
    /// > immediately prior, and is actually undesirable as it can confuse the receiving entity.
    ///
    /// Call ``stop()`` to stop generating events.
    public func start(
        now components: Timecode.Components,
        frameRate: TimecodeFrameRate,
        base: Timecode.SubFramesBase
    ) {
        shouldStart = true
        
        let tc = Timecode(
            .components(components),
            at: frameRate,
            base: base,
            by: .allowingInvalid
        )
        
        start(now: tc)
    }
    
    /// Starts generating MTC continuous playback MIDI message stream events.
    /// Call this method at the exact time that `realTime` occurs.
    ///
    /// > Note: It is not necessary to send a ``locate(to:)-18i4`` message simultaneously or
    /// > immediately prior, and is actually undesirable as it can confuse the receiving entity.
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
        
        shouldStart = true
        
        // convert real time to timecode at the given frame rate
        guard let inRTtoTimecode = try? Timecode(
            .realTime(seconds: realTime),
            at: frameRate,
            base: .max100SubFrames, // base doesn't matter, just for calculation
            limit: .max24Hours
        ) else { return }
        
        // if subframes == 0, no scheduling is required
        
        if inRTtoTimecode.subFrames == 0 {
            generateQueue.sync {
                locateAndStart(
                    now: inRTtoTimecode.components,
                    frameRate: inRTtoTimecode.frameRate
                )
            }
            return
        }
        
        // otherwise, we have to schedule MTC start for the near future
        // (the exact start of the next frame)
        
        // truncate subframes and advance 1 frame
        var tcAtNextEvenFrame = inRTtoTimecode
        tcAtNextEvenFrame.subFrames = 0
        try? tcAtNextEvenFrame.add(.components(f: 1), by: .wrapping)
        
        let secsToStartOfNextFrame = tcAtNextEvenFrame.realTimeValue - realTime
        
        let nsecsToStartOfNextFrame = UInt64(secsToStartOfNextFrame * 1_000_000_000)
        
        let nsecsDeadline = nsInDispatchTime + nsecsToStartOfNextFrame
        
        generateQueue.asyncAfter(
            deadline: DispatchTime(uptimeNanoseconds: nsecsDeadline),
            qos: .userInitiated
        ) { [tcAtNextEvenFrame] in
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
    func locateAndStart(
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
        
        state = .idle
        timer.stop()
    }
}
