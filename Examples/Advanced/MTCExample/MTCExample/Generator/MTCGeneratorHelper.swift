//
//  MTCGeneratorHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import Foundation
import MIDIKitIO
import MIDIKitSync

/// Object responsible for managing a MTC (MIDI Timecode) generator port.
///
/// The class is bound to a dedicated background actor (`@MTCActor`) in order to give the MTC objects
/// and handlers a dedicated thread pool since their synchronization operations require high timing precision.
///
/// Observable properties that may result in UI updates are bound to `@MainActor`.
@MTCActor @Observable public final class MTCGeneratorHelper {
    @ObservationIgnored public nonisolated(unsafe) weak var midiManager: MIDIManager?
    @ObservationIgnored private var mtcGen: MTCGenerator?
    
    // MARK: - UI State
    
    @MainActor private(set) var mtcGenState = false
    @MainActor private(set) var generatorTC = Timecode(.zero, at: .fps24)
    
    // MARK: - Internal State
    
    @ObservationIgnored private var lastSeconds = 0
    
    nonisolated public init(midiManager: MIDIManager? = nil) {
        self.midiManager = midiManager
    }
    
    deinit { teardown() }
}

// MARK: - Static

extension MTCGeneratorHelper {
    enum MTCGeneratorPort {
        static let name = "MIDIKit MTC Out"
        static let tag = "MTCGen"
    }
}

// MARK: - Lifecycle

extension MTCGeneratorHelper {
    /// Run once after class initialization.
    public func bootstrap(midiManager: MIDIManager? = nil) {
        if let midiManager { self.midiManager = midiManager }
        mtcGen = generatorFactory()
        addPort()
    }
    
    nonisolated public func teardown() {
        // TODO: The commented-out line below is not totally necessary, but we require macOS 15.4 minimum target to gain `isolated deinit { }` support so that this teardown method can be called from deinit.
        // if let mtcGen, mtcGen.state != .idle { stop() }
        
        removePort()
    }
}

// MARK: - Receiver Factory

