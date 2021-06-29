//
//  ContentViewBigSur.swift
//  MIDIKitTestHarness
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import MIDIKit
import OTCore

@available(macOS 11.0, *)
struct ContentViewBigSur: View {
	
	@StateObject var midiManager: MIDI.IO.Manager = {
		let newManager =
			MIDI.IO.Manager(clientName: "MIDIKitTestHarness",
							model: "TestApp",
							manufacturer: "Orchetect")
		do {
			Log.debug("Starting MIDI manager client")
			try newManager.start()
		} catch {
			Log.default(error)
		}
		
		return newManager
	}()
	
	var body: some View {
		
		NavigationView {

			List {
				
				Section(header: Text("MIDI Devices")) {

					ForEach(midiManager.devices.devices.sortedByName(), id: \.id) { item in
						Group {
							if let nsImg = item.getImageAsNSImage {
								Image(nsImage: nsImg)
									.resizable()
							} else {
								Text("🎹")
							}
						}
						.frame(width: 18, height: 18, alignment: .center)
						
						Text("\(item.name)")
					}

				}
				
				Section(header: Text("MIDI Outputs")) {

					ForEach(midiManager.endpoints.outputs.sortedByName(), id: \.id) { item in
						Group {
							if let nsImg = item.getImageAsNSImage {
								Image(nsImage: nsImg)
									.resizable()
							} else {
								Text("🎵")
							}
						}
						.frame(width: 18, height: 18, alignment: .center)
						
						Text("\(item.name)")
					}

				}

				Section(header: Text("MIDI Inputs")) {

					ForEach(midiManager.endpoints.inputs.sortedByName(), id: \.id) { item in
						Group {
							if let nsImg = item.getImageAsNSImage {
								Image(nsImage: nsImg)
									.resizable()
							} else {
								Text("🎵")
							}
						}
						.frame(width: 18, height: 18, alignment: .center)
						
						Text("\(item.name)")
					}

				}

			}
			.frame(width: 300)

			EmptyDetailsView()

		}
		.navigationViewStyle(DoubleColumnNavigationViewStyle())
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		
	}
	
}

@available(macOS 11.0, *)
struct ContentViewBigSur_Previews: PreviewProvider {
	static var previews: some View {
		ContentViewBigSur()
	}
}
