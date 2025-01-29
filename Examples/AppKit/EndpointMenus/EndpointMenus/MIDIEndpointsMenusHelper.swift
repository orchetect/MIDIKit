//
//  MIDIEndpointsMenusHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import AppKit
import Foundation
import MIDIKitIO

final class MIDIEndpointsMenusHelper {
    weak var midiManager: MIDIManager?
    weak var midiInMenu: NSMenu?
    weak var midiOutMenu: NSMenu?
    
    public private(set) var midiOutMenuSelectedID: MIDIIdentifier = .invalidMIDIIdentifier
    public private(set) var midiOutMenuSelectedDisplayName: String = ""
    
    public private(set) var midiInMenuSelectedID: MIDIIdentifier = .invalidMIDIIdentifier
    public private(set) var midiInMenuSelectedDisplayName: String = ""
    
    public init(
        midiManager: MIDIManager,
        midiInMenu: NSMenu,
        midiOutMenu: NSMenu
    ) {
        self.midiManager = midiManager
        self.midiInMenu = midiInMenu
        self.midiOutMenu = midiOutMenu
    }
}

// MARK: - Setup

extension MIDIEndpointsMenusHelper {
    public func setup() {
        guard let midiManager else { return }
        
        do {
            print("Starting MIDI services.")
            try midiManager.start()
            
            // set up MIDI subsystem notification handler
            midiManager.notificationHandler = { [weak self] notification, manager in
                self?.didReceiveMIDIIONotification(notification)
            }
            
            // set up input connection
            try midiManager.addInputConnection(
                to: .none,
                tag: ConnectionTags.midiIn,
                receiver: .eventsLogging(options: [
                    .bundleRPNAndNRPNDataEntryLSB,
                    .filterActiveSensingAndClock
                ])
            )
            
            // set up output connection
            try midiManager.addOutputConnection(
                to: .none,
                tag: ConnectionTags.midiOut
            )
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
    }
}

// MARK: - String Constants

extension MIDIEndpointsMenusHelper {
    private enum ConnectionTags {
        static let midiIn = "SelectedInputConnection"
        static let midiOut = "SelectedOutputConnection"
    }
    
    private enum UserDefaultsKeys {
        static let midiInID = "SelectedMIDIInID"
        static let midiInDisplayName = "SelectedMIDIInDisplayName"
        
        static let midiOutID = "SelectedMIDIOutID"
        static let midiOutDisplayName = "SelectedMIDIOutDisplayName"
    }
}

// MARK: - Persistent State

extension MIDIEndpointsMenusHelper {
    /// Call this only once on app launch.
    public func restorePersistentState() {
        // restore endpoint selection saved to UserDefaults
        midiInMenuSetSelected(
            id: .init(
                exactly: UserDefaults.standard.integer(forKey: UserDefaultsKeys.midiInID)
            ) ?? .invalidMIDIIdentifier,
            displayName: UserDefaults.standard.string(
                forKey: UserDefaultsKeys.midiInDisplayName
            ) ?? ""
        )
        midiOutMenuSetSelected(
            id: .init(
                exactly: UserDefaults.standard.integer(forKey: UserDefaultsKeys.midiOutID)
            ) ?? .invalidMIDIIdentifier,
            displayName: UserDefaults.standard.string(
                forKey: UserDefaultsKeys.midiOutDisplayName
            ) ?? ""
        )
    }
    
    /// Call this only once on app quit.
    public func savePersistentState() {
        // save endpoint selection to UserDefaults
        
        UserDefaults.standard.set(
            midiInMenuSelectedID,
            forKey: UserDefaultsKeys.midiInID
        )
        UserDefaults.standard.set(
            midiInMenuSelectedDisplayName,
            forKey: UserDefaultsKeys.midiInDisplayName
        )
        
        UserDefaults.standard.set(
            midiOutMenuSelectedID,
            forKey: UserDefaultsKeys.midiOutID
        )
        UserDefaults.standard.set(
            midiOutMenuSelectedDisplayName,
            forKey: UserDefaultsKeys.midiOutDisplayName
        )
    }
}

// MARK: - Helpers

extension MIDIEndpointsMenusHelper {
    private func didReceiveMIDIIONotification(_ notification: MIDIIONotification) {
        switch notification {
        case .added, .removed, .propertyChanged:
            midiInUpdateMetadata()
            midiInMenuRefresh()
            
            midiOutUpdateMetadata()
            midiOutMenuRefresh()
        default:
            break
        }
    }
}

// MARK: - MIDI In Menu

extension MIDIEndpointsMenusHelper {
    public var midiInputConnection: MIDIInputConnection? {
        midiManager?.managedInputConnections[ConnectionTags.midiIn]
    }
    
