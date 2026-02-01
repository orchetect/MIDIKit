//
//  ObservableMIDIManager.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
internal import CoreMIDI

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
@Observable public final class ObservableMIDIManager: MIDIManager,
    @unchecked Sendable // must restate @unchecked from superclass
{
    override public internal(set) var devices: MIDIDevices {
        get {
            access(keyPath: \.observableDevices)
            return observableDevices.wrappedValue
        }
        _modify {
            access(keyPath: \.observableDevices)
            _$observationRegistrar.willSet(self, keyPath: \.observableDevices)
            defer {
                _$observationRegistrar.didSet(self, keyPath: \.observableDevices)
            }
            yield &observableDevices.wrappedValue
        }
        set {
            guard shouldNotifyObservers(observableDevices.wrappedValue, newValue) else {
                observableDevices.wrappedValue = newValue
                return
            }
            withMutation(keyPath: \.observableDevices) {
                observableDevices.wrappedValue = newValue
            }
        }
    }

    private let observableDevices = ThreadSynchronizedPThreadMutex(wrappedValue: MIDIDevices())

    override public internal(set) var endpoints: MIDIEndpoints {
        get {
            access(keyPath: \.observableEndpoints)
            return observableEndpoints.wrappedValue
        }
        _modify {
            access(keyPath: \.observableEndpoints)
            _$observationRegistrar.willSet(self, keyPath: \.observableEndpoints)
            defer {
                _$observationRegistrar.didSet(self, keyPath: \.observableEndpoints)
            }
            yield &observableEndpoints.wrappedValue
        }
        set {
            guard shouldNotifyObservers(observableEndpoints.wrappedValue, newValue) else {
                observableEndpoints.wrappedValue = newValue
                return
            }
            withMutation(keyPath: \.observableEndpoints) {
                observableEndpoints.wrappedValue = newValue
            }
        }
    }

    private let observableEndpoints = ThreadSynchronizedPThreadMutex(wrappedValue: MIDIEndpoints())
    
    // override func updateDevicesAndEndpoints() {
    //     DispatchQueue.main.async {
    //         super.updateDevicesAndEndpoints()
    //     }
    // }
}

#endif
