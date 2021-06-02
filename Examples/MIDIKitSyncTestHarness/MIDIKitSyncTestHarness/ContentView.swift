//
//  ContentView.swift
//  MIDIKitSyncTestHarness
//
//  Created by Steffan Andrews on 2020-12-02.
//

import Combine
import SwiftUI

import OTCore
import MIDIKit
import TimecodeKit

struct ContentView: View {
	
	// MARK: - MIDI state
	
	var midiManager: MIDIIO.Manager = .init(
		clientName: "MIDIKitSyncTestHarness",
		model: "TestApp",
		manufacturer: "Orchetect",
		notificationHandler: nil
	)
	
	@State var mtcRec: MTC.Receiver = .init(name: "dummy - will be set in .onAppear{} below")
	
	// MARK: - UI state
	
    @State var receiverTC = "--:--:--:--"
	
	@State var receiverFR: MTC.MTCFrameRate? = nil
	
    @State var receiverState: MTC.Receiver.State = .idle {
		// Note: be aware didSet will trigger here on a @State var when the variable is imperatively set in code, but not when altered by a $receiverState binding in SwiftUI
		didSet {
			Log.default("MTC Receiver state:", receiverState)
		}
	}
	
	@State var localFrameRate: Timecode.FrameRate? = nil
	
	// MARK: - Internal State
	
    @State var scheduledLock: Cancellable? = nil

    @State private var lastSeconds = 0
	
	// MARK: - View
	
