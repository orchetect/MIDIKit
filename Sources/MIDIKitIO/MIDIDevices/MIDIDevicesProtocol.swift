//
//  MIDIDevicesProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

public protocol MIDIDevicesProtocol where Self: Equatable, Self: Hashable, Self: Sendable {
    /// List of MIDI devices in the system.
    ///
    /// A device can contain zero or more entities, and an entity can contain zero or more inputs
    /// and output endpoints.
    var devices: [MIDIDevice] { get }
    
    /// Manually update the locally cached contents from the system.
    /// This method does not need to be manually invoked, as it is handled internally when MIDI
    /// system endpoints change.
    mutating func updateCachedProperties()
}

extension MIDIDevicesProtocol /* : Equatable */ {
    public static func == (lhs: Self, rhs: some MIDIDevicesProtocol) -> Bool {
        lhs.devices == rhs.devices
    }
}

extension MIDIDevicesProtocol /* : Hashable */ {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(devices)
    }
}

extension MIDIDevicesProtocol {
    /// Returns a dictionary keyed by device with value of an array containing all the input
    /// endpoints for the device. (Convenience)
    ///
    /// A device can contain zero or more entities, and an entity can contain zero or more inputs
    /// and output endpoints.
    public var inputs: [MIDIDevice: [MIDIInputEndpoint]] {
        devices.reduce(into: [:]) { dict, device in
            dict[device] = device.entities.flatMap { $0.inputs }
        }
    }
    
    /// Returns a dictionary keyed by device with value of an array containing all the output
    /// endpoints for the device. (Convenience)
    ///
    /// A device can contain zero or more entities, and an entity can contain zero or more inputs
    /// and output endpoints.
    public var outputs: [MIDIDevice: [MIDIOutputEndpoint]] {
        devices.reduce(into: [:]) { dict, device in
            dict[device] = device.entities.flatMap { $0.outputs }
        }
    }
}

#endif
