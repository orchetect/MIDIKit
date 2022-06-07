//
//  ContentView.swift
//  VirtualInput
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            Group {
                Text("This example creates a virtual MIDI input port named \"TestApp Input\".")
                
                Text("Received MIDI events are logged to the console, filtering out Active Sensing and Clock events.")
                
                Text("Event values are logged in their native format.")
                
                Text("On modern operating systems supporting MIDI 2.0, event values will be natively received as MIDI 2.0 values.")
                
                Text("Regardless, MIDI 1.0 ←→ MIDI 2.0 values are always seamlessly convertible.")
                
                Text("For more details, review the Event Parsing example project.")
            }
            .font(.system(size: 14))
            .lineLimit(4)
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .padding()
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
