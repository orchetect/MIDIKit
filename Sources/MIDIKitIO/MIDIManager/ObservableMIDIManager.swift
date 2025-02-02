//
//  ObservableMIDIManager.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI

#if canImport(Combine)
import Combine

/// ``MIDIManager`` subclass that is `@Observable` in a SwiftUI view.
/// This makes the ``devices`` and ``endpoints`` properties observable.
///
/// > Tip:
/// >
/// > For general usage information, see the base ``MIDIManager`` class documentation.
///
/// ## Observation Features
///
/// Generally it is recommended to install the manager instance in the `App` struct.
///
/// ```swift
/// @main
/// struct MyApp: App {
///     @State var midiManager = ObservableMIDIManager(
///         clientName: "MyApp",
///         model: "MyApp",
///         manufacturer: "MyCompany"
///     )
///
///     WindowGroup {
///         ContentView()
///             .environment(midiManager)
///     }
/// }
/// ```
///
/// The observable properties can then be used to update view state as a result of changes in the
/// system's MIDI devices and endpoints.
///
/// ```swift
/// struct ContentView: View {
///     @Environment(ObservableMIDIManager.self) private var midiManager
///
///     var body: some View {
///         List(midiManager.devices.devices) { device in
///             Text(device.name)
///         }
///         List(midiManager.endpoints.inputs) { input in
///             Text(input.name)
///         }
///         List(midiManager.endpoints.outputs) { output in
///             Text(output.name)
///         }
///     }
/// }
/// ```
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@Observable public final class ObservableMIDIManager: MIDIManager, @unchecked Sendable {
    // note: @ThreadSafeAccess is not necessary as it's inherited from the base class
    public internal(set) override var devices: MIDIDevices {
         get { observableDevices }
        _modify { yield &observableDevices }
        set { observableDevices = newValue }
    }
    private var observableDevices = MIDIDevices()
    
    // note: @ThreadSafeAccess is not necessary as it's inherited from the base class
    public internal(set) override var endpoints: MIDIEndpoints {
        get { observableEndpoints }
        _modify { yield &observableEndpoints }
        set { observableEndpoints = newValue }
    }
    private var observableEndpoints = MIDIEndpoints()
}

#endif

#endif
