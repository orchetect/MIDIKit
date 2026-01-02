//
//  MIDIMenusHelper.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import AppKit
import Foundation
import MIDIKitIO

/// Object responsible for managing MIDI endpoint selector menus.
final class MIDIMenusHelper: Sendable {
    nonisolated let id = UUID().uuidString
    
    nonisolated(unsafe) var midiHelper: MIDIHelper
    nonisolated(unsafe) var prefs: AppPrefs
    
    @MainActor weak var midiInMenu: NSMenu?
    @MainActor weak var midiOutMenu: NSMenu?
    
    @MainActor public init(
        midiHelper: MIDIHelper,
        prefs: AppPrefs,
        midiInMenu: NSMenu,
        midiOutMenu: NSMenu
    ) {
        self.midiHelper = midiHelper
        self.prefs = prefs
        self.midiInMenu = midiInMenu
        self.midiOutMenu = midiOutMenu
    }
    
    deinit {
        teardown()
    }
}

// MARK: - Static

extension MIDIMenusHelper {
    static let noneEndpointName = "None"
}

// MARK: - Setup

extension MIDIMenusHelper {
    @MainActor public func start() {
        // set up MIDI subsystem notification handler
        midiHelper.addNotificationSubscriber(id: id) { [weak self] notification in
            Task {
                await self?.handle(notification: notification)
            }
        }
        
        // update the menus
        midiInMenuRefresh()
        midiOutMenuRefresh()
    }
    
    nonisolated private func teardown() {
        midiHelper.removeNotificationSubscriber(id: id)
    }
}

// MARK: - MIDI I/O Notifications

extension MIDIMenusHelper {
    @MainActor private func handle(notification: MIDIIONotification) {
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

extension MIDIMenusHelper {
    @MainActor private func midiInMenuRefresh() {
        guard let midiInMenu else { return }
        
        midiInMenu.items.removeAll()
        
        let sortedEndpoints = midiHelper.midiManager.endpoints.outputs.sortedByDisplayName()
        
        // None menu item
        do {
            let newMenuItem = NSMenuItem(
                title: Self.noneEndpointName,
                action: #selector(midiInMenuItemSelected),
                keyEquivalent: ""
            )
            newMenuItem.tag = Int(MIDIIdentifier.invalidMIDIIdentifier)
            newMenuItem.state = prefs.midiInID == .invalidMIDIIdentifier ? .on : .off
            midiInMenu.addItem(newMenuItem)
        }
        
        // ---------------
        midiInMenu.addItem(.separator())
        
        // If selected endpoint doesn't exist in the system,
        // show it in the menu as missing but still selected.
        // The MIDIManager will auto-reconnect to it if it reappears
        // in the system in this condition.
        if prefs.midiInID != .invalidMIDIIdentifier,
           !sortedEndpoints.contains(
               whereUniqueID: prefs.midiInID,
               fallbackDisplayName: prefs.midiInDisplayName
           )
        {
            let newMenuItem = NSMenuItem(
                title: "⚠️ \(prefs.midiInDisplayName)",
                action: #selector(midiInMenuItemSelected),
                keyEquivalent: ""
            )
            newMenuItem.tag = Int(prefs.midiInID)
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
            if endpoint.uniqueID == prefs.midiInID {
                newMenuItem.state = .on
            }
            
            midiInMenu.addItem(newMenuItem)
        }
    }
    
    @objc @MainActor public func midiInMenuItemSelected(_ sender: NSMenuItem?) {
        prefs.midiInID = MIDIIdentifier(exactly: sender?.tag ?? 0)
            ?? .invalidMIDIIdentifier
        
        midiInUpdateMetadata()
        
        midiInMenuRefresh()
        
        midiHelper.updateInputConnection(from: prefs)
    }
    
    nonisolated private func midiInUpdateMetadata() {
        guard let foundOutput = midiHelper.midiManager.endpoints.outputs.first(
            whereUniqueID: prefs.midiInID,
            fallbackDisplayName: prefs.midiInDisplayName
        ) else { return }
        
        prefs.midiInID = foundOutput.uniqueID
        prefs.midiInDisplayName = foundOutput.displayName
    }
}

// MARK: - MIDI Out Menu

extension MIDIMenusHelper {
    @MainActor private func midiOutMenuRefresh() {
        guard let midiOutMenu else { return }
        
        midiOutMenu.items.removeAll()
        
        let sortedEndpoints = midiHelper.midiManager.endpoints.inputs.sortedByDisplayName()
        
        // None menu item
        do {
            let newMenuItem = NSMenuItem(
                title: Self.noneEndpointName,
                action: #selector(midiOutMenuItemSelected),
                keyEquivalent: ""
            )
            newMenuItem.tag = Int(MIDIIdentifier.invalidMIDIIdentifier)
            newMenuItem.state = prefs.midiOutID == .invalidMIDIIdentifier ? .on : .off
            midiOutMenu.addItem(newMenuItem)
        }
        
        // ---------------
        midiOutMenu.addItem(.separator())
        
        // If selected endpoint doesn't exist in the system,
        // show it in the menu as missing but still selected.
        // The MIDIManager will auto-reconnect to it if it reappears
        // in the system in this condition.
        if prefs.midiOutID != .invalidMIDIIdentifier,
           !sortedEndpoints.contains(
               whereUniqueID: prefs.midiOutID,
               fallbackDisplayName: prefs.midiOutDisplayName
           )
        {
            let newMenuItem = NSMenuItem(
                title: "⚠️ \(prefs.midiOutDisplayName)",
                action: #selector(midiOutMenuItemSelected),
                keyEquivalent: ""
            )
            newMenuItem.tag = Int(prefs.midiOutID)
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
            if endpoint.uniqueID == prefs.midiOutID { newMenuItem.state = .on }
            
            midiOutMenu.addItem(newMenuItem)
        }
    }
    
    @objc @MainActor public func midiOutMenuItemSelected(_ sender: NSMenuItem?) {
        prefs.midiOutID = MIDIIdentifier(exactly: sender?.tag ?? 0)
            ?? .invalidMIDIIdentifier
        
        midiOutUpdateMetadata()
        
        midiOutMenuRefresh()
        
        midiHelper.updateOutputConnection(from: prefs)
    }
    
    nonisolated private func midiOutUpdateMetadata() {
        guard let foundInput = midiHelper.midiManager.endpoints.inputs.first(
            whereUniqueID: prefs.midiOutID,
            fallbackDisplayName: prefs.midiOutDisplayName
        ) else { return }
        
        prefs.midiOutID = foundInput.uniqueID
        prefs.midiOutDisplayName = foundInput.displayName
    }
}
