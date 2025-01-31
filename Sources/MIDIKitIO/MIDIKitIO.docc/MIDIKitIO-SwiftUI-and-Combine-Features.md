# SwiftUI and Combine Features

Certain ``MIDIManager`` properties are made observable by using subclasses.

## @Observable

``ObservableMIDIManager`` is a ``MIDIManager`` subclass that makes several instance properties observable in a SwiftUI context.

This can be useful in updating user interface displaying a list of MIDI endpoints updated in real-time as they are added or removed from the system.

- ``ObservableMIDIManager/devices``
- ``ObservableMIDIManager/endpoints``

> Note:
>
> ``ObservableMIDIManager`` requires macOS 14 or iOS 17.

## ObservableObject

``ObservableObjectMIDIManager`` is a ``MIDIManager`` subclass that makes several instance properties observable in a SwiftUI or Combine context.

This can be useful in updating user interface displaying a list of MIDI endpoints updated in real-time as they are added or removed from the system.

- ``ObservableObjectMIDIManager/devices``
- ``ObservableObjectMIDIManager/endpoints``

> Note:
>
> ``ObservableObjectMIDIManager`` requires macOS 10.15 or iOS 13.

## Manual Observation

Manual observation can be implemented by use of a notification handler closure.

``MIDIManager`` offers a ``MIDIManager/notificationHandler`` closure that may be assigned either during initialization or by calling ``MIDIManager/init(clientName:model:manufacturer:notificationHandler:)``. 

## Key-Value Observation

``MIDIManager`` and any of its subclasses do not implement KVO (Key-Value Observation).
