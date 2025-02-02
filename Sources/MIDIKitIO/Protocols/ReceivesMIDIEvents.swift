//
//  ReceivesMIDIEvents.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

/// Protocol that objects can adopt so MIDIKit knows they are capable of receiving MIDI events.
///
/// Conforming a custom class that receives MIDI events to this protocol allows an instance of the
/// class to be passed into ``MIDIManager`` event receive handlers.
///
/// For example:
///
/// ```swift
/// class MyReceiver: ReceivesMIDIEvents {
///     func midiIn(event: MIDIEvent) {
///         print(event)
///     }
/// }
///
/// let receiver = MyReceiver()
///
/// try midiManager.addInput(
///     name: "My Input",
///     tag: "My Input",
///     uniqueID: .userDefaultsManaged(key: "MyInputID"),
///     receiver: .weak(receiver) // weakly held reference
/// )
/// ```
///
/// Adoption of this protocol is a convenience and not required.
public protocol ReceivesMIDIEvents: AnyObject where Self: Sendable  {
    /// Process MIDI events.
    func midiIn(event: MIDIEvent)
    
    /// Process MIDI events.
    func midiIn(events: [MIDIEvent])
}

extension ReceivesMIDIEvents {
    public func midiIn(events: [MIDIEvent]) {
        for event in events {
            midiIn(event: event)
        }
    }
}
