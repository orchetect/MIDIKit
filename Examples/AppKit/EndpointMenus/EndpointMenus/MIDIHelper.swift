//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitIO

/// Object responsible for managing MIDI services, managing connections, and sending/receiving events.
///
/// `NSLock` is used to synchronize access to mutable properties in order to avoid making the entire
/// class bound to `@MainActor`.
final class MIDIHelper: Sendable {
    public let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    private nonisolated(unsafe) var _notificationSubscribers: [String: MIDIManager.NotificationHandler] = [:]
    private let notificationSubscribersLock = NSLock()
    private var notificationSubscribers: [String: MIDIManager.NotificationHandler] {
        get { notificationSubscribersLock.withLock { _notificationSubscribers } }
        set { notificationSubscribersLock.withLock { _notificationSubscribers = newValue } }
    }
    
    public init(start: Bool = false) {
        if start { self.start() }
    }
    
    deinit {
        teardown()
    }
}

// MARK: - Static

extension MIDIHelper {
    private enum ConnectionTags {
        static let midiIn = "SelectedInputConnection"
        static let midiOut = "SelectedOutputConnection"
    }
}

// MARK: - Lifecycle

extension MIDIHelper {
    public func start() {
        // set up MIDI subsystem notification handler
        midiManager.notificationHandler = { [weak self] notification in
            self?.handle(notification: notification)
        }
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
        
        createConnections()
    }
    
    private func teardown() {
        removeConnections()
        notificationSubscribers.removeAll()
    }
}

// MARK: - MIDI I/O Notifications

extension MIDIHelper {
    public func addNotificationSubscriber(id: String, _ handler: @escaping MIDIManager.NotificationHandler) {
        Task { @MainActor in
            notificationSubscribers[id] = handler
        }
    }
    
    public func removeNotificationSubscriber(id: String) {
        Task { @MainActor in
            notificationSubscribers[id] = nil
        }
    }
    
    private func handle(notification: MIDIIONotification) {
        Task { @MainActor in
            for handler in notificationSubscribers.values {
                Task { handler(notification) }
            }
        }
    }
}

// MARK: - MIDI I/O: Connections

extension MIDIHelper {
    nonisolated public func createConnections() {
        createInputConnection()
        createOutputConnection()
    }
    
    nonisolated public func removeConnections() {
        midiManager.remove(.inputConnection, .withTag(ConnectionTags.midiIn))
        midiManager.remove(.outputConnection, .withTag(ConnectionTags.midiOut))
    }
}

// MARK: - MIDI I/O: Input Connection

extension MIDIHelper {
    nonisolated public var inputConnection: MIDIInputConnection? {
        midiManager.managedInputConnections[ConnectionTags.midiIn]
    }
    
    nonisolated public func createInputConnection() {
        // don't re-create the connection if it already exists
        guard inputConnection == nil else { return }
        
        do {
            try midiManager.addInputConnection(
                to: .none,
                tag: ConnectionTags.midiIn,
                receiver: .eventsLogging(
                    options: [.bundleRPNAndNRPNDataEntryLSB, .filterActiveSensingAndClock]
                )
            )
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    }
    
    /// Updates the existing input connection.
    nonisolated public func updateInputConnection(from prefs: AppPrefs) {
        guard let inputConnection else { return }
        
        switch prefs.midiInID {
        case .invalidMIDIIdentifier:
            inputConnection.removeAllOutputs()
        default:
            let criterium: MIDIEndpointIdentity = .uniqueIDWithFallback(
                id: prefs.midiInID,
                fallbackDisplayName: prefs.midiInDisplayName
            )
            if inputConnection.outputsCriteria != [criterium] {
                inputConnection.removeAllOutputs()
                inputConnection.add(outputs: [criterium])
            }
        }
    }
}

// MARK: - MIDI I/O: Output Connection

extension MIDIHelper {
    nonisolated public var outputConnection: MIDIOutputConnection? {
        midiManager.managedOutputConnections[ConnectionTags.midiOut]
    }
    
    nonisolated public func createOutputConnection() {
        // don't re-create the connection if it already exists
        guard outputConnection == nil else { return }
        
        do {
            try midiManager.addOutputConnection(
                to: .none,
                tag: ConnectionTags.midiOut
            )
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    }
    
    /// Updates the existing output connection.
    nonisolated public func updateOutputConnection(from prefs: AppPrefs) {
        guard let outputConnection else { return }
        
        switch prefs.midiOutID {
        case .invalidMIDIIdentifier:
            outputConnection.removeAllInputs()
        default:
            let criterium: MIDIEndpointIdentity = .uniqueIDWithFallback(
                id: prefs.midiOutID,
                fallbackDisplayName: prefs.midiOutDisplayName
            )
            if outputConnection.inputsCriteria != [criterium] {
                outputConnection.removeAllInputs()
                outputConnection.add(inputs: [criterium])
            }
        }
    }
}

// MARK: - Persistent State

extension MIDIHelper {
    /// Call this only once after class init.
    public func restorePersistentState(from prefs: AppPrefs) {
        updateInputConnection(from: prefs)
        updateOutputConnection(from: prefs)
    }
}
