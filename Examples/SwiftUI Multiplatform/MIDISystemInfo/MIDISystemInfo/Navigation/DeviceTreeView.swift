//
//  DeviceTreeView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

extension ContentView {
    struct DeviceTreeView: View {
        @EnvironmentObject private var midiManager: ObservableObjectMIDIManager
        
        @Binding var showRelevantProperties: Bool
        
        var body: some View {
            Section(header: Text("Device Tree")) {
                ForEach(deviceTreeItems) { item in
                    navLink(item: item)
                }
            }
        }
        
        private func navLink(item: AnyMIDIIOObject) -> some View {
            NavigationLink(destination: detailsView(item: item)) {
                HStack {
                    switch item.objectType {
                    case .device:
                        EmptyView()
                        
                    case .entity:
                        Spacer()
                            .frame(width: 24, height: 18, alignment: .center)
                        
                    case .inputEndpoint, .outputEndpoint:
                        Spacer()
                            .frame(width: 48, height: 18, alignment: .center)
                    }
                    
                    ItemIcon(item: item, default: Text("🎹"))
                    
                    Text(item.name)
                    
                    Spacer()
                    
                    Group {
                        switch item.objectType {
                        case .inputEndpoint: Text("In")
                        case .outputEndpoint: Text("Out")
                        default: EmptyView()
                        }
                    }
                    .foregroundColor(.secondary)
                }
            }
        }
        
        private func detailsView(item: AnyMIDIIOObject) -> some View {
            DetailsView(
                object: item.asAnyMIDIIOObject(),
                isRelevantPropertiesOnlyShown: $showRelevantProperties
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
}
