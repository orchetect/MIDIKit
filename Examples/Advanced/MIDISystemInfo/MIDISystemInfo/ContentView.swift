//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

struct ContentView<DetailsContent: View>: View {
    @EnvironmentObject var midiManager: MIDIManager
    
    let detailsContent: (_ object: AnyMIDIIOObject?,
                         _ showAllBinding: Binding<Bool>) -> DetailsContent
    
    var body: some View {
        NavigationView {
            sidebar
                .frame(width: 300)
    
            EmptyDetailsView()
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var sidebar: some View {
        List {
            deviceTreeSection
            otherInputsSection
            otherOutputsSection
        }
    }
    
    private var deviceTreeSection: some View {
        Section(header: Text("Device Tree")) {
            let items: [AnyMIDIIOObject] = midiManager.devices.devices
                .sortedByName()
                .flatMap {
                    [$0.asAnyMIDIIOObject()]
                    + $0.entities
                        .flatMap {
                            [$0.asAnyMIDIIOObject()]
                            + $0.inputs.asAnyMIDIIOObjects()
                            + $0.outputs.asAnyMIDIIOObjects()
                        }
                }
            
            ForEach(items) { item in
                let detailsView = DetailsView(
                    object: item.asAnyMIDIIOObject(),
                    detailsContent: detailsContent
                )
                
                NavigationLink(destination: detailsView) {
                    switch item.objectType {
                    case .device:
                        // SwiftUI doesn't allow 'break' in a switch case
                        // so just put a 0x0 pixel spacer here
                        Spacer()
                            .frame(width: 0, height: 0, alignment: .center)
                        
                    case .entity:
                        Spacer()
                            .frame(width: 24, height: 18, alignment: .center)
                        
                    case .inputEndpoint, .outputEndpoint:
                        Spacer()
                            .frame(width: 48, height: 18, alignment: .center)
                    }
                    
                    Group {
                        if let nsImg = item.imageAsNSImage {
                            Image(nsImage: nsImg)
                                .resizable()
                        } else {
                            Text("🎹")
                        }
                    }
                    .frame(width: 18, height: 18, alignment: .center)
                    
                    Text("\(item.name)")
                    if item.objectType == .inputEndpoint {
                        Text("(In)")
                    } else if item.objectType == .outputEndpoint {
                        Text("(Out)")
                    }
                }
            }
        }
    }
    
    private var otherInputsSection: some View {
        Section(header: Text("Other Inputs")) {
            // filter out endpoints that have an entity because
            // they are already being displayed in the Devices tree
            let items = midiManager.endpoints.inputs.sortedByName()
                .filter { $0.entity == nil }
            
            ForEach(items) { item in
                let detailsView = DetailsView(
                    object: item.asAnyMIDIIOObject(),
                    detailsContent: detailsContent
                )
                
                NavigationLink(destination: detailsView) {
                    Group {
                        if let nsImg = item.imageAsNSImage {
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
    
    private var otherOutputsSection: some View {
        Section(header: Text("Other Outputs")) {
            // filter out endpoints that have an entity because
            // they are already being displayed in the Devices tree
            let items = midiManager.endpoints.outputs.sortedByName()
                .filter { $0.entity == nil }
            
            ForEach(items) { item in
                let detailsView = DetailsView(
                    object: item.asAnyMIDIIOObject(),
                    detailsContent: detailsContent
                )
                
                NavigationLink(destination: detailsView) {
                    Group {
                        if let nsImg = item.imageAsNSImage {
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
}

struct ContentViewForCurrentPlatform: View {
    var body: some View {
        if #available(macOS 12, *) {
            return ContentView { object, showAll in
                TableDetailsView(object: object, showAll: showAll)
            }
        } else {
            return ContentView { object, showAll in
                LegacyDetailsView(object: object, showAll: showAll)
            }
        }
    }
}

struct ContentViewCatalina_Previews: PreviewProvider {
    static let midiManager = MIDIManager(
        clientName: "Preview",
        model: "",
        manufacturer: ""
    )
    
    static var previews: some View {
        ContentViewForCurrentPlatform()
    }
}