extension MTCGeneratorHelper {
    private func generatorFactory() -> MTCGenerator {
        MTCGenerator { [weak self] midiEvents in
            guard let self else { return }
            
            Task(priority: .userInitiated) { @MTCActor in
                try? port?.send(events: midiEvents)
            }
            
            Task { @MTCActor in
                guard let mtcGen = self.mtcGen else { return }
                let tc = mtcGen.timecode
                
                // NOTE: normally you should not run any UI updates from this MTCGenerator handler;
                // this is only being done here for sake of demonstration purposes.
                // an activity watcher is not provided for the MTCGenerator since
                // it is not typical that you would watch the activity of your own generator.
                
                Task { @MainActor in
                    self.generatorTC = tc
                }
                
                Task { @MTCActor in
                    if tc.seconds != self.lastSeconds {
                        self.lastSeconds = tc.seconds
                        Task { @MainActor in
                            if self.mtcGenState {
                                await AudioHelper.shared.playClickA()
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - MIDI I/O

extension MTCGeneratorHelper {
    nonisolated var port: MIDIOutput? {
        midiManager?.managedOutputs[MTCGeneratorPort.tag]
    }
    
    nonisolated func addPort() {
        guard let midiManager else { return }
        
        // don't recreate port if it already exists
        guard port == nil else { return }
            
        // create MTC generator MIDI endpoint
        do {
            logger.debug("Creating virtual output \"\(MTCGeneratorPort.name)\"")
            let udKey = "\(MTCGeneratorPort.tag) - Unique ID"
            try midiManager.addOutput(
                name: MTCGeneratorPort.name,
                tag: MTCGeneratorPort.tag,
                uniqueID: .userDefaultsManaged(key: udKey)
            )
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    nonisolated func removePort() {
        guard let midiManager else { return }
        
        guard port != nil else { return }
        logger.debug("Removing virtual output \"\(MTCGeneratorPort.name)\"")
        midiManager.remove(.output, .withTag(MTCGeneratorPort.tag))
    }
}

// MARK: - MTC Methods

extension MTCGeneratorHelper {
    /// Locate to a timecode, or `00:00:00:00` by default.
    public func locate(
        to components: Timecode.Components = .zero,
        localFrameRate: TimecodeFrameRate
    ) {
        guard let mtcGen else { return }
        
        let tc = Timecode(.components(components), at: localFrameRate, by: .allowingInvalid)
        Task { @MainActor in generatorTC = tc }
        mtcGen.locate(to: tc)
    }
    
    public func startAtCurrentTimecode(localFrameRate: TimecodeFrameRate) {
        guard let mtcGen else { return }
        
        if mtcGen.localFrameRate != localFrameRate {
            // update generator frame rate by triggering a locate
            locate(localFrameRate: localFrameRate)
        }
        
        Task { @MainActor in
            let generatorTC = generatorTC
            mtcGenState = true
            
            Task { @MTCActor in mtcGen.start(now: generatorTC) }
            
            let debugTimecode = generatorTC.stringValue()
            logger.debug("Starting at \(debugTimecode)")
        }
    }
    
    public func startAtTimecodeAsTimecode(localFrameRate: TimecodeFrameRate) {
        guard let mtcGen else { return }
        
        Task { @MainActor in mtcGenState = true }
        
        if mtcGen.localFrameRate != localFrameRate {
            // update generator frame rate by triggering a locate
            locate(localFrameRate: localFrameRate)
        }
        
        let startTC = Timecode(
            .components(h: 1, m: 00, s: 00, f: 00, sf: 35),
            at: localFrameRate,
            base: .max100SubFrames,
            by: .allowingInvalid
        )
        
        mtcGen.start(now: startTC)
    }
    
    public func startAtTimecodeAsTimecodeComponents(localFrameRate: TimecodeFrameRate) {
        guard let mtcGen else { return }
        
        Task { @MainActor in mtcGenState = true }
        
        if mtcGen.localFrameRate != localFrameRate {
            // update generator frame rate by triggering a locate
            locate(localFrameRate: localFrameRate)
        }
        
        let startTC = Timecode(
            .components(h: 1, m: 00, s: 00, f: 00, sf: 35),
            at: localFrameRate,
            base: .max100SubFrames,
            by: .allowingInvalid
        )
        
        mtcGen.start(
            now: startTC.components,
            frameRate: startTC.frameRate,
            base: startTC.subFramesBase
        )
    }
    
    public func startAtTimecodeAsTimeInterval(localFrameRate: TimecodeFrameRate) {
        guard let mtcGen else { return }
        
        Task { @MainActor in mtcGenState = true }
        
        if mtcGen.localFrameRate != localFrameRate {
            // update generator frame rate by triggering a locate
            locate(localFrameRate: localFrameRate)
        }
        
        let startRealTimeSeconds = Timecode(
            .components(h: 1, m: 00, s: 00, f: 00, sf: 35),
            at: localFrameRate,
            base: .max100SubFrames,
            by: .allowingInvalid
        )
        .realTimeValue
        
        mtcGen.start(
            now: startRealTimeSeconds,
            frameRate: localFrameRate
        )
    }
    
    public func stop() {
        Task { @MainActor in mtcGenState = false }
        
        guard let mtcGen else { return }
        
        mtcGen.stop()
    }
}

// MARK: - ViewModel Methods

extension MTCGeneratorHelper {
    public var locateBehavior: MTCEncoder.FullFrameBehavior {
        get async { mtcGen?.locateBehavior ?? .ifDifferent }
    }
    
    public func setLocateBehavior(_ behavior: MTCEncoder.FullFrameBehavior) {
        mtcGen?.locateBehavior = behavior
    }
    
    public var localFrameRate: TimecodeFrameRate? {
        mtcGen?.localFrameRate
    }
}