	var body: some View {
		
		VStack(alignment: .center, spacing: 0) {
			
            Text(receiverTC)
                .font(.system(size: 48, weight: .regular, design: .monospaced))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
			
			Group {
				if receiverState != .idle {
					Text("MTC encoded rate: " + (receiverFR?.stringValue ?? "--") + " fps")
					
				} else {
					Text(" ")
				}
			}
			.font(.system(size: 24, weight: .regular, design: .default))
				
			if receiverState != .idle,
			   let receiverFR = receiverFR {
				VStack {
					Text("Derived frame rates of \(receiverFR.stringValue):")
					
					HStack {
						ForEach(receiverFR.derivedFrameRates, id: \.self) {
							Text($0.stringValue)
								.foregroundColor($0 == localFrameRate ? .blue : nil)
								.padding(2)
								.border(Color.white,
										width: $0 == receiverFR.directEquivalentFrameRate ? 2 : 0)
						}
					}
				}
			} else {
				VStack {
					Text(" ")
					Text(" ")
						.padding(2)
				}
			}
			
			Group {
				if receiverState != .idle,
				   localFrameRate != nil {
					
					if receiverState == .incompatibleFrameRate {
						Text("Can't scale frame rate because rates are incompatible.")
					} else if receiverFR?.directEquivalentFrameRate == localFrameRate {
						Text("Scaling not needed, rates are identical.")
					} else {
						Text("Scaled to local rate: " + (localFrameRate?.stringValue ?? "--") + " fps")
					}
					
				} else {
					Text(" ")
				}
			}
			.font(.system(size: 24, weight: .regular, design: .default))
				
            Text(receiverState.description)
				.font(.system(size: 48, weight: .regular, design: .monospaced))
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				
			Picker(selection: $localFrameRate, label: Text("Local Frame Rate")) {
				Text("None")
					.tag(Timecode.FrameRate?.none)
				
				//Spacer()
				Rectangle()
					.frame(maxWidth: .infinity)
					.frame(height: 3)
				
				ForEach(Timecode.FrameRate.allCases) { fRate in
					Text(fRate.stringValue)
						.tag(Timecode.FrameRate?.some(fRate))
				}
			}
			.frame(width: 250)
			
			HStack {
				if let localFrameRate = localFrameRate {
					VStack {
						Text("Compatible remote frame rates (\(localFrameRate.compatibleGroup.stringValue)):")
						
						HStack {
							ForEach(localFrameRate.compatibleGroupRates, id: \.self) {
								Text($0.stringValue)
									.foregroundColor($0 == localFrameRate ? .blue : nil)
									.padding(2)
									.border(Color.white,
											width: $0 == receiverFR?.directEquivalentFrameRate ? 2 : 0)
							}
						}
					}
				} else {
					VStack {
						Text(" ")
						Text(" ")
							.padding(2)
					}
				}
			}
			.padding(.bottom, 10)
			
        }
        .background(receiverState.stateColor)
		.onAppear {
			
			// start MIDI manager
			_ = try? midiManager.start()
			
			// mtc reader endpoint
			do {
				let uID = UserDefaults.standard
					.integerOptional(forKey: "\(midiSources.MTCRec.tag) - Unique ID")?
					.int32
				
				let newUniqueID = try midiManager.addInput(
					name: midiSources.MTCRec.name,
					tag: midiSources.MTCRec.tag,
					uniqueID: uID,
					receiveHandler: .rawData({ midiPacketData in
						mtcRec.midiIn(data: midiPacketData.bytes)
					})
				)
				
				// update stored unique ID for the port
				UserDefaults.standard
					.setValue(newUniqueID, forKey: "\(midiSources.MTCRec.tag) - Unique ID")
			} catch {
				Log.error(error)
			}
			
			// mtc generator endpoint - MTC.Generator not yet implemented
			//do {
			//	let uID = UserDefaults.standard
			//		.integerOptional(forKey: "\(midiSources.MTCGen.tag) - Unique ID")?
			//		.int32
			//
			//	let newUniqueID = try midiManager.addOutput(
			//		name: midiSources.MTCGen.name,
			//		tag: midiSources.MTCGen.tag,
			//		uniqueID: uID
			//	)
			//
			//	// update stored unique ID for the port
			//	UserDefaults.standard
			//		.setValue(newUniqueID, forKey: "\(midiSources.MTCGen.tag) - Unique ID")
			//} catch {
			//	Log.error(error)
			//}
			
			// set up new MTC receiver and configure it
			mtcRec = MTC.Receiver(name: "main",
								  initialLocalFrameRate: ._24,
								  syncPolicy: .init(lockFrames: 16,
													dropOutFrames: 10))
			{ timecode, _, _, displayNeedsUpdate in
				
				receiverTC = timecode.stringValue
				receiverFR = mtcRec.mtcFrameRate
				
				guard displayNeedsUpdate else { return }

				if timecode.seconds != lastSeconds {
					playClick()
					lastSeconds = timecode.seconds
				}
				
			} stateChanged: { state in
				receiverState = state

				scheduledLock?.cancel()
				scheduledLock = nil

				switch state {
				case .idle:
					break

				case let .preSync(lockTime, timecode):
					let scheduled = DispatchQueue.main
						.schedule(after: DispatchQueue.SchedulerTimeType(lockTime),
								  interval: .seconds(1),
								  tolerance: .zero,
								  options: .init(qos: .userInteractive,
												 flags: [],
												 group: nil)) {
							Log.default(">>> LOCAL SYNC: PLAYBACK START @", timecode)
							scheduledLock?.cancel()
							scheduledLock = nil
						}

					scheduledLock = scheduled

				case .sync:
					break

				case .freewheeling:
					break

				case .incompatibleFrameRate:
					break
				}
			}
			
		}
		
		ZStack {
			Text({
				// this is a stupid SwiftUI workaround, but it works fine for our purposes
				if mtcRec.localFrameRate != localFrameRate {
					Log.default("Setting MTC receiver's local frame rate to",
								localFrameRate?.rawValue ?? "None")
					mtcRec.localFrameRate = localFrameRate
				}
				
				return ""
			}())
		}
		.opacity(0.0)
		.frame(width: 0, height: 0)
		
    }
	
}

extension MTC.Receiver.State {
	
    var stateColor: Color {
        switch self {
        case .idle: return Color.gray
        case .preSync: return Color.orange
        case .sync: return Color.green
        case .freewheeling: return Color.purple
        case .incompatibleFrameRate: return Color.red
        }
	}
	
}

struct ContentView_Previews: PreviewProvider {
	
    static var previews: some View {
        ContentView()
    }
	
}
