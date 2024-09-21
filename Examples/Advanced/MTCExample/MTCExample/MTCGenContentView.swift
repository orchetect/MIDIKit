//
//  MTCGenContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Combine
import MIDIKitIO
import MIDIKitSync
import OTCore
import SwiftRadix
import SwiftUI
import TimecodeKit

struct MTCGenContentView: View {
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    
    // MARK: - MIDI state
    
    @State var mtcGen: MTCGenerator = .init()
    
    @AppStorage("mtcGen-localFrameRate")
    var localFrameRate: TimecodeFrameRate = .fps24
    
    @AppStorage("mtcGen-locateBehavior")
    var locateBehavior: MTCEncoder.FullFrameBehavior = .ifDifferent
    
    // MARK: - UI state
    
    @State var mtcGenState = false
    @State var generatorTC: Timecode = .init(.zero, at: .fps24)
    
    // MARK: - Internal State
    
    @State private var lastSeconds = 0
    
    // MARK: - View
    
    var body: some View {
        mtcGenView
            .onAppear {
                setup()
            }
    }
    
    private func setup() {
        // create MTC generator MIDI endpoint
        do {
            let udKey = "\(kMIDIPorts.MTCGen.tag) - Unique ID"
            
            try midiManager.addOutput(
                name: kMIDIPorts.MTCGen.name,
                tag: kMIDIPorts.MTCGen.tag,
                uniqueID: .userDefaultsManaged(key: udKey)
            )
        } catch {
            logger.error(error)
        }
        
        // set up new MTC receiver and configure it
        mtcGen = MTCGenerator(
            name: "main",
            midiOutHandler: { midiEvents in
                try? midiManager
                    .managedOutputs[kMIDIPorts.MTCGen.tag]?
                    .send(events: midiEvents)
                
                // NOTE: normally you should not run any UI updates from this handler;
                // this is only being done here for sake of demonstration purposes.
                // an activity watcher is not provided for the MTC Generator since
                // it is not typical that you would watch the activity of your own gen.
                DispatchQueue.main.async {
                    let tc = mtcGen.timecode
                    generatorTC = tc
                    
                    if tc.seconds != lastSeconds {
                        if mtcGenState { playClickA() }
                        lastSeconds = tc.seconds
                    }
                }
            }
        )
        
        mtcGen.locateBehavior = locateBehavior
        
        locate()
    }
    
    private var mtcGenView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(generatorTC.stringValue())
                .font(.system(size: 48, weight: .regular, design: .monospaced))
                .frame(maxWidth: .infinity)
            
            Spacer()
                .frame(height: 15)
            
            VStack {
                Button(locateTo1HourTimecodeTitle) {
                    locateTo1HourTimecode()
                }
                .disabled(mtcGenState)
                
                Button(startAtCurrentTimecodeTitle) {
                    startAtCurrentTimecode()
                }
                .disabled(mtcGenState)
                
                Button(startAtTimecodeAsTimecodeTitle) {
                    startAtTimecodeAsTimecode()
                }
                .disabled(mtcGenState)
                
                Button(startAtTimecodeAsTimecodeComponentsTitle) {
                    startAtTimecodeAsTimecodeComponents()
                }
                .disabled(mtcGenState)
                
                Button(startAtTimecodeAsTimeIntervalTitle) {
                    startAtTimecodeAsTimeInterval()
                }
                .disabled(mtcGenState)
                
                Button("Stop") {
                    stop()
                }
                .disabled(!mtcGenState)
            }
            
            Spacer()
                .frame(height: 15)
            
            Picker("Local Frame Rate", selection: $localFrameRate) {
                ForEach(TimecodeFrameRate.allCases) { fRate in
                    Text(fRate.stringValue)
                        .tag(fRate)
                }
            }
            .frame(width: 250)
            .disabled(mtcGenState)
            .onHover { _ in
                guard !mtcGenState else { return }
                
                // this is a stupid SwiftUI workaround, but it works fine for our purposes
                if mtcGen.localFrameRate != localFrameRate {
                    locate()
                }
            }
            
            Text("will be transmit as \(localFrameRate.mtcFrameRate.stringValue)")
            
            Spacer()
                .frame(height: 15)
            
