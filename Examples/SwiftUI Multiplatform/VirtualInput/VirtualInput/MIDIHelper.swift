//
//  MIDIHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI
import Synchronization

/// Object responsible for managing MIDI services, managing connections, and sending/receiving events.
///
/// Marking the class as `@Observable` allows us to install an instance of the class in a SwiftUI App or View
/// and propagate it through the environment.
///
/// Here, access to the `eventHandler` closure is internally synchronized to enable this class to be `Sendable`.
/// This solution was chosen because:
/// - it is a 1st-party language feature, which is usually desirable in place of a 3rd-party/DIY locking solution
/// - it is Swift Concurrency safe, unlike `NSLock` or many DIY solutions
/// - making the class an actor prevents us from making it `@Observable` in future and installable in a SwiftUI App/View
/// - making the class bound to `@MainActor` would be overkill, and would force background processing to be pushed
///   onto the main thread needlessly
/// This is only one possible solution. Alternatively, specifying the closure during initialization could allow us to
/// remove the Mutex and make the closure property's declaration a simple let statement, therefore removing mutability.
@Observable public final class MIDIHelper: Sendable {
    private let midiManager = ObservableMIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    public typealias EventHandler = @Sendable (MIDIEvent) -> Void
    @ObservationIgnored private let _eventHandler = Mutex<EventHandler?>(nil)
    private var eventHandler: EventHandler? {
        get { _eventHandler.withLock { $0 } }
        set { _eventHandler.withLock { $0 = newValue } }
    }
    
    public init(start: Bool = false) {
        if start { self.start() }
    }
}

// MARK: - Static

extension MIDIHelper {
    public var virtualInputName: String { "TestApp Input" }
}

// MARK: - Lifecycle

extension MIDIHelper {
    public func start() {
        do {
            print("Starting MIDI services.")
            try midiManager.start()
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
        
        createInput()
    }
    
    public func stop() {
        removeInput()
    }
}

// MARK: - I/O

extension MIDIHelper {
    private func createInput() {
        do {
            print("Creating virtual MIDI input.")
            try midiManager.addInput(
                name: virtualInputName,
                tag: virtualInputName,
                uniqueID: .userDefaultsManaged(key: virtualInputName),
                receiver: .events(
                    options: [.filterActiveSensingAndClock, .bundleRPNAndNRPNDataEntryLSB]
                ) { [weak self] events, timeStamp, source in
                    self?.received(events: events)
                }
            )
        } catch {
            print("Error creating virtual MIDI input:", error.localizedDescription)
        }
    }
    
    private func removeInput() {
        midiManager.remove(.input, .withTag(virtualInputName))
    }
}

// MARK: - Events

extension MIDIHelper {
    public func setEventHandler(_ handler: sending EventHandler?) {
        eventHandler = handler
    }
    
    private func received(events: [MIDIEvent]) {
        // unwrap, and take a local copy of the handler which prevents repeated Mutex unlock/lock cycles
        guard let eventHandler else { return }
        
        for event in events {
            eventHandler(event)
        }
    }
}

