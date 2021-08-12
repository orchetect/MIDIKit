//
//  logErrors.swift
//  MIDIEventLogger
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import OTCore

func logErrors(_ closure: (() throws -> Void)) {
    
    do {
        try closure()
    } catch {
        Log.error(error)
    }
    
}

