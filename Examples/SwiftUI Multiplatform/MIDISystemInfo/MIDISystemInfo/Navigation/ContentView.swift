//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

/// Dynamically uses modern UI elements when the platform supports it.
struct ContentViewForCurrentPlatform: View {
    @State private var showRelevantProperties: Bool = true
    
    var body: some View {
        if #available(macOS 12, iOS 16, *) {
            if #available(macOS 13, *) {
                ContentView<FormDetailsView>(showRelevantProperties: $showRelevantProperties)
            } else {
                ContentView<TableDetailsView>(showRelevantProperties: $showRelevantProperties)
            }
        } else {
            ContentView<LegacyDetailsView>(showRelevantProperties: $showRelevantProperties)
        }
    }
}

struct ContentView<Details: DetailsContent>: View {
    @EnvironmentObject private var midiManager: ObservableObjectMIDIManager
    
    @Binding var showRelevantProperties: Bool
    
    var body: some View {
        NavigationView {
            sidebar
            #if os(macOS)
                .frame(minWidth: 300)
            #endif
            
            EmptyDetailsView()
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .environmentObject(midiManager)
    }
    
    private var sidebar: some View {
        List {
            DeviceTreeView(showRelevantProperties: $showRelevantProperties)
            OtherInputsView(showRelevantProperties: $showRelevantProperties)
            OtherOutputsView(showRelevantProperties: $showRelevantProperties)
        }
        #if os(macOS)
        .listStyle(.sidebar)
        #endif
    }
}

#if DEBUG
struct ContentViewPreviews: PreviewProvider {
    static let midiManager = ObservableObjectMIDIManager(
        clientName: "Preview",
        model: "Preview",
        manufacturer: "MyCompany"
    )
    
    static var previews: some View {
        ContentViewForCurrentPlatform()
            .environmentObject(midiManager)
    }
}
#endif
