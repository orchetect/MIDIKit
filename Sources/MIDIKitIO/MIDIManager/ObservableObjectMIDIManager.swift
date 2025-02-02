//
//  ObservableObjectMIDIManager.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI

#if canImport(Combine)
import Combine

/// ``MIDIManager`` subclass that is an `ObservableObject` in a SwiftUI or Combine context.
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
///     @ObservedObject var midiManager = ObservableObjectMIDIManager(
///         clientName: "MyApp",
///         model: "MyApp",
///         manufacturer: "MyCompany"
///     )
///
///     WindowGroup {
///         ContentView()
///             .environmentObject(midiManager)
///     }
/// }
/// ```
///
/// The observable properties can then be used to update view state as a result of changes in the
/// system's MIDI devices and endpoints.
///
/// ```swift
/// struct ContentView: View {
///     @EnvironmentObject var midiManager: ObservableObjectMIDIManager
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
@available(macOS 10.15, macCatalyst 13, iOS 13, /* tvOS 13, watchOS 6, */ *)
public final class ObservableObjectMIDIManager: MIDIManager, ObservableObject, @unchecked Sendable {
    // note: @ThreadSafeAccess is not necessary as it's inherited from the base class
    public internal(set) override var devices: MIDIDevices {
        get { observableDevices }
        set { observableDevices = newValue }
    }
    private var observableDevices = MIDIDevices()
    
    // note: @ThreadSafeAccess is not necessary as it's inherited from the base class
    public internal(set) override var endpoints: MIDIEndpoints {
        get { observableEndpoints }
        set { observableEndpoints = newValue }
    }
    private var observableEndpoints = MIDIEndpoints()
    
    override func updateObjectsCache() {
        objectWillChange.send()
        super.updateObjectsCache()
    }
}

#endif

#endif
