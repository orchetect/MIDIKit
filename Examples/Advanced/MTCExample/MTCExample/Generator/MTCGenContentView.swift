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
import SwiftTimecodeCore
import SwiftTimecodeUI

struct MTCGenContentView: View {
    @Environment(MIDIHelper.self) private var midiHelper
    @State private var mtcGeneratorHelper = MTCGeneratorHelper()
    
    // MARK: - Prefs
    
    @AppStorage("mtcGen-localFrameRate")
    var localFrameRate: TimecodeFrameRate = .fps24
    
    @AppStorage("mtcGen-locateBehavior")
    var locateBehavior: MTCEncoder.FullFrameBehavior = .ifDifferent
    
    // MARK: - View
    
    var body: some View {
        mtcGenView
            .task { await setup() }
    }
    
    private func setup() async {
        await mtcGeneratorHelper.bootstrap(midiManager: midiHelper.midiManager)
        await mtcGeneratorHelper.setLocateBehavior(locateBehavior)
        locate()
    }
    
    private var mtcGenView: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(mtcGeneratorHelper.generatorTC.stringValue())
                .font(.system(size: 48, weight: .regular, design: .monospaced))
                .frame(maxWidth: .infinity)
            
            Spacer()
                .frame(height: 15)
            
            VStack {
                Button(locateTo1HourTimecodeTitle) {
                    locateTo1HourTimecode()
                }
                .disabled(mtcGeneratorHelper.mtcGenState)
                
                Button(startAtCurrentTimecodeTitle) {
                    startAtCurrentTimecode()
                }
                .disabled(mtcGeneratorHelper.mtcGenState)
                
                Button(startAtTimecodeAsTimecodeTitle) {
                    startAtTimecodeAsTimecode()
                }
                .disabled(mtcGeneratorHelper.mtcGenState)
                
                Button(startAtTimecodeAsTimecodeComponentsTitle) {
                    startAtTimecodeAsTimecodeComponents()
                }
                .disabled(mtcGeneratorHelper.mtcGenState)
                
                Button(startAtTimecodeAsTimeIntervalTitle) {
                    startAtTimecodeAsTimeInterval()
                }
                .disabled(mtcGeneratorHelper.mtcGenState)
                
                Button("Stop") {
                    stop()
                }
                .disabled(!mtcGeneratorHelper.mtcGenState)
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
            .disabled(mtcGeneratorHelper.mtcGenState)
            .onHover { _ in
                guard !mtcGeneratorHelper.mtcGenState else { return }
                
                Task {
                    // this is a SwiftUI workaround, but it works fine for our purposes
                    if await mtcGeneratorHelper.localFrameRate != localFrameRate {
                        locate()
                    }
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
            .disabled(mtcGeneratorHelper.mtcGenState)
            .onHover { _ in
                guard !mtcGeneratorHelper.mtcGenState else { return }
                
                Task {
                    // this is a stupid SwiftUI workaround, but it works fine for our purposes
                    if await mtcGeneratorHelper.locateBehavior != locateBehavior {
                        await mtcGeneratorHelper.setLocateBehavior(locateBehavior)
                    }
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
        Task {
            await mtcGeneratorHelper.locate(to: components, localFrameRate: localFrameRate)
        }
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
        Task {
            await mtcGeneratorHelper.startAtCurrentTimecode(localFrameRate: localFrameRate)
        }
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
        Task {
            await mtcGeneratorHelper.startAtTimecodeAsTimecode(localFrameRate: localFrameRate)
        }
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
        Task {
            await mtcGeneratorHelper.startAtTimecodeAsTimecodeComponents(localFrameRate: localFrameRate)
        }
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
        Task {
            await mtcGeneratorHelper.startAtTimecodeAsTimeInterval(localFrameRate: localFrameRate)
        }
    }
    
    private func stop() {
        Task {
            await mtcGeneratorHelper.stop()
        }
    }
}

#Preview {
    @Previewable @State var midiHelper = MIDIHelper(start: true)
    
    MTCGenContentView()
        .environment(midiHelper)
}
