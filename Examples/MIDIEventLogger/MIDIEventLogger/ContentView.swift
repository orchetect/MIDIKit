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
    
    static let kMinWidth: CGFloat = 1000
    static let kMaxWidth: CGFloat = 1400
    static let kMinHeight: CGFloat = 620
    
    let kInputTag = "EventLoggerInput"
    let kOutputTag = "EventLoggerOutput"
    
    // MARK: - UI State
    
    @State var midiChannel: MIDI.UInt4 = 0
    @State var midiGroup: MIDI.UInt4 = 0
    @State var chanVoiceCC: MIDI.Event.CC = .modWheel
    
    // MARK: - Init
    
    init(midiManager: MIDI.IO.Manager) {
        
        self.midiManager = midiManager
        
        Log.debug("Adding virtual MIDI ports to system.")
        
        do {
            try midiManager.addInput(
                name: "MIDIKit Event Logger In",
                tag: kInputTag,
                uniqueID: .none,
                receiveHandler: .eventsLogging()
            )
            
            try midiManager.addOutput(
                name: "MIDIKit Event Logger Out",
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
            
            Spacer()
                .frame(height: 10)
            
            MIDISubsystemStatusView()
            
            Spacer()
                .frame(height: 10)
            
            SendMIDIEventsView()
            
            Spacer()
                .frame(height: 10)
            
            ReceiveMIDIEventsView()
            
            Spacer()
                .frame(height: 18)
            
        }
        .frame(minWidth: Self.kMinWidth,
               idealWidth: Self.kMinWidth,
               maxWidth: Self.kMaxWidth,
               minHeight: Self.kMinHeight,
               alignment: .center)
        .padding([.leading, .trailing])
        
    }
    
    // MARK: - Helper Methods
    
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
