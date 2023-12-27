//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

/// Receiving MIDI happens as an asynchronous background callback. That means it cannot update
/// SwiftUI view state directly. Therefore, we need a helper class that conforms to
/// `ObservableObject` which contains `@Published` properties that SwiftUI can use to update views.
final class MIDIHelper: ObservableObject {
    private weak var midiManager: ObservableMIDIManager?
    
    public init() { }
    
    public func setup(midiManager: ObservableMIDIManager) {
        self.midiManager = midiManager
        
        midiManager.notificationHandler = { notification, manager in
            self.logNotification(notification)
        }
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    }
    
    // MARK: - Virtual Endpoints
    
    func addVirtualInput() {
        guard let midiManager else { return }
        let name = UUID().uuidString
        // we don't care about received MIDI events for this example project
        try? midiManager.addInput(
            name: name,
            tag: name,
            uniqueID: .adHoc,
            receiver: .events { _, _, _ in }
        )
    }
    
    func addVirtualOutput() {
        guard let midiManager else { return }
        let name = UUID().uuidString
        // we won't be sending any events in this example project
        try? midiManager.addOutput(name: name, tag: name, uniqueID: .adHoc)
    }
    
    func removeVirtualInput() {
        guard let midiManager else { return }
        guard let port = midiManager.managedInputs.randomElement() else { return }
        midiManager.remove(.input, .withTag(port.key))
    }
    
    func removeVirtualOutput() {
        guard let midiManager else { return }
        guard let port = midiManager.managedOutputs.randomElement() else { return }
        midiManager.remove(.output, .withTag(port.key))
    }
    
    // MARK: - Log MIDI Notification
    
    func logNotification(_ notification: MIDIIONotification) {
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
            print(
                "Property Changed: \(property) for \(objectDescription) to \(propertyValueDescription)"
            )
            
        case .thruConnectionChanged:
            // this notification carries no data
            print("Thru Connection Changed")
            
        case .serialPortOwnerChanged:
            // this notification carries no data
            print("Serial Port Owner Changed")
            
        case let .ioError(device, error):
            print("I/O Error for device \(device.name): \(error)")
            
        case let .other(messageIDRawValue):
            print("Other with ID \(messageIDRawValue)")
        }
    }
    
    func description(for object: AnyMIDIIOObject?) -> String {
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
