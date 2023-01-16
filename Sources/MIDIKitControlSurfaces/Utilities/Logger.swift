//
//  Logger.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import os.log

internal enum Logger {
    /// Prints a message to the console log. (`os_log`).
    /// Only outputs to log in a debug build.
    internal static func debug(_ message: String) {
        #if DEBUG
        if #available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log(
                "%{public}@",
                log: OSLog.default,
                type: .debug,
                "HUI: " + message
            )
        } else {
            print(message)
        }
        #endif
    }
}
