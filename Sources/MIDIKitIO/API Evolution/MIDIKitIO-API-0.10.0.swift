//
//  MIDIKitIO-API-0.10.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
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

extension MIDIManager {
    @available(
        *,
        deprecated,
        message: "Notification handler now only takes 1 parameter: notification."
    )
    @_disfavoredOverload
    public convenience init(
        clientName: String,
        model: String,
        manufacturer: String,
        notificationHandler: (@Sendable (
            _ notification: MIDIIONotification,
            _ manager: MIDIManager
        ) -> Void)? = nil
    ) {
        self.init(
            clientName: clientName,
            model: model,
            manufacturer: manufacturer,
            notificationHandler: nil
        )
        self.notificationHandler = { notif in notificationHandler?(notif, self) }
    }
}

#endif
