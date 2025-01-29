//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

struct ContentView: View {
    @Environment(ObservableMIDIManager.self) private var midiManager
    @Environment(MIDIHelper.self) private var midiHelper
    
    // MARK: - Constants
    
    static let kMinWidth: CGFloat = 1290
    static let kMaxWidth: CGFloat = 1400
    static let kMinHeight: CGFloat = 650
    static let kMaxHeight: CGFloat = 1000
    
    // MARK: - UI State
    
    /// UMP group number
    @State var midiGroup: UInt4 = 0
    
    /// Currently selected MIDI output endpoint to connect to
    @State var midiInputConnectionID: MIDIIdentifier? = nil
    @State var midiInputConnectionDisplayName: String? = nil
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer().frame(height: 10)
    
            MIDISubsystemStatusView()
    
            Spacer().frame(height: 10)
    
            SendMIDIEventsView(midiGroup: $midiGroup) {
                sendEvent($0)
            }
    
            Spacer().frame(height: 10)
    
            ReceiveMIDIEventsView(
                inputName: ConnectionTags.inputName,
                midiInputConnectionID: $midiInputConnectionID,
                midiInputConnectionDisplayName: $midiInputConnectionDisplayName
            )
    
            Spacer().frame(height: 18)
        }
        .frame(
            minWidth: Self.kMinWidth,
            idealWidth: Self.kMinWidth,
            maxWidth: Self.kMaxWidth,
            minHeight: Self.kMinHeight,
            maxHeight: Self.kMaxHeight,
            alignment: .center
        )
        .padding([.leading, .trailing])
    
        .onAppear {
            setInputConnectionToVirtual()
        }
    }
    
    // MARK: - Helper Methods
    
    /// Auto-select the virtual endpoint as our input connection source.
    func setInputConnectionToVirtual() {
        guard let midiOutputEndpoint = midiHelper.midiOutput?.endpoint else { return }
        midiInputConnectionID = midiOutputEndpoint.uniqueID
        midiInputConnectionDisplayName = midiOutputEndpoint.displayName
    }
    
    /// Send a MIDI event using our virtual output endpoint.
    func sendEvent(_ event: MIDIEvent) {
        logErrors {
            try midiHelper.midiOutput?.send(event: event)
        }
    }
}

#Preview {
    @Previewable @State var midiManager = ObservableMIDIManager(
        clientName: "Preview",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    @Previewable @State var midiHelper = MIDIHelper()
    
    ContentView()
        .environment(midiManager)
        .environment(midiHelper)
        .onAppear { midiHelper.setup(midiManager: midiManager) }
}
