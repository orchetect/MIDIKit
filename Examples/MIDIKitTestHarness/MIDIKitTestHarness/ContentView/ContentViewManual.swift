//
//  ContentViewManual.swift
//  MIDIKitTestHarness
//
//  Created by Steffan Andrews on 2021-01-12.
//

import SwiftUI
import MIDIKit
import OTCore

/// This alternative of ContentView uses MIDIIO.Manager's traditional notification callback handler instead of Combine to trigger local MIDI object arrays to refresh their contents, allowing SwiftUI to update the user interface when endpoints appear and disappear in the system
struct ContentViewManual: View {
	
	var midiManager: MIDIIO.Manager = {
		let newManager =
			MIDIIO.Manager(clientName: "MIDIKitTestHarness",
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
	
	@State var devices: [MIDIIO.Device] = []
	@State var outputs: [MIDIIO.OutputEndpoint] = []
	@State var inputs: [MIDIIO.InputEndpoint] = []
	
    var body: some View {
		
		ZStack { }
			.onAppear {
				// onAppear has the potential to trigger more than once during the lifecycle of the view, so it's not best practise to put setup code here
				// however it won't have any dire consequences if this onAppear block runs more than once, and
				// we don't care too much that this setup code may happen lazily while the rest of the view loads
				
				// set up MIDI manager notifications callback handler
				// so we can be notified when MIDI endpoints in the system change,
				// allowing us to update our local endpoint cache arrays
				midiManager.notificationHandler = { notif, context in
					switch notif {
					case .systemEndpointsChanged:
						// update local cache with new object arrays
						devices = context.devices.devices
						outputs = context.endpoints.outputs
						inputs = context.endpoints.inputs
					}
				}
			}
		
		NavigationView {
			
			List {
				
				Section(header: Text("MIDI Devices")) {
					
					ForEach(devices.sortedByName(), id: \.id) { item in
						NavigationLink(destination: DetailsView(endpoint: item)) {
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
					
				}
				
				Section(header: Text("MIDI Outputs")) {
					
					ForEach(outputs.sortedByName(), id: \.id) { item in
						NavigationLink(destination: DetailsView(endpoint: item)) {
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
				
				Section(header: Text("MIDI Inputs")) {
					
					ForEach(inputs.sortedByName(), id: \.id) { item in
						NavigationLink(destination: DetailsView(endpoint: item)) {
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
				
			}
			.frame(width: 300)
			
			EmptyDetailsView()
			
		}
		.navigationViewStyle(DoubleColumnNavigationViewStyle())
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		
	}
	
}

struct ContentViewManual_Previews: PreviewProvider {
    static var previews: some View {
		ContentViewManual()
    }
}
