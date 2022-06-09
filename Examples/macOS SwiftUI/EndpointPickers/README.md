# EndpointPickers Example (macOS SwiftUI)

This example demonstrates best practises when creating MIDI input and output selection menus.

## Build Note

⚠️ If Xcode builds but the app does not run, it may be because Xcode is defaulting to the wrong Scheme. Ensure the example app's Scheme is selected then try again.

## Key Features

- The menus are updated in real-time if endpoints change in the system.
  > In SwiftUI, this happens automatically when using certain data-source properties of the `Manager`.
  >
  > - `midiManager.endpoints.inputs` or `midiManager.endpoints.outputs`
  >   Changes in MIDI endpoints in the system will trigger these arrays to refresh your view.
  > - `midiManager.devices.devices`
  >   Changes in MIDI devices in the system will trigger this array to refresh your view.
  
- The menus allow for a single endpoint to be selected, or None may be selected to disable the connection.
  > This is a common use case. However some use cases require the ability to select multiple endpoints. For a demonstration of how to implement that, see the EndpointLists example.

- The menu selections are stored in UserDefaults and restored on app relaunch so the user's selections are remembered.
  > This is optional but included to demonstrate that using endpoint UniqueID numbers are the proper method to persistently reference endpoints (since endpoint names can change and multiple endpoints in the system may share the same name). UserDefaults is simply a convenient location to store the setting.
  >
  > In order to display a missing port's name to the user, we also persistently store the port's Display Name string since it's impossible to query Core MIDI for that if the port doesn't exist in the system.
  
- Maintaining a user's desired selection is reserved even if it disappears from the system.
  > Often a user will select a desired MIDI endpoint and want that to always remain selected, but they may disconnect the device from time to time or it may not be present in the system at the point when your app is launching or your are restoring MIDI endpoint connections in your app. (Such as a USB keyboard by powering it off or physically disconnecting it from the system).
  >
  > In this example, if a selected endpoint no longer exists in the system, it will still remain selected in the menu but will gain a caution symbol showing that it's missing simply to communicate to the user that it is currently missing. Since we set up the managed connections with that desired endpoint's unique ID, if the endpoint reappears in the system, the `Manager` will automatically reconnect it and resume data flow. The menu item will once again appear as a normal selection without the caution symbol. The user does not need to do anything and this is all handled seamlessly and automatically.
  
- Received events are logged the console, and test events can be sent to the MIDI Out selection using the buttons in the window.

## Special Notes

- The SwiftUI views in this example are abstracted in such a way that:
  - The App contains the `Manager` and is capable of restoring saved connections and sending/receiving MIDI. This way it becomes a central service and can be passed into subviews using `.environmentObject(midiManager)`
  - The `MIDIEndpointSelectionView()` instance can be removed from `ContentView` and the app still functions as expected. In that way, `MIDIEndpointSelectionView` acts as a MIDI endpoint configuration view that can be shown or removed from view at any time.
