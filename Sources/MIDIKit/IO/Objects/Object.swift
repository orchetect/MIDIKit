//
//  Object.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import CoreMIDI

// MARK: - MIDIIOObjectProtocol (aka MIDI.IO.Object)

public protocol MIDIIOObjectProtocol: Hashable {
    
}

extension MIDI.IO {
    
    public typealias Object = MIDIIOObjectProtocol
    
}

