//
//  Log.swift
//  MIDISystemInfo
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import OTCore

let logger = OSLogger(enabled: true,
                      useEmoji: .all)

func logErrors(_ closure: (() throws -> Void)) {
    
    do {
        try closure()
    } catch {
        logger.error(error)
    }
    
}

