//
//  Log.swift
//  MIDIEventLogger
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import OTCore

let logger = OSLogger {
    $0.defaultTemplate = .withEmoji()
}

func logErrors(_ closure: (() throws -> Void)) {
    
    do {
        try closure()
    } catch {
        logger.error(error)
    }
    
}
