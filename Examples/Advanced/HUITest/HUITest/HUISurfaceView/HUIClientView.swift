//
//  HUIClientView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitControlSurfaces
import MIDIKitIO
import SwiftUI

struct HUIClientView: View {
    @Environment(ObservableMIDIManager.self) private var midiManager
    @State private var huiSurface: HUISurface
    
    nonisolated static let kHUIInputName = "MIDIKit HUI Input"
    nonisolated static let kHUIOutputName = "MIDIKit HUI Output"
    
    init(midiManager: ObservableMIDIManager) {
        // set up HUI Surface object
        let huiSurface = HUISurface()
        
        huiSurface.modelNotificationHandler = { notification in
            // Logger.debug(notification)
        }
        
        huiSurface.midiOutHandler = { [weak midiManager] midiEvents in
            guard let output = midiManager?.managedOutputs[Self.kHUIOutputName]
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
        
        _huiSurface = State(initialValue: huiSurface)
    }
    
    var body: some View {
        HUISurfaceView()
            .frame(maxWidth: .infinity)
            .environment(huiSurface)
            .onAppear { startVirtualPorts() }
            .onDisappear { stopVirtualPorts() }
    }
    
    private func startVirtualPorts() {
        do {
            if midiManager.managedInputs.isEmpty {
                try midiManager.addInput(
                    name: Self.kHUIInputName,
                    tag: Self.kHUIInputName,
                    uniqueID: .userDefaultsManaged(key: Self.kHUIInputName),
                    receiver: .weak(huiSurface)
                )
            }
            if midiManager.managedOutputs.isEmpty {
                try midiManager.addOutput(
                    name: Self.kHUIOutputName,
                    tag: Self.kHUIOutputName,
                    uniqueID: .userDefaultsManaged(key: Self.kHUIOutputName)
                )
            }
        } catch {
            Logger.debug("Error setting up MIDI.")
        }
    }
    
    private func stopVirtualPorts() {
        midiManager.remove(.input, .withTag(Self.kHUIInputName))
        midiManager.remove(.output, .withTag(Self.kHUIOutputName))
    }
}

#if DEBUG
struct HUIClientView_Previews: PreviewProvider {
    static let midiManager = ObservableMIDIManager(clientName: "Preview", model: "", manufacturer: "")
    static var previews: some View {
        HUIClientView(midiManager: midiManager)
    }
}
#endif
