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
/// Two new properties are available: ``observableDevices`` and ``observableEndpoints``.
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
///         List(midiManager.observableDevices.devices) { device in
///             Text(device.name)
///         }
///         List(midiManager.observableEndpoints.inputs) { input in
///             Text(input.name)
///         }
///         List(midiManager.observableEndpoints.outputs) { output in
///             Text(output.name)
///         }
///     }
/// }
/// ```
@available(macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0, *)
@Observable public final class ObservableMIDIManager: MIDIManager {
    // MARK: - Properties
    
    /// MIDI devices in the system.
    /// This is an observable implementation of ``MIDIManager/devices``.
    public internal(set) var observableDevices = MIDIDevices()
    
    /// MIDI input and output endpoints in the system.
    /// This is an observable implementation of ``MIDIManager/endpoints``.
    public internal(set) var observableEndpoints = MIDIEndpoints(manager: nil)
    
    /// Handler that is called when state has changed in the manager.
    public typealias ObservableNotificationHandler = (
        _ notification: MIDIIONotification,
        _ manager: ObservableMIDIManager
    ) -> Void
    
    // MARK: - Init
    
    /// Initialize the MIDI manager (and Core MIDI client).
    ///
    /// - Parameters:
    ///   - clientName: Name identifying this instance, used as Core MIDI client ID.
    ///     This is internal and not visible to the end-user.
    ///   - model: The name of your software, which will be visible to the end-user in ports created
    ///     by the manager.
    ///   - manufacturer: The name of your company, which may be visible to the end-user in ports
    ///     created by the manager.
    ///   - notificationHandler: Optionally supply a callback handler for MIDI system notifications.
    public override init(
        clientName: String,
        model: String,
        manufacturer: String,
        notificationHandler: ObservableNotificationHandler? = nil
    ) {
        // wrap base MIDIManager handler with one that supplies an observable manager reference
        var notificationHandlerWrapper: NotificationHandler? = nil
        if let notificationHandler = notificationHandler {
            notificationHandlerWrapper = { notif, manager in
                guard let typedManager = manager as? ObservableMIDIManager else {
                    assertionFailure("MIDI Manager is not expected type ObservableMIDIManager.")
                    return
                }
                notificationHandler(notif, typedManager)
            }
        }
        
        super.init(
            clientName: clientName,
            model: model,
            manufacturer: manufacturer,
            notificationHandler: notificationHandlerWrapper
        )
        
        observableEndpoints.manager = self
    }
    
    public override func updateObjectsCache() {
        // objectWillChange.send() // redundant since all local properties are marked @Published
        super.updateObjectsCache()
        
        observableDevices.updateCachedProperties()
        observableEndpoints.updateCachedProperties()
    }
}

#endif

#endif
