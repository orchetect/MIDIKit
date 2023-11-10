# MIDIKitUI Example

This example shows usage of the MIDIKitUI package target SwiftUI controls.

These bundled UI components provide easy-to-use implementations of endpoint selector lists and pickers.

- Updates the UI in realtime to reflect changes in system endpoints.
- Remembers selections between app launches.
- Shows visual feedback when a selection is an endpoint that is currently not present in the system, by displaying a caution symbol next to the list item. This selection will be fully restored when the endpoint reappears in the system.

## Future Development To Do List

Aspects of this example project that are currently not yet built, but may be added in future:

- Multiple-selection list control
- Demonstrate updating connections in the `MIDIManager` on endpoint selection change