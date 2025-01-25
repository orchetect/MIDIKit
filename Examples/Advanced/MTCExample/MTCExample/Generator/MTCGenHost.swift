//
//  MTCGenHost.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import MIDIKitIO
import MIDIKitSync
import SwiftUI

@Observable class MTCGenHost {
    @ObservationIgnored
    weak var midiManager: ObservableMIDIManager?
    
    @ObservationIgnored
    var mtcGen: MTCGenerator?
    
    // MARK: - Internal State
    
    private var lastSeconds = 0
    
    // MARK: - UI state
    
    private(set) var mtcGenState = false
    private(set) var generatorTC = Timecode(.zero, at: .fps24)
    
    init() {
        mtcGen = generatorFactory()
    }
    
    private func generatorFactory() -> MTCGenerator {
        MTCGenerator(
            name: "main",
            midiOutHandler: { [weak self] midiEvents in
                guard let self else { return }
                
                try? midiManager?
                    .managedOutputs[kMIDIPorts.MTCGen.tag]?
                    .send(events: midiEvents)
                
                // NOTE: normally you should not run any UI updates from this handler;
                // this is only being done here for sake of demonstration purposes.
                // an activity watcher is not provided for the MTC Generator since
                // it is not typical that you would watch the activity of your own gen.
                Task { @MainActor [weak self] in
                    guard let self, let mtcGen else { return }
                    
                    let tc = await mtcGen.timecode
                    generatorTC = tc
                    
                    if tc.seconds != lastSeconds {
                        if mtcGenState { playClickA() }
                        lastSeconds = tc.seconds
                    }
                }
            }
        )
    }
    
    func addPort(to midiManager: ObservableMIDIManager) {
        // create MTC generator MIDI endpoint
        do {
            let udKey = "\(kMIDIPorts.MTCGen.tag) - Unique ID"
            
            try midiManager.addOutput(
                name: kMIDIPorts.MTCGen.name,
                tag: kMIDIPorts.MTCGen.tag,
                uniqueID: .userDefaultsManaged(key: udKey)
            )
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    /// Locate to a timecode, or 00:00:00:00 by default.
    func locate(
        to components: Timecode.Components = .init(h: 00, m: 00, s: 00, f: 00),
        localFrameRate: TimecodeFrameRate
    ) {
        let tc = Timecode(.components(components), at: localFrameRate, by: .allowingInvalid)
        generatorTC = tc
        Task { await mtcGen?.locate(to: tc) }
    }
    
    func startAtCurrentTimecode(localFrameRate: TimecodeFrameRate) {
        Task {
            guard let mtcGen else { return }
            
            mtcGenState = true
            if await mtcGen.localFrameRate != localFrameRate {
                // update generator frame rate by triggering a locate
                locate(localFrameRate: localFrameRate)
            }
            logger.debug("Starting at \(self.generatorTC.stringValue())")
            await mtcGen.start(now: generatorTC)
        }
    }
    
    func startAtTimecodeAsTimecode(localFrameRate: TimecodeFrameRate) {
        Task {
            guard let mtcGen else { return }
            
            mtcGenState = true
            if await mtcGen.localFrameRate != localFrameRate {
                // update generator frame rate by triggering a locate
                locate(localFrameRate: localFrameRate)
            }
            
            let startTC = Timecode(
                .components(h: 1, m: 00, s: 00, f: 00, sf: 35),
                at: localFrameRate,
                base: .max100SubFrames,
                by: .allowingInvalid
            )
            
            await mtcGen.start(now: startTC)
        }
    }
    
    func startAtTimecodeAsTimecodeComponents(localFrameRate: TimecodeFrameRate) {
        Task {
            guard let mtcGen else { return }
            
            mtcGenState = true
            if await mtcGen.localFrameRate != localFrameRate {
                // update generator frame rate by triggering a locate
                locate(localFrameRate: localFrameRate)
            }
            
            let startTC = Timecode(
                .components(h: 1, m: 00, s: 00, f: 00, sf: 35),
                at: localFrameRate,
                base: .max100SubFrames,
                by: .allowingInvalid
            )
            
            await mtcGen.start(
                now: startTC.components,
                frameRate: startTC.frameRate,
                base: startTC.subFramesBase
            )
        }
    }
    
    func startAtTimecodeAsTimeInterval(localFrameRate: TimecodeFrameRate) {
        Task {
            guard let mtcGen else { return }
            
            mtcGenState = true
            if await mtcGen.localFrameRate != localFrameRate {
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
            
            await mtcGen.start(
                now: startRealTimeSeconds,
                frameRate: localFrameRate
            )
        }
    }
    
    func stop() {
        Task {
            guard let mtcGen else { return }
            
            mtcGenState = false
            await mtcGen.stop()
        }
    }
}
