//
//  MIDIKitIO-API-0.10.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

extension MIDI1Parser {
    @available(
        *,
         deprecated,
         message: "Static default parser has been removed. Please instantiate a new instance and store it with an appropriate lifecycle scope instead."
    )
    static let `default` = MIDI1Parser()
}

extension MIDI2Parser {
    @available(
        *,
         deprecated,
         message: "Static default parser has been removed. Please instantiate a new instance and store it with an appropriate lifecycle scope instead."
    )
    static let `default` = MIDI2Parser()
}

#endif
