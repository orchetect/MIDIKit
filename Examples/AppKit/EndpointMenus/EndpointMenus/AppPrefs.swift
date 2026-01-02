//
//  AppPrefs.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import MIDIKitIO

public final class AppPrefs: Sendable {
    public var suite: UserDefaults { .standard }
    
    public var midiInID: MIDIIdentifier {
        get { MIDIIdentifier(exactly: suite.integer(forKey: Key.midiInID)) ?? .invalidMIDIIdentifier }
        set { suite.set(newValue, forKey: Key.midiInID) }
    }
    
    public var midiInDisplayName: String {
        get { suite.string(forKey: Key.midiInDisplayName) ?? "" }
        set { suite.set(newValue, forKey: Key.midiInDisplayName) }
    }
    
    public var midiOutID: MIDIIdentifier {
        get { MIDIIdentifier(exactly: suite.integer(forKey: Key.midiOutID)) ?? .invalidMIDIIdentifier }
        set { suite.set(newValue, forKey: Key.midiOutID) }
    }

    public var midiOutDisplayName: String {
        get { suite.string(forKey: Key.midiOutDisplayName) ?? "" }
        set { suite.set(newValue, forKey: Key.midiOutDisplayName)  }
    }
}

extension AppPrefs {
    public enum Key {
        public static let midiInID = "SelectedMIDIInID"
        public static let midiInDisplayName = "SelectedMIDIInDisplayName"
        
        public static let midiOutID = "SelectedMIDIOutID"
        public static let midiOutDisplayName = "SelectedMIDIOutDisplayName"
    }
}