            Picker("Locate Behavior", selection: $locateBehavior) {
                ForEach(
                    MTCEncoder.FullFrameBehavior.allCases,
                    id: \.self
                ) { locateBehaviorType in
                    Text(locateBehaviorType.nameForUI)
                        .tag(locateBehaviorType)
                }
            }
            .frame(width: 250)
            .disabled(mtcGenState)
            .onHover { _ in
                guard !mtcGenState else { return }
                
                // this is a stupid SwiftUI workaround, but it works fine for our purposes
                if mtcGen.locateBehavior != locateBehavior {
                    mtcGen.locateBehavior = locateBehavior
                }
            }
        }
        .frame(
            minWidth: 400, maxWidth: .infinity,
            minHeight: 300, maxHeight: .infinity,
            alignment: .center
        )
    }
    
    /// Locate to a timecode, or 00:00:00:00 by default.
    private func locate(
        to components: Timecode.Components = .init(h: 00, m: 00, s: 00, f: 00)
    ) {
        let tc = Timecode(.components(components), at: localFrameRate, by: .allowingInvalid)
        generatorTC = tc
        mtcGen.locate(to: tc)
    }
}

extension MTCGenContentView {
    private var locateTo1HourTimecodeTitle: String {
        "Locate to "
        + Timecode(
            .components(h: 1, m: 00, s: 00, f: 00, sf: 00),
            at: localFrameRate,
            base: .max100SubFrames,
            by: .allowingInvalid
        )
        .stringValue(format: [.showSubFrames])
    }
    
    private func locateTo1HourTimecode() {
        locate(to: .init(h: 1, m: 00, s: 00, f: 00, sf: 00))
    }
    
    private var startAtCurrentTimecodeTitle: String {
        "Start at Current Timecode"
    }
    
    private func startAtCurrentTimecode() {
        mtcGenState = true
        if mtcGen.localFrameRate != localFrameRate {
            // update generator frame rate by triggering a locate
            locate()
        }
        logger.debug("Starting at \(generatorTC.stringValue())")
        mtcGen.start(now: generatorTC)
    }
    
    private var startAtTimecodeAsTimecodeTitle: String {
        "Start at "
            + Timecode(
                .components(h: 1, m: 00, s: 00, f: 00, sf: 35),
                at: localFrameRate,
                base: .max100SubFrames,
                by: .allowingInvalid
            )
            .stringValue(format: [.showSubFrames])
            + " (as Timecode)"
    }
    
    private func startAtTimecodeAsTimecode() {
        mtcGenState = true
        if mtcGen.localFrameRate != localFrameRate {
            // update generator frame rate by triggering a locate
            locate()
        }
        
        let startTC = Timecode(
            .components(h: 1, m: 00, s: 00, f: 00, sf: 35),
            at: localFrameRate,
            base: .max100SubFrames,
            by: .allowingInvalid
        )
        
        mtcGen.start(now: startTC)
    }
    
    private var startAtTimecodeAsTimecodeComponentsTitle: String {
        "Start at "
            + Timecode(
                .components(h: 1, m: 00, s: 00, f: 00, sf: 35),
                at: localFrameRate,
                base: .max100SubFrames,
                by: .allowingInvalid
            )
            .stringValue(format: [.showSubFrames])
            + " (as Timecode Components)"
    }
    
    private func startAtTimecodeAsTimecodeComponents() {
        mtcGenState = true
        if mtcGen.localFrameRate != localFrameRate {
            // update generator frame rate by triggering a locate
            locate()
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
    
    private var startAtTimecodeAsTimeIntervalTitle: String {
        "Start at "
            + Timecode(
                .components(h: 1, m: 00, s: 00, f: 00, sf: 35),
                at: localFrameRate,
                base: .max100SubFrames,
                by: .allowingInvalid
            )
            .stringValue(format: [.showSubFrames])
            + " (as TimeInterval)"
    }
    
    private func startAtTimecodeAsTimeInterval() {
        mtcGenState = true
        if mtcGen.localFrameRate != localFrameRate {
            // update generator frame rate by triggering a locate
            locate()
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
    
    private func stop() {
        mtcGenState = false
        mtcGen.stop()
    }
}

struct MTCGenContentViewPreviews: PreviewProvider {
    private static let midiManager = ObservableMIDIManager(
        clientName: "Preview",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    static var previews: some View {
        MTCGenContentView()
            .environmentObject(midiManager)
    }
}
