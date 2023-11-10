//
//  MIDIDevices.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

#if canImport(Combine)
import Combine
#endif

public protocol MIDIDevicesProtocol where Self: Equatable, Self: Hashable {
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

/// Manages system MIDI devices information cache.
///
/// Do not instance this class directly. Instead, access the ``MIDIManager/devices`` property of
/// your central ``MIDIManager`` instance.
public final class MIDIDevices: NSObject, MIDIDevicesProtocol {
    public internal(set) dynamic var devices: [MIDIDevice] = []
    
    override init() {
        super.init()
    }
    
    /// Manually update the locally cached contents from the system.
    ///
    /// It is not necessary to call this method as the ``MIDIManager`` will automate updating device
    /// cache.
    public func updateCachedProperties() {
        devices = getSystemDevices()
    }
}

#if canImport(Combine)

/// Manages system MIDI devices information cache.
/// Class and properties are published for use in SwiftUI and Combine.
///
/// Do not instance this class directly. Instead, access the ``MIDIManager/devices`` property of
/// your central ``MIDIManager`` instance.
@available(macOS 10.15, macCatalyst 13, iOS 13, /* tvOS 13, watchOS 6, */ *)
public final class MIDIObservableDevices: NSObject, ObservableObject, MIDIDevicesProtocol {
    @Published public internal(set) dynamic var devices: [MIDIDevice] = []
    
    override internal init() {
        super.init()
    }
    
    /// Manually update the locally cached contents from the system.
    ///
    /// It is not necessary to call this method as the ``MIDIManager`` will automate updating device
    /// cache.
    public func updateCachedProperties() {
        objectWillChange.send()
        devices = getSystemDevices()
    }
}
#endif

#endif
