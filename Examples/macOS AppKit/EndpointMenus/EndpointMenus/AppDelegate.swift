//
//  AppDelegate.swift
//  EndpointMenus
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Cocoa
import MIDIKit

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var midiInMenu: NSMenu!
    @IBOutlet var midiOutMenu: NSMenu!
    
    let midiManager = MIDIManager(
        clientName: "TestAppMIDIManager",
        model: "TestApp",
        manufacturer: "MyCompany"
    )
    
    public private(set) var midiOutMenuSelectedID: MIDIIdentifier = 0
    public private(set) var midiOutMenuSelectedDisplayName: String = ""
    
    public private(set) var midiInMenuSelectedID: MIDIIdentifier = 0
    public private(set) var midiInMenuSelectedDisplayName: String = ""
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        do {
            print("Starting MIDI services.")
            try midiManager.start()
            
            // set up MIDI subsystem notification handler
            midiManager.notificationHandler = { [weak self] notification, manager in
                self?.didReceiveMIDIIONotification(notification)
            }
            
            // set up input connection
            try midiManager.addInputConnection(
                toOutputs: [],
                tag: ConnectionTags.midiIn,
                receiveHandler: .eventsLogging(filterActiveSensingAndClock: true)
            )
            
            // set up output connection
            try midiManager.addOutputConnection(
                toInputs: [],
                tag: ConnectionTags.midiOut
            )
        } catch {
            print("Error starting MIDI services:", error.localizedDescription)
        }
        
        // restore endpoint selection saved to persistent storage
        midiRestorePersistentState()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // save endpoint selection to persistent storage
        midiSavePersistentState()
    }
}

// MARK: - String Constants

extension AppDelegate {
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

// MARK: - Helpers

extension AppDelegate {
    /// Call this only once on app launch.
    private func midiRestorePersistentState() {
        // restore endpoint selection saved to UserDefaults
        midiInMenuSetSelected(
            id: .init(
                exactly: UserDefaults.standard.integer(forKey: UserDefaultsKeys.midiInID)
            ) ?? 0,
            displayName: UserDefaults.standard.string(
                forKey: UserDefaultsKeys.midiInDisplayName
            ) ?? ""
        )
        midiOutMenuSetSelected(
            id: .init(
                exactly: UserDefaults.standard.integer(forKey: UserDefaultsKeys.midiOutID)
            ) ?? 0,
            displayName: UserDefaults.standard.string(
                forKey: UserDefaultsKeys.midiOutDisplayName
            ) ?? ""
        )
    }
    
