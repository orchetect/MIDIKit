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
    public internal(set) override var devices: MIDIDevices {
        get { return accessQueue.sync { _devices } }
        _modify {
            var valueCopy = accessQueue.sync { _devices }
            yield &valueCopy
            accessQueue.sync { _devices = valueCopy }
        }
        set { accessQueue.sync { _devices = newValue } }
    }
    private nonisolated(unsafe) var _devices = MIDIDevices()
    
    public internal(set) override var endpoints: MIDIEndpoints {
        get { return accessQueue.sync { _endpoints } }
        _modify {
            var valueCopy = accessQueue.sync { _endpoints }
            yield &valueCopy
            accessQueue.sync { _endpoints = valueCopy }
        }
        set { accessQueue.sync { _endpoints = newValue } }
    }
    private nonisolated(unsafe) var _endpoints = MIDIEndpoints()
}

#endif

#endif
