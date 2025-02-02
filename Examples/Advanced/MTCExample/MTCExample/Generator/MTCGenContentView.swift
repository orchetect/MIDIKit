//
//  MTCGenContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Combine
import MIDIKitIO
import MIDIKitSync
import SwiftRadix
import SwiftUI
import TimecodeKitCore
import TimecodeKitUI

struct MTCGenContentView: View {
    @Environment(ObservableMIDIManager.self) private var midiManager
    @State private var mtcGenHost = MTCGenHost()
    
    // MARK: - Prefs
    
    @AppStorage("mtcGen-localFrameRate")
    var localFrameRate: TimecodeFrameRate = .fps24
    
    @AppStorage("mtcGen-locateBehavior")
    var locateBehavior: MTCEncoder.FullFrameBehavior = .ifDifferent
    
    // MARK: - View
    
    var body: some View {
        mtcGenView
            .onAppear { setup() }
    }
    
    private func setup() {
        mtcGenHost.midiManager = midiManager
        mtcGenHost.addPort(to: midiManager)
        
        mtcGenHost.mtcGen?.locateBehavior = locateBehavior
        
        locate()
    }
    
    private var mtcGenView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(mtcGenHost.generatorTC.stringValue())
                .font(.system(size: 48, weight: .regular, design: .monospaced))
                .frame(maxWidth: .infinity)
            
            Spacer()
                .frame(height: 15)
            
            VStack {
                Button(locateTo1HourTimecodeTitle) {
                    locateTo1HourTimecode()
                }
                .disabled(mtcGenHost.mtcGenState)
                
                Button(startAtCurrentTimecodeTitle) {
                    startAtCurrentTimecode()
                }
                .disabled(mtcGenHost.mtcGenState)
                
                Button(startAtTimecodeAsTimecodeTitle) {
                    startAtTimecodeAsTimecode()
                }
                .disabled(mtcGenHost.mtcGenState)
                
                Button(startAtTimecodeAsTimecodeComponentsTitle) {
                    startAtTimecodeAsTimecodeComponents()
                }
                .disabled(mtcGenHost.mtcGenState)
                
                Button(startAtTimecodeAsTimeIntervalTitle) {
                    startAtTimecodeAsTimeInterval()
                }
                .disabled(mtcGenHost.mtcGenState)
                
                Button("Stop") {
                    stop()
                }
                .disabled(!mtcGenHost.mtcGenState)
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
            .disabled(mtcGenHost.mtcGenState)
            .onHover { _ in
                guard !mtcGenHost.mtcGenState else { return }
                
                // this is a SwiftUI workaround, but it works fine for our purposes
                if mtcGenHost.mtcGen?.localFrameRate != localFrameRate {
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
            .disabled(mtcGenHost.mtcGenState)
            .onHover { _ in
                guard !mtcGenHost.mtcGenState else { return }
                
                // this is a stupid SwiftUI workaround, but it works fine for our purposes
                if mtcGenHost.mtcGen?.locateBehavior != locateBehavior {
                    mtcGenHost.mtcGen?.locateBehavior = locateBehavior
                }
            }
        }
        .frame(
            minWidth: 400, maxWidth: .infinity,
            minHeight: 300, maxHeight: .infinity,
            alignment: .center
        )
    }
    
    private func locate(
        to components: Timecode.Components = .init(h: 00, m: 00, s: 00, f: 00)
    ) {
        mtcGenHost.locate(to: components, localFrameRate: localFrameRate)
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
        mtcGenHost.startAtCurrentTimecode(localFrameRate: localFrameRate)
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
        mtcGenHost.startAtTimecodeAsTimecode(localFrameRate: localFrameRate)
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
        mtcGenHost.startAtTimecodeAsTimecodeComponents(localFrameRate: localFrameRate)
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
        mtcGenHost.startAtTimecodeAsTimeInterval(localFrameRate: localFrameRate)
    }
    
    private func stop() {
        mtcGenHost.stop()
    }
}

#Preview {
    @Previewable @State var midiManager = ObservableMIDIManager(
        clientName: "Preview",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    MTCGenContentView()
        .environment(midiManager)
}