    /// Call this only once on app quit.
    private func midiSavePersistentState() {
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
    
    private func didReceiveMIDIIONotification(_ notification: MIDIIONotification) {
        switch notification {
        case .added, .removed, .propertyChanged:
            midiOutMenuRefresh()
            midiInMenuRefresh()
        default:
            break
        }
    }
}

// MARK: - MIDI In Menu

extension AppDelegate {
    var midiInputConnection: MIDIInputConnection? {
        midiManager.managedInputConnections[ConnectionTags.midiIn]
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
        midiInMenu.items.removeAll()
        
        let sortedEndpoints = midiManager.endpoints.outputs.sortedByDisplayName()
        
        // None menu item
        do {
            let newMenuItem = NSMenuItem(
                title: "None",
                action: #selector(midiInMenuItemSelected),
                keyEquivalent: ""
            )
            newMenuItem.tag = 0
            newMenuItem.state = midiInMenuSelectedID == 0 ? .on : .off
            midiInMenu.addItem(newMenuItem)
        }
        
        // ---------------
        midiInMenu.addItem(.separator())
        
        // If selected endpoint doesn't exist in the system, show it in the menu as missing but still selected.
        // The MIDI Manager will auto-reconnect to it if it reappears in the system in this condition.
        if midiInMenuSelectedID != 0,
           !sortedEndpoints.contains(whereUniqueID: midiInMenuSelectedID)
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
    private func midiInMenuItemSelected(_ sender: NSMenuItem?) {
        midiInMenuSelectedID = MIDIIdentifier(exactly: sender?.tag ?? 0) ?? 0
        
        if let foundOutput = midiManager.endpoints.outputs.first(where: {
            $0.uniqueID == midiInMenuSelectedID
        }) {
            midiInMenuSelectedDisplayName = foundOutput.displayName
        }
        
        midiInMenuRefresh()
        midiInMenuUpdateConnection()
    }
    
    private func midiInMenuUpdateConnection() {
        guard let midiInputConnection = midiInputConnection else { return }
        
        if midiInMenuSelectedID == 0 {
            midiInputConnection.removeAllOutputs()
        } else {
            if midiInputConnection.outputsCriteria != [.uniqueID(midiInMenuSelectedID)] {
                midiInputConnection.removeAllOutputs()
                midiInputConnection.add(outputs: [.uniqueID(midiInMenuSelectedID)])
            }
        }
    }
}

// MARK: - MIDI Out Menu

extension AppDelegate {
    var midiOutputConnection: MIDIOutputConnection? {
        midiManager.managedOutputConnections[ConnectionTags.midiOut]
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
        midiOutMenu.items.removeAll()
        
        let sortedEndpoints = midiManager.endpoints.inputs.sortedByDisplayName()
        
        // None menu item
        do {
            let newMenuItem = NSMenuItem(
                title: "None",
                action: #selector(midiOutMenuItemSelected),
                keyEquivalent: ""
            )
            newMenuItem.tag = 0
            newMenuItem.state = midiOutMenuSelectedID == 0 ? .on : .off
            midiOutMenu.addItem(newMenuItem)
        }
        
        // ---------------
        midiOutMenu.addItem(.separator())
        
        // If selected endpoint doesn't exist in the system, show it in the menu as missing but still selected.
        // The MIDI Manager will auto-reconnect to it if it reappears in the system in this condition.
        if midiOutMenuSelectedID != 0,
           !sortedEndpoints.contains(whereUniqueID: midiOutMenuSelectedID)
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
    private func midiOutMenuItemSelected(_ sender: NSMenuItem?) {
        midiOutMenuSelectedID = MIDIIdentifier(exactly: sender?.tag ?? 0) ?? 0
        
        if let foundInput = midiManager.endpoints.inputs.first(where: {
            $0.uniqueID == midiOutMenuSelectedID
        }) {
            midiOutMenuSelectedDisplayName = foundInput.displayName
        }
        
        midiOutMenuRefresh()
        midiOutMenuUpdateConnection()
    }
    
    private func midiOutMenuUpdateConnection() {
        guard let midiOutputConnection = midiOutputConnection else { return }
        
        if midiOutMenuSelectedID == 0 {
            midiOutputConnection.removeAllInputs()
        } else {
            if midiOutputConnection.inputsCriteria != [.uniqueID(midiOutMenuSelectedID)] {
                midiOutputConnection.removeAllInputs()
                midiOutputConnection.add(inputs: [.uniqueID(midiOutMenuSelectedID)])
            }
        }
    }
}

// MARK: - Test MIDI Event Send

extension AppDelegate {
    @IBAction
    func sendNoteOn(_ sender: Any) {
        try? midiOutputConnection?.send(
            event: .noteOn(
                60,
                velocity: .midi1(127),
                channel: 0
            )
        )
    }
    
    @IBAction
    func sendNoteOff(_ sender: Any) {
        try? midiOutputConnection?.send(
            event: .noteOff(
                60,
                velocity: .midi1(0),
                channel: 0
            )
        )
    }
    
    @IBAction
    func sendCC1(_ sender: Any) {
        try? midiOutputConnection?.send(
            event: .cc(
                1,
                value: .midi1(64),
                channel: 0
            )
        )
    }
}