    /// Set the selected MIDI output manually.
    public func midiInMenuSetSelected(
        id: MIDIIdentifier,
        displayName: String
    ) {
        midiInMenuSelectedID = id
        midiInMenuSelectedDisplayName = displayName
        midiInMenuRefresh()
        midiInMenuUpdateConnection()
    }
    
    private func midiInMenuRefresh() {
        guard let midiManager = midiManager,
              let midiInMenu = midiInMenu
        else { return }
        
        midiInMenu.items.removeAll()
        
        let sortedEndpoints = midiManager.endpoints.outputs.sortedByDisplayName()
        
        // None menu item
        do {
            let newMenuItem = NSMenuItem(
                title: "None",
                action: #selector(midiInMenuItemSelected),
                keyEquivalent: ""
            )
            newMenuItem.tag = Int(MIDIIdentifier.invalidMIDIIdentifier)
            newMenuItem.state = midiInMenuSelectedID == .invalidMIDIIdentifier ? .on : .off
            midiInMenu.addItem(newMenuItem)
        }
        
        // ---------------
        midiInMenu.addItem(.separator())
        
        // If selected endpoint doesn't exist in the system,
        // show it in the menu as missing but still selected.
        // The MIDIManager will auto-reconnect to it if it reappears
        // in the system in this condition.
        if midiInMenuSelectedID != .invalidMIDIIdentifier,
           !sortedEndpoints.contains(
               whereUniqueID: midiInMenuSelectedID,
               fallbackDisplayName: midiInMenuSelectedDisplayName
           )
        {
            let newMenuItem = NSMenuItem(
                title: "⚠️ " + midiInMenuSelectedDisplayName,
                action: #selector(midiInMenuItemSelected),
                keyEquivalent: ""
            )
            newMenuItem.tag = Int(midiInMenuSelectedID)
            newMenuItem.state = .on
            midiInMenu.addItem(newMenuItem)
        }
        
        // Add endpoints to the menu
        for endpoint in sortedEndpoints {
            let newMenuItem = NSMenuItem(
                title: endpoint.displayName,
                action: #selector(midiInMenuItemSelected),
                keyEquivalent: ""
            )
            newMenuItem.tag = Int(endpoint.uniqueID)
            if endpoint.uniqueID == midiInMenuSelectedID {
                newMenuItem.state = .on
            }
            
            midiInMenu.addItem(newMenuItem)
        }
    }
    
    @objc
    public func midiInMenuItemSelected(_ sender: NSMenuItem?) {
        midiInMenuSelectedID = MIDIIdentifier(
            exactly: sender?.tag ?? 0
        ) ?? .invalidMIDIIdentifier
        
        midiInUpdateMetadata()
        
        midiInMenuRefresh()
        midiInMenuUpdateConnection()
    }
    
    private func midiInUpdateMetadata() {
        if let foundOutput = midiManager?.endpoints.outputs.first(
            whereUniqueID: midiInMenuSelectedID,
            fallbackDisplayName: midiInMenuSelectedDisplayName
        ) {
            midiInMenuSelectedID = foundOutput.uniqueID
            midiInMenuSelectedDisplayName = foundOutput.displayName
        }
    }
    
    private func midiInMenuUpdateConnection() {
        guard let midiInputConnection else { return }
        
        if midiInMenuSelectedID == .invalidMIDIIdentifier {
            midiInputConnection.removeAllOutputs()
        } else {
            let criterium: MIDIEndpointIdentity = .uniqueIDWithFallback(
                id: midiInMenuSelectedID,
                fallbackDisplayName: midiInMenuSelectedDisplayName
            )
            if midiInputConnection.outputsCriteria != [criterium] {
                midiInputConnection.removeAllOutputs()
                midiInputConnection.add(outputs: [criterium])
            }
        }
    }
}

// MARK: - MIDI Out Menu

extension MIDIEndpointsMenusHelper {
    public var midiOutputConnection: MIDIOutputConnection? {
        midiManager?.managedOutputConnections[ConnectionTags.midiOut]
    }
    
