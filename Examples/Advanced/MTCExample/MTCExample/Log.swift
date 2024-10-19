//
//  Log.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation
import os.log

let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.orchetect.MIDIKit", category: "General")

func logErrors(_ closure: (() throws -> Void)) {
    do {
        try closure()
    } catch {
        logger.error("\(error.localizedDescription)")
    }
}
