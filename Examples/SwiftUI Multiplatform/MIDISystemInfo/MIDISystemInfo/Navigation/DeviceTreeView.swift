//
//  DeviceTreeView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

struct DeviceTreeView<DetailsContent: View>: View {
    @EnvironmentObject private var midiManager: ObservableMIDIManager
    
    let detailsContent: (
        _ object: AnyMIDIIOObject?,
        _ showAllBinding: Binding<Bool>
    ) -> DetailsContent
    
    var body: some View {
        Section(header: Text("Device Tree")) {
            ForEach(deviceTreeItems) { item in
                navLink(item: item)
            }
        }
    }
    
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
