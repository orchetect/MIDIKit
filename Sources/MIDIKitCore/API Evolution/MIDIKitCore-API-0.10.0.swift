//
//  MIDIKitCore-API-0.10.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

// MARK: - MIDIEvent.NoteManagement

extension MIDIEvent.NoteManagement {
    @available(*, deprecated, renamed: "flags")
    public var optionFlags: Set<OptionFlag> {
        get { flags }
        set { flags = newValue }
    }
    
    @available(*, deprecated, renamed: "init(note:flags:channel:group:)")
    public init(
        note: UInt7,
        optionFlags: Set<OptionFlag> = [],
        channel: UInt4,
        group: UInt4 = 0x0
    ) {
        self.init(note: note, flags: optionFlags, channel: channel, group: group)
    }
    
    @available(*, deprecated, renamed: "init(note:flags:channel:group:)")
    public init(
        note: MIDINote,
        optionFlags: Set<OptionFlag> = [],
        channel: UInt4,
        group: UInt4 = 0x0
    ) {
        self.init(note: note, flags: optionFlags, channel: channel, group: group)
    }
}
