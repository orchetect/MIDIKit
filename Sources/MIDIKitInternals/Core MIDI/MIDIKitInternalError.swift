//
//  MIDIKitInternalError.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

public enum MIDIKitInternalError: Error {
    case malformed(_ verboseError: String)
}
