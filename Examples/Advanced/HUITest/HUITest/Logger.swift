//
//  Logger.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import os.log

enum Logger {
    /// Prints a message to the console log. (`os_log`). Only outputs to log in a `DEBUG` build.
    static func debug(_ message: String) {
        #if DEBUG
        os_log(
            "%{public}@",
            log: OSLog.default,
            type: .debug,
            message
        )
        #endif
    }
}
