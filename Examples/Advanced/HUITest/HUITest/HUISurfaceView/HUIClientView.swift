//
//  HUIClientView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import MIDIKitControlSurfaces
import SwiftUI

struct HUIClientView: View {
    weak var midiManager: MIDIManager?

    @ObservedObject private var huiSurface: HUISurface
    
    static let kHUIInputName = "MIDIKit HUI Input"
    static let kHUIOutputName = "MIDIKit HUI Output"
    
    init(midiManager: MIDIManager?) {
        self.midiManager = midiManager
        
        // set up HUI Surface object
        huiSurface = {
            let huiSurface = HUISurface()
            
            huiSurface.modelNotificationHandler = { notification in
                // Logger.debug(notification)
            }
            
            huiSurface.midiOutHandler = { [weak midiManager] midiEvents in
                guard let output = midiManager?
                    .managedOutputs[Self.kHUIOutputName]
                else {
                    Logger.debug("MIDI output missing.")
                    return
                }
            
                do {
                    try output.send(events: midiEvents)
                } catch {
                    Logger.debug(error.localizedDescription)
                }
            }
            
            return huiSurface
        }()
        
        // set up MIDI ports

        do {
            try midiManager?.addInput(
                name: Self.kHUIInputName,
                tag: Self.kHUIInputName,
                uniqueID: .userDefaultsManaged(key: Self.kHUIInputName),
                receiver: .events(translateMIDI1NoteOnZeroVelocityToNoteOff: false)
                    { [weak huiSurface] events in
                        // since handler callbacks from MIDI are on a CoreMIDI thread, parse the MIDI on the main thread because SwiftUI state in this app will be updated as a result
                        DispatchQueue.main.async {
                            huiSurface?.midiIn(events: events)
                        }
                    }
            )

            try midiManager?.addOutput(
                name: Self.kHUIOutputName,
                tag: Self.kHUIOutputName,
                uniqueID: .userDefaultsManaged(key: Self.kHUIOutputName)
            )
        } catch {
            Logger.debug("Error setting up MIDI.")
        }
    }
    
    var body: some View {
        HUISurfaceView()
            .frame(maxWidth: .infinity)
            .environmentObject(huiSurface)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HUIClientView(midiManager: nil)
    }
}
#endif
