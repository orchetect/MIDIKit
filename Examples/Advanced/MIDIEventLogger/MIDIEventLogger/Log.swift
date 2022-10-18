//
//  Log.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import OTCore

let logger = OSLogger {
    $0.defaultTemplate = .withEmoji()
}

func logIfThrowsError(_ closure: (() throws -> Void)) {
    do {
        try closure()
    } catch {
        logger.error(error)
    }
}
