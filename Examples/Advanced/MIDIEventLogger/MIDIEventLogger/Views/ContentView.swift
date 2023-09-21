//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKit
import OTCore
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var midiManager: MIDIManager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    // MARK: - Constants
    
    static let kMinWidth: CGFloat = 1290
    static let kMaxWidth: CGFloat = 1400
    static let kMinHeight: CGFloat = 650
    static let kMaxHeight: CGFloat = 1000
    
    // MARK: - UI State
    
    /// UMP group number
    @State var midiGroup: UInt4 = 0
    
    /// Currently selected MIDI output endpoint to connect to
    @State var midiInputConnectionEndpoint: MIDIOutputEndpoint? = nil
    
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
                midiInputConnectionEndpoint: $midiInputConnectionEndpoint
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
        .onChange(of: midiInputConnectionEndpoint) { _ in
            updateInputConnection()
        }
    }
    
    // MARK: - Helper Methods
    
    /// Auto-select the virtual endpoint as our input connection source.
    func setInputConnectionToVirtual() {
        midiInputConnectionEndpoint = midiHelper.midiOutput?.endpoint
    }
    
    /// Update the MIDI manager's input connection to connect to the selected output endpoint.
    func updateInputConnection() {
        logger.debug(
            "Updating input connection to endpoint: \(midiInputConnectionEndpoint?.displayName.quoted ?? "None")"
        )
        midiHelper.updateInputConnection(selectedUniqueID: midiInputConnectionEndpoint?.uniqueID)
    }
    
    /// Send a MIDI event using our virtual output endpoint.
    func sendEvent(_ event: MIDIEvent) {
        logIfThrowsError {
            try midiHelper.midiOutput?.send(event: event)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    private static let midiManager = MIDIManager(clientName: "Preview", model: "", manufacturer: "")
    
    static var previews: some View {
        ContentView()
            .environmentObject(midiManager)
    }
}