    public func midiOutMenuSetSelected(
        id: MIDIIdentifier,
        displayName: String
    ) {
        midiOutMenuSelectedID = id
        midiOutMenuSelectedDisplayName = displayName
        midiOutMenuRefresh()
        midiOutMenuUpdateConnection()
    }
    
    private func midiOutMenuRefresh() {
        guard let midiManager = midiManager,
              let midiOutMenu = midiOutMenu
        else { return }
        
        midiOutMenu.items.removeAll()
        
        let sortedEndpoints = midiManager.endpoints.inputs.sortedByDisplayName()
        
        // None menu item
        do {
            let newMenuItem = NSMenuItem(
                title: "None",
                action: #selector(midiOutMenuItemSelected),
                keyEquivalent: ""
            )
            newMenuItem.tag = Int(MIDIIdentifier.invalidMIDIIdentifier)
            newMenuItem.state = midiOutMenuSelectedID == .invalidMIDIIdentifier ? .on : .off
            midiOutMenu.addItem(newMenuItem)
        }
        
        // ---------------
        midiOutMenu.addItem(.separator())
        
        // If selected endpoint doesn't exist in the system,
        // show it in the menu as missing but still selected.
        // The MIDIManager will auto-reconnect to it if it reappears
        // in the system in this condition.
        if midiOutMenuSelectedID != .invalidMIDIIdentifier,
           !sortedEndpoints.contains(
               whereUniqueID: midiOutMenuSelectedID,
               fallbackDisplayName: midiOutMenuSelectedDisplayName
           )
        {
            let newMenuItem = NSMenuItem(
                title: "⚠️ " + midiOutMenuSelectedDisplayName,
                action: #selector(midiOutMenuItemSelected),
                keyEquivalent: ""
            )
            newMenuItem.tag = Int(midiOutMenuSelectedID)
            newMenuItem.state = .on
            midiOutMenu.addItem(newMenuItem)
        }
        
        // Add endpoints to the menu
        for endpoint in sortedEndpoints {
            let newMenuItem = NSMenuItem(
                title: endpoint.displayName,
                action: #selector(midiOutMenuItemSelected),
                keyEquivalent: ""
            )
            newMenuItem.tag = Int(endpoint.uniqueID)
            if endpoint.uniqueID == midiOutMenuSelectedID { newMenuItem.state = .on }
            
            midiOutMenu.addItem(newMenuItem)
        }
    }
    
    @objc
    public func midiOutMenuItemSelected(_ sender: NSMenuItem?) {
        midiOutMenuSelectedID = MIDIIdentifier(
            exactly: sender?.tag ?? 0
        ) ?? .invalidMIDIIdentifier
        
        midiOutUpdateMetadata()
        
        midiOutMenuRefresh()
        midiOutMenuUpdateConnection()
    }
    
    private func midiOutUpdateMetadata() {
        if let foundInput = midiManager?.endpoints.inputs.first(
            whereUniqueID: midiOutMenuSelectedID,
            fallbackDisplayName: midiOutMenuSelectedDisplayName
        ) {
            midiOutMenuSelectedID = foundInput.uniqueID
            midiOutMenuSelectedDisplayName = foundInput.displayName
        }
    }
    
    private func midiOutMenuUpdateConnection() {
        guard let midiOutputConnection else { return }
        
        if midiOutMenuSelectedID == .invalidMIDIIdentifier {
            midiOutputConnection.removeAllInputs()
        } else {
            let criterium: MIDIEndpointIdentity = .uniqueIDWithFallback(
                id: midiOutMenuSelectedID,
                fallbackDisplayName: midiOutMenuSelectedDisplayName
            )
            if midiOutputConnection.inputsCriteria != [criterium] {
                midiOutputConnection.removeAllInputs()
                midiOutputConnection.add(inputs: [criterium])
            }
        }
    }
}
