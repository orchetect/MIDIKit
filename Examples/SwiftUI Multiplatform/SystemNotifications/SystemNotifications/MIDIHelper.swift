//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

/// Object responsible for managing MIDI services, managing connections, and sending/receiving events.
///
/// Marking the class as `@Observable` allows us to install an instance of the class in a SwiftUI App or View
/// and propagate it through the environment.
@Observable public final class MIDIHelper: Sendable {
    private let midiManager = ObservableMIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    public init(start: Bool = false) {
        if start { self.start() }
    }
}

// MARK: - Lifecycle

extension MIDIHelper {
    public func start() {
        midiManager.notificationHandler = { [weak self] notification in
            self?.logNotification(notification)
        }
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    }
    
    public func stop() {
        midiManager.removeAll()
    }
}

// MARK: - Virtual Endpoints

extension MIDIHelper {
    public func addVirtualInput() {
        let name = UUID().uuidString
        // we don't care about received MIDI events for this example project
        try? midiManager.addInput(
            name: name,
            tag: name,
            uniqueID: .adHoc,
            receiver: .events { _, _, _ in }
        )
    }
    
    public func addVirtualOutput() {
        let name = UUID().uuidString
        // we won't be sending any events in this example project
        try? midiManager.addOutput(name: name, tag: name, uniqueID: .adHoc)
    }
    
    public func removeVirtualInput() {
        guard let port = midiManager.managedInputs.randomElement() else { return }
        midiManager.remove(.input, .withTag(port.key))
    }
    
    public func removeVirtualOutput() {
        guard let port = midiManager.managedOutputs.randomElement() else { return }
        midiManager.remove(.output, .withTag(port.key))
    }
}

// MARK: - MIDI Notification Logging

extension MIDIHelper {
    private func logNotification(_ notification: MIDIIONotification) {
        switch notification {
        case .setupChanged:
            print("Setup changed")
            
        case let .added(object, parent):
            let objectDescription = description(for: object)
            let parentDescription = description(for: parent)
            print("Added: \(objectDescription), parent: \(parentDescription)")
            
        case let .removed(object, parent):
            let objectDescription = description(for: object)
            let parentDescription = description(for: parent)
            print("Removed: \(objectDescription), parent: \(parentDescription)")
            
        case let .propertyChanged(property, object):
            let objectDescription = description(for: object)
            let propertyValueDescription = object.propertyStringValue(for: property)
            print("Property Changed: \(property) for \(objectDescription) to \(propertyValueDescription)")
            
        case .thruConnectionChanged:
            // this notification carries no data
            print("Thru Connection Changed")
            
        case .serialPortOwnerChanged:
            // this notification carries no data
            print("Serial Port Owner Changed")
            
        case let .ioError(device, error):
            print("I/O Error for device \(device.name): \(error)")
            
        case .internalStart:
            print("Internal Start")
            
        case let .other(messageIDRawValue):
            print("Other with ID \(messageIDRawValue)")
        }
    }
    
    private func description(for object: AnyMIDIIOObject?) -> String {
        guard let object else { return "nil" }
        
        switch object {
        case let .device(device):
            return "Device \(device) with \(device.entities.count) entities"
            
        case let .entity(entity):
            return "Entity \(entity) with \(entity.inputs.count) inputs and \(entity.outputs.count) outputs"
            
        case let .inputEndpoint(endpoint):
            return "Input Endpoint \"\(endpoint.name)\" with ID \(endpoint.uniqueID)"
            
        case let .outputEndpoint(endpoint):
            return "Output Endpoint \"\(endpoint.name)\" with ID \(endpoint.uniqueID)"
        }
    }
}

// MARK: - ViewModel Proxies

extension MIDIHelper {
    /// This property is observable in SwiftUI views because it points to an observable property of the MIDI manager.
    public var isVirtualInputsExist: Bool {
        !midiManager.endpoints.inputsOwned.isEmpty
    }
    
    /// This property is observable in SwiftUI views because it points to an observable property of the MIDI manager.
    public var isVirtualOutputsExist: Bool {
        !midiManager.endpoints.outputsOwned.isEmpty
    }
}
