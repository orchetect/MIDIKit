//
//  Logger.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import os.log

let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier ?? "com.orchetect.MIDIKit.HUITest",
    category: "General"
)
