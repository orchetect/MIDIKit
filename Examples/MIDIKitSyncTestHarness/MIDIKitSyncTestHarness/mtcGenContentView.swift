//
//  mtcGenContentView.swift
//  MIDIKitSyncTestHarness
//
//  Created by Steffan Andrews on 2020-12-02.
//

import Combine
import SwiftUI

import OTCore
import MIDIKit
import TimecodeKit
import SwiftRadix

struct mtcGenContentView: View {
	
	weak var midiManager: MIDIIO.Manager?
	
	init(midiManager: MIDIIO.Manager?) {
		// normally in SwiftUI we would pass midiManager in as an EnvironmentObject
		// but that only works on macOS 11.0+ and for sake of backwards compatibility
		// we will do it old-school weak delegate storage pattern
		self.midiManager = midiManager
	}
	
	// MARK: - MIDI state
	
	@State var mtcGen: MTC.Generator = .init()
	
	@State var localFrameRate: Timecode.FrameRate = ._24
	
	// MARK: - UI state
	
    @State var mtcGenState = false
	
	@State var generatorTC: String = ""
	
	// MARK: - Internal State
	
	@State private var lastSeconds = 0
    
	// MARK: - View
	
	var body: some View {
		
		VStack(alignment: .center, spacing: 8) {
			
			Text(generatorTC)
				.font(.system(size: 48, weight: .regular, design: .monospaced))
				.frame(maxWidth: .infinity)
			
			Spacer()
				.frame(height: 20)
			
			Button("Locate to " + TCC(h: 1).toTimecode(rawValuesAt: localFrameRate).stringValue) {
				locate()
			}
			.disabled(mtcGenState)
			
			HStack(alignment: .center, spacing: 8) {
				Button("Start") {
					mtcGenState = true
					if mtcGen.localFrameRate != localFrameRate {
						// update generator frame rate by triggering a locate
						locate()
					}
					mtcGen.start()
				}
				.disabled(mtcGenState)
				
				Button("Stop") {
					mtcGenState = false
					mtcGen.stop()
				}
				.disabled(!mtcGenState)
			}
			
			Spacer()
				.frame(height: 20)
			
			Picker("Local Frame Rate", selection: $localFrameRate) {
				ForEach(Timecode.FrameRate.allCases) { fRate in
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
			
		}
		.frame(minWidth: 400, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity, alignment: .center)
		.onAppear {
			
			// mtc generator endpoint
			do {
				let cachedUniqueID = UserDefaults.standard
					.integerOptional(forKey: "\(midiSources.MTCGen.tag) - Unique ID")?
					.int32
			
				if let newUniqueID = try midiManager?.addOutput(
					name: midiSources.MTCGen.name,
					tag: midiSources.MTCGen.tag,
					uniqueID: cachedUniqueID
				) {
					// update stored unique ID for the port
					UserDefaults.standard
						.setValue(newUniqueID, forKey: "\(midiSources.MTCGen.tag) - Unique ID")
				}
			} catch {
				Log.error(error)
			}
			
			// set up new MTC receiver and configure it
			mtcGen = MTC.Generator(
				name: "main",
				midiEventSendHandler: { midiMessage in
					try? midiManager?
						.managedOutputs[midiSources.MTCGen.tag]?
						.send(rawMessage: midiMessage)
					
					DispatchQueue.main.async {
						let tc = mtcGen.timecode
						generatorTC = tc.stringValue
						
						if tc.seconds != lastSeconds {
							if mtcGenState { playClickA() }
							lastSeconds = tc.seconds
						}
					}
				}
			)
			
			locate()
			
		}
		
    }
	
	func locate() {
		
		let tc = TCC(h: 1).toTimecode(rawValuesAt: localFrameRate)
		generatorTC = tc.stringValue
		mtcGen.locate(to: tc)
		
	}
	
}

struct mtcGenContentView_Previews: PreviewProvider {
	
    static var previews: some View {
		mtcGenContentView(midiManager: nil)
    }
	
}
