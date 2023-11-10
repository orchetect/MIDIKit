//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

/// Dynamically uses modern UI elements when the platform supports it.
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
    @EnvironmentObject private var midiManager: MIDIManager
    
    let detailsContent: (
        _ object: AnyMIDIIOObject?,
        _ showAllBinding: Binding<Bool>
    ) -> DetailsContent
    
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

struct ContentViewPreviews: PreviewProvider {
    static let midiManager = MIDIManager(
        clientName: "Preview",
        model: "Preview",
        manufacturer: "MyCompany"
    )
    
    static var previews: some View {
        ContentViewForCurrentPlatform()
            .environmentObject(midiManager)
    }
}
