# Simple MIDI Listener Class Example

A barebones example of how to set up MIDIKit to receive MIDI events on a created virtual input.

```swift
import Foundation
import MIDIKitIO

public class MIDIModule {
    private let midiManager = MIDIManager(
        clientName: "MyAppMIDIModule",
        model: "MyApp",
        manufacturer: "MyCompany")

    let inputTag = "Virtual_MIDI_In"

    public init() {
        do {
            try midiManager.start()
            
            try midiManager.addInput(
                name: "MyApp MIDI In",
                tag: inputTag,
                uniqueID: .userDefaultsManaged(key: inputTag),
                receiver: .events { [weak self] events in
                    // Note: this handler will be called on a background thread
                    // so call the next line on main if it may result in UI updates
                    DispatchQueue.main.async {
                        events.forEach { self?.received(midiEvent: $0) }
                    }
                }
            )
        } catch {
            print("MIDI Setup Error:", error)
        }
    }
    
    private func received(midiEvent: MIDIEvent) {
        switch midiEvent {
        case .noteOn(let payload):
            print("Note On:", payload.note, payload.velocity, payload.channel)
        case .noteOff(let payload):
            print("Note Off:", payload.note, payload.velocity, payload.channel)
        case .cc(let payload):
            print("CC:", payload.controller, payload.value, payload.channel)
        case .programChange(let payload):
            print("Program Change:", payload.program, payload.channel)
            
        // etc...
            
        default:
            break
        }
    }
}
```
