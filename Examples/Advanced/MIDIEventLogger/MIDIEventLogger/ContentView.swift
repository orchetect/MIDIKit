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
    @EnvironmentObject var midiManager: MIDI.IO.Manager
    
    // MARK: - Constants
    
    static let kMinWidth: CGFloat = 1290
    static let kMaxWidth: CGFloat = 1400
    static let kMinHeight: CGFloat = 650
    static let kMaxHeight: CGFloat = 1000
    
    let kInputTag = "EventLoggerInput"
    let kInputName = "MIDIKit Event Logger In"
    
    let kOutputTag = "EventLoggerOutput"
    let kOutputName = "MIDIKit Event Logger Out"
    
    let kInputConnectionTag = "EventLoggerInputConnection"
    
    // MARK: - UI State
    
    @State var midiGroup: MIDI.UInt4 = 0
    
    @State var midiInputConnectionEndpoint: MIDI.IO.OutputEndpoint? = nil
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer().frame(height: 10)
            
            MIDISubsystemStatusView()
            
            Spacer().frame(height: 10)
            
            SendMIDIEventsView(midiGroup: $midiGroup) {
                sendEvent($0)
            }
            .environmentObject(midiManager)
            
            Spacer().frame(height: 10)
            
            ReceiveMIDIEventsView()
            
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
            do {
                if midiManager.managedInputs[kInputTag] == nil {
                    logger.debug("Adding virtual MIDI input port to the manager.")
                    
                    try midiManager.addInput(
                        name: kInputName,
                        tag: kInputTag,
                        uniqueID: .userDefaultsManaged(key: kInputTag),
                        receiveHandler: .eventsLogging()
                    )
                }
                
                if midiManager.managedOutputs[kOutputTag] == nil {
                    logger.debug("Adding virtual MIDI output port to the manager.")
                    
                    try midiManager.addOutput(
                        name: kOutputName,
                        tag: kOutputTag,
                        uniqueID: .userDefaultsManaged(key: kOutputTag)
                    )
                }
            } catch {
                logger.error(error)
            }
            
            // wait a short delay in order to give Core MIDI time
            // to set up the virtual endpoints we created in the view's init()
            DispatchQueue.main.asyncAfter(
                deadline: DispatchTime.now().advanced(by: .milliseconds(500))
            ) {
                setInputConnectionToVirtual()
            }
        }
        
        // MARK: TODO: this works but only on macOS 11 and later
        // .onChange(of: midiInputConnectionEndpoint) { _ in
        //    updateInputConnection()
        // }
        // MARK: TODO: instead, we need a hack to update when the @State var changes:
        ZStack {
            Text({
                let dummy = midiInputConnectionEndpoint?.name ?? ""
                updateInputConnection()
                return "\(dummy)"
            }())
        }.frame(width: 0, height: 0)
    }
    
    // MARK: - Helper Methods
    
    /// Auto-select the virtual endpoint as our input connection source.
    func setInputConnectionToVirtual() {
        if let findInputConnectionEndpoint = midiManager.endpoints.outputs
            .filter(whereName: kOutputName)
            .first
        {
            logger.debug("Found virtual endpoint: \(findInputConnectionEndpoint)")
            midiInputConnectionEndpoint = findInputConnectionEndpoint
        }
    }
    
    func updateInputConnection() {
        // check for existing connection and compare new selection against it
        if let ic = midiManager.managedInputConnections[kInputConnectionTag] {
            // if endpoint is the same, don't reconnect
            if ic.endpoints.first == midiInputConnectionEndpoint {
                logger.debug("Already connected.")
                return
            }
        }
        
        if !midiManager.managedInputConnections.isEmpty {
            logger.debug("Removing input connections.")
            midiManager.remove(.inputConnection, .all)
        }
        
        guard let endpoint = midiInputConnectionEndpoint else { return }
        
        let endpointName = endpoint.displayName.quoted
        
        logger.debug("Setting up new input connection to \(endpointName).")
        do {
            try midiManager.addInputConnection(
                toOutputs: [.uniqueID(endpoint.uniqueID)],
                tag: kInputConnectionTag,
                receiveHandler: .eventsLogging()
            )
        } catch {
            logger.error(error)
        }
    }
    
    /// Send a MIDI event using our virtual output endpoint.
    func sendEvent(_ event: MIDI.Event) {
        logIfThrowsError {
            try midiManager.managedOutputs[kOutputTag]?
                .send(event: event)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    private static let midiManager = MIDI.IO.Manager(
        clientName: "Preview",
        model: "",
        manufacturer: ""
    )
    
    static var previews: some View {
        ContentView()
            .environmentObject(Self.midiManager)
    }
}
