//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKit

struct ContentViewForCurrentPlatform: View {
    var body: some View {
        if #available(macOS 12, iOS 16, *) {
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
        .environmentObject(midiManager)
    }
    
    private var sidebar: some View {
        List {
            DeviceTreeView(detailsContent: detailsContent)
            OtherInputsView(detailsContent: detailsContent)
            OtherOutputsView(detailsContent: detailsContent)
        }
#if os(macOS)
        .listStyle(.sidebar)
#endif
    }
}

struct DeviceTreeView<DetailsContent: View>: View {
    @EnvironmentObject private var midiManager: MIDIManager
    
    let detailsContent: (_ object: AnyMIDIIOObject?,
                         _ showAllBinding: Binding<Bool>) -> DetailsContent
    
    var body: some View {
        Section(header: Text("Device Tree")) {
            ForEach(deviceTreeItems) { item in
                navLink(item: item)
            }
        }
    }
    
//    @ViewBuilder
    private func navLink(item: AnyMIDIIOObject) -> some View {
        NavigationLink(destination: detailsView(item: item)) {
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
            
            ItemIcon(item: item, default: Text("🎹"))
            
            Text("\(item.name)")
            if item.objectType == .inputEndpoint {
                Text("(In)")
            } else if item.objectType == .outputEndpoint {
                Text("(Out)")
            }
        }
    }
    
    private func detailsView(item: AnyMIDIIOObject) -> some View {
        DetailsView(
            object: item.asAnyMIDIIOObject(),
            detailsContent: detailsContent
        )
    }
    
    private var deviceTreeItems: [AnyMIDIIOObject] {
        midiManager.devices.devices
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
    }
}

struct OtherInputsView<DetailsContent: View>: View {
    @EnvironmentObject private var midiManager: MIDIManager
    
    let detailsContent: (_ object: AnyMIDIIOObject?,
                         _ showAllBinding: Binding<Bool>) -> DetailsContent
    
    var body: some View {
        Section(header: Text("Other Inputs")) {
            ForEach(otherInputs) { item in
                NavigationLink(destination: detailsView(item: item)) {
                    ItemIcon(item: item.asAnyMIDIIOObject(), default: Text("🎵"))
                    Text("\(item.name)")
                }
            }
        }
    }
    
    private func detailsView(item: MIDIInputEndpoint) -> some View {
        DetailsView(
            object: item.asAnyMIDIIOObject(),
            detailsContent: detailsContent
        )
    }
    
    private var otherInputs: [MIDIInputEndpoint] {
        // filter out endpoints that have an entity because
        // they are already being displayed in the Devices tree
        midiManager.endpoints.inputs.sortedByName()
            .filter { $0.entity == nil }
    }
}

struct OtherOutputsView<DetailsContent: View>: View {
    @EnvironmentObject private var midiManager: MIDIManager
    
    let detailsContent: (_ object: AnyMIDIIOObject?,
                         _ showAllBinding: Binding<Bool>) -> DetailsContent
    
    var body: some View {
        Section(header: Text("Other Outputs")) {
            ForEach(otherOutputs) { item in
                NavigationLink(destination: detailsView(item: item)) {
                    ItemIcon(item: item.asAnyMIDIIOObject(), default: Text("🎵"))
                    Text("\(item.name)")
                }
            }
        }
    }
    
    private func detailsView(item: MIDIOutputEndpoint) -> some View {
        DetailsView(
            object: item.asAnyMIDIIOObject(),
            detailsContent: detailsContent
        )
    }
    
    private var otherOutputs: [MIDIOutputEndpoint] {
        // filter out endpoints that have an entity because
        // they are already being displayed in the Devices tree
        midiManager.endpoints.outputs.sortedByName()
            .filter { $0.entity == nil }
    }
}

struct ItemIcon<Content: View>: View {
    let item: AnyMIDIIOObject
    let `default`: Content
    
    var body: some View {
        Group {
            if let img = image {
                img
            } else {
                Text("🎹")
            }
        }
        .frame(width: 18, height: 18, alignment: .center)
    }
    
#if os(macOS)
    private var image: Image? {
        guard let img = item.imageAsNSImage else { return nil }
        return Image(nsImage: img).resizable()
    }
#elseif os(iOS)
    private var image: Image? {
        guard let img = item.imageAsUIImage else { return nil }
        return Image(uiImage: img).resizable()
    }
#endif
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
