# MIDI Over Bluetooth

Set up Bluetooth MIDI connectivity in an iOS app.

See the following example projects:

- [iOS SwiftUI](https://github.com/orchetect/MIDIKit/blob/main/Examples/SwiftUI%20iOS/BluetoothMIDI/) Example
- [iOS UIKit](https://github.com/orchetect/MIDIKit/blob/main/Examples/SwiftUI%20iOS/BluetoothMIDI/) Example

## Operation

Once Bluetooth connectivity is implemented (see examples above), Bluetooth MIDI devices' ports simply show up as MIDI input or output endpoints in the system. Access them by getting these properties on the ``MIDIManager`` instance:

- ``MIDIManager/endpoints``.``MIDIEndpoints/inputs``
- ``MIDIManager/endpoints``.``MIDIEndpoints/outputs``

Connect to these endpoints to transmit and receive MIDI:

- ``MIDIManager/addInputConnection(toOutputs:tag:mode:filter:receiver:)-5xxyz``
- ``MIDIManager/addOutputConnection(toInputs:tag:mode:filter:)-3a56s``

> Tip: Bluetooth can only be tested using a physical iOS device. It does not function in an iOS Simulator.

