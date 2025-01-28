//
//  ObservableMIDIManager.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if compiler(>=6.0)
internal import CoreMIDI
#else
@_implementationOnly import CoreMIDI
#endif

#if canImport(Combine)
import Combine

/// ``MIDIManager`` subclass that is observable in a SwiftUI view.
/// This makes the ``devices`` and ``endpoints`` properties observable.
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
        get { return _devicesLock.withLock { _devices } }
        _modify {
            var valueCopy = _devicesLock.withLock { _devices }
            yield &valueCopy
            _devicesLock.withLock { _devices = valueCopy }
        }
        set { _devicesLock.withLock { _devices = newValue } }
    }
    private nonisolated(unsafe) var _devices = MIDIDevices()
    @ObservationIgnored private let _devicesLock = NSLock()
    
    public internal(set) override var endpoints: MIDIEndpoints {
        get { return _endpointsLock.withLock { _endpoints } }
        _modify {
            var valueCopy = _endpointsLock.withLock { _endpoints }
            yield &valueCopy
            _endpointsLock.withLock { _endpoints = valueCopy }
        }
        set { _endpointsLock.withLock { _endpoints = newValue } }
    }
    private nonisolated(unsafe) var _endpoints = MIDIEndpoints()
    @ObservationIgnored private let _endpointsLock = NSLock()
}

#endif

#endif
