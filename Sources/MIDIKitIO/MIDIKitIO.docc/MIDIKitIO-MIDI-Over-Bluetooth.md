# MIDI Over Bluetooth

Set up Bluetooth MIDI connectivity in an iOS app.

See the following example projects:

- [iOS SwiftUI](https://github.com/orchetect/MIDIKit/blob/main/Examples/iOS%20SwiftUI/BluetoothMIDI/) Example
- [iOS UIKit](https://github.com/orchetect/MIDIKit/blob/main/Examples/iOS%20UIKit/BluetoothMIDI/) Example

## Operation

Once Bluetooth connectivity is implemented (see examples above), Bluetooth MIDI devices' ports simply show up as MIDI input or output endpoints in the system. Access them by getting these properties on the ``MIDIManager`` instance:

- `midiManager`.``MIDIManager/endpoints``.``MIDIEndpoints/inputs``
- `midiManager`.``MIDIManager/endpoints``.``MIDIEndpoints/outputs``
