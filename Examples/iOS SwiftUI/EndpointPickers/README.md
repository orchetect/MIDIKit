# EndpointPickers Example (iOS SwiftUI)

This example demonstrates best practises when creating MIDI input and output selection menus.

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
  
- Received events are logged on-screen, and test events can be sent to the MIDI Out selection using the buttons in the window.

## Special Notes

- Due to SwiftUI limitations, it is necessary (and beneficial) to abstract MIDI setup and maintenance functions inside a custom helper class instance (called `MIDIHelper` in this example) while also keeping the MIDI `Manager` separate.
  - This ensures the use of Combine features of the MIDI `Manager` remain available, which would be lost if the `Manager` was bundled inside the custom helper class.
  - Since MIDI event receiver handlers are escaping closures, it's impossible to mutate SwiftUI `App` or `View` state from within them. By creating these handlers inside the helper class, we can update a `@Published` variable inside the helper class which can be observed by any view in the SwiftUI hierarchy if desired.
  - This way the `Manager` and helper become central services with an app-scoped lifecycle that can be passed into subviews using `.environmentObject()`
- For testing purposes, try clicking the **Create Test Virtual Endpoints** button, selecting them as MIDI In and MIDI Out, then destroying them. They appear as missing but their selection is retained. Then create them again, and they will appear normally once again and connection will resume. They are remembered even if you quit the app.
