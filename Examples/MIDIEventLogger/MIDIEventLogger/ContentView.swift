//
//  ContentView.swift
//  MIDIEventLogger
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import OTCore
import SwiftRadix
import MIDIKit

struct ContentView: View {
    
    // if you declare a view that creates its own @ObservedObject instance, that instance is replaced every time SwiftUI decides that it needs to discard and redraw that view.
    // it should instead be used to retain a weak reference from the view's initializer, with the original instance of the object stored in a parent scope as either a var or @StateObject but not an @ObservedObject
    
    @ObservedObject var midiManager: MIDI.IO.Manager
    
    // MARK: - Constants
    
    static let kMinWidth: CGFloat = 1020
    static let kMaxWidth: CGFloat = 1400
    static let kMinHeight: CGFloat = 650
    
    let kInputTag = "EventLoggerInput"
    let kInputName = "MIDIKit Event Logger In"
    
    let kOutputTag = "EventLoggerOutput"
    let kOutputName = "MIDIKit Event Logger Out"
    
    let kInputConnectionTag = "EventLoggerInputConnection"
    
    // MARK: - UI State
    
    @State var midiChannel: MIDI.UInt4 = 0
    @State var midiGroup: MIDI.UInt4 = 0
    @State var chanVoiceCC: MIDI.Event.CC = .modWheel
    
    @State var midiInputConnection: MIDI.IO.OutputEndpoint? = nil
    
    // MARK: - Init
    
    init(midiManager: MIDI.IO.Manager) {
        
        self.midiManager = midiManager
        
        Log.debug("Adding virtual MIDI ports to system.")
        
        do {
            try midiManager.addInput(
                name: kInputName,
                tag: kInputTag,
                uniqueID: .none,
                receiveHandler: .eventsLogging()
            )
            
            try midiManager.addOutput(
                name: kOutputName,
                tag: kOutputTag,
                uniqueID: .none
            )
        } catch {
            Log.error(error)
        }
        
    }
    // MARK: - Body
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 0) {
            
            Spacer().frame(height: 10)
            MIDISubsystemStatusView()
            Spacer().frame(height: 10)
            SendMIDIEventsView()
            Spacer().frame(height: 10)
            ReceiveMIDIEventsView()
            Spacer().frame(height: 18)
            
        }
        .frame(minWidth: Self.kMinWidth,
               idealWidth: Self.kMinWidth,
               maxWidth: Self.kMaxWidth,
               minHeight: Self.kMinHeight,
               alignment: .center)
        .padding([.leading, .trailing])
        
        .onAppear {
            // wait a short delay in order to give CoreMIDI time
            // to set up the virtual endpoints we created in the view's init()
            DispatchQueue.main
                .asyncAfter(deadline: DispatchTime.now()
                                .advanced(by: .milliseconds(500)))
            {
                setInputConnectionToVirtual()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Auto-select the virtual endpoint as our input connection source.
    func setInputConnectionToVirtual() {
        
        if let findInputConnectionEndpoint = self
            .midiManager.endpoints.outputs
            .filter(name: kOutputName)
            .first
        {
            Log.debug("Found virtual endpoint: \(findInputConnectionEndpoint)")
            midiInputConnection = findInputConnectionEndpoint
        }
        
    }
    
    func updateInputConnection() {
        
        // check for existing connection and compare new selection against it
        if let ic = midiManager.managedInputConnections[kInputConnectionTag] {
            // if endpoint is the same, don't reconnect
            if ic.outputEndpointRef == midiInputConnection?.coreMIDIObjectRef {
                Log.debug("Already connected.")
                return
            }
        }
        
        if !midiManager.managedInputConnections.isEmpty {
            Log.debug("Removing input connections.")
            midiManager.remove(.inputConnection, .all)
        }
        
        guard let endpoint = midiInputConnection else { return }
        
        let endpointName = (endpoint.getDisplayName ?? endpoint.name).quoted
        
        Log.debug("Setting up new input connection to \(endpointName).")
        do {
            try midiManager.addInputConnection(
                toOutput: .uniqueID(endpoint.uniqueID),
                tag: kInputConnectionTag,
                receiveHandler: .eventsLogging()
            )
        } catch {
            Log.error(error)
        }
        
    }
    
    /// Send a MIDI event using our virtual output endpoint.
    func sendEvent(_ event: MIDI.Event) {
        
        logErrors {
            try midiManager.managedOutputs[kOutputTag]?
                .send(event: event)
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(midiManager: .init(clientName: "Preview", model: "", manufacturer: ""))
    }
}
