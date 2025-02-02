//
//  MIDIOSStatus.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation
import MIDIKitCore
internal import CoreMIDI

/// An enumeration representing `CoreMIDI.MIDIServices` `OSStatus` error codes, with verbose
/// descriptions.
public enum MIDIOSStatus: LocalizedError {
    /// `CoreMIDI.kMIDIInvalidClient`:
    /// An invalid `MIDIClientRef` was passed.
    case invalidClient
    
    /// `CoreMIDI.kMIDIInvalidPort`:
    /// An invalid `MIDIPortRef` was passed.
    case invalidPort
    
    /// `CoreMIDI.kMIDIWrongEndpointType`:
    /// A source endpoint was passed to a function expecting a destination, or vice versa.
    case wrongEndpointType
    
    /// `CoreMIDI.kMIDINoConnection`:
    /// Attempt to close a non-existent connection.
    case noConnection
    
    /// `CoreMIDI.kMIDIUnknownEndpoint`:
    /// An invalid `MIDIEndpointRef` was passed.
    case unknownEndpoint
    
    /// `CoreMIDI.kMIDIUnknownProperty`:
    /// Attempt to query a property not set on the object.
    case unknownProperty
    
    /// `CoreMIDI.kMIDIWrongPropertyType`:
    /// Attempt to set a property with a value not of the correct type.
    case wrongPropertyType
    
    /// `CoreMIDI.kMIDINoCurrentSetup`:
    /// Internal error; there is no current MIDI setup object.
    case noCurrentSetup
    
    /// `CoreMIDI.kMIDIMessageSendErr`:
    /// Communication with MIDIServer failed.
    case messageSendErr
    
    /// `CoreMIDI.kMIDIServerStartErr`:
    /// Unable to start MIDIServer.
    case serverStartErr
    
    /// `CoreMIDI.kMIDISetupFormatErr`:
    /// Unable to read the saved state.
    case setupFormatErr
    
    /// `CoreMIDI.kMIDIWrongThread`:
    /// A driver is calling a non-I/O function in the server from a thread other than the server's
    /// main thread.
    case wrongThread
    
    /// `CoreMIDI.kMIDIObjectNotFound`:
    /// The requested object does not exist.
    case objectNotFound
    
    /// `CoreMIDI.kMIDIIDNotUnique`:
    /// Attempt to set a non-unique `kMIDIPropertyUniqueID` on an object.
    case idNotUnique
    
    /// `CoreMIDI.kMIDINotPermitted`:
    /// The process does not have privileges for the requested operation.
    case notPermitted
    
    /// `CoreMIDI.kMIDIUnknownError`:
    /// Internal error; unable to perform the requested operation.
    case unknownError
    
    /// `kMIDIMsgIOError`:
    /// IO Error
    case ioError
    
    /// Error -50:
    /// Various underlying issues could produce this error.
    ///
    /// Possibly caused by:
    /// - not starting the MIDI manager after instancing it (`start()` on `MIDIManager`),
    /// - an uninitialized variable being passed,
    /// - attempting to set a Core MIDI property value that is read-only,
    /// - or if the MIDI server has an issue getting a process ID back internally.
    case internalError
    
    /// Other `OSStatus`
    case other(CoreMIDIOSStatus)
}

extension MIDIOSStatus: Equatable { }

extension MIDIOSStatus: Hashable { }

extension MIDIOSStatus: Sendable { }

extension MIDIOSStatus {
    /// Returns the corresponding Core MIDI `OSStatus` raw value.
    ///
    /// Core MIDI headers note: "These are the OSStatus error constants that are unique to Core
    /// MIDI. Note that Core MIDI functions may return other codes that are not listed here."
    public var rawValue: CoreMIDIOSStatus {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .invalidClient:     kMIDIInvalidClient     // -10830
        case .invalidPort:       kMIDIInvalidPort       // -10831
        case .wrongEndpointType: kMIDIWrongEndpointType // -10832
        case .noConnection:      kMIDINoConnection      // -10833
        case .unknownEndpoint:   kMIDIUnknownEndpoint   // -10834
        case .unknownProperty:   kMIDIUnknownProperty   // -10835
        case .wrongPropertyType: kMIDIWrongPropertyType // -10836
        case .noCurrentSetup:    kMIDINoCurrentSetup    // -10837
        case .messageSendErr:    kMIDIMessageSendErr    // -10838
        case .serverStartErr:    kMIDIServerStartErr    // -10839
        case .setupFormatErr:    kMIDISetupFormatErr    // -10840
        case .wrongThread:       kMIDIWrongThread       // -10841
        case .objectNotFound:    kMIDIObjectNotFound    // -10842
        case .idNotUnique:       kMIDIIDNotUnique       // -10843
        case .notPermitted:      kMIDINotPermitted      // -10844
        case .unknownError:      kMIDIUnknownError      // -10845
        case .ioError:           7 // no Core MIDI constant exists
        case .internalError:     -50 // no Core MIDI constant exists
        case let .other(val):    val
        }
        // swiftformat:enable spacearoundoperators
    }
    
    /// Initializes from the corresponding Core MIDI `OSStatus` raw value.
    public init(rawValue: CoreMIDIOSStatus) {
        // swiftformat:disable spacearoundoperators
        switch rawValue {
        case kMIDIInvalidClient      : self = .invalidClient
        case kMIDIInvalidPort        : self = .invalidPort
        case kMIDIWrongEndpointType  : self = .wrongEndpointType
        case kMIDINoConnection       : self = .noConnection
        case kMIDIUnknownEndpoint    : self = .unknownEndpoint
        case kMIDIUnknownProperty    : self = .unknownProperty
        case kMIDIWrongPropertyType  : self = .wrongPropertyType
        case kMIDINoCurrentSetup     : self = .noCurrentSetup
        case kMIDIMessageSendErr     : self = .messageSendErr
        case kMIDIServerStartErr     : self = .serverStartErr
        case kMIDISetupFormatErr     : self = .setupFormatErr
        case kMIDIWrongThread        : self = .wrongThread
        case kMIDIObjectNotFound     : self = .objectNotFound
        case kMIDIIDNotUnique        : self = .idNotUnique
        case kMIDINotPermitted       : self = .notPermitted
        case kMIDIUnknownError       : self = .unknownError
        case 7                       : self = .ioError
        case -50                     : self = .internalError
        default                      : self = .other(rawValue)
        }
        // swiftformat:enable spacearoundoperators
    }
}

extension MIDIOSStatus {
    public var errorDescription: String? {
        switch self {
        case .invalidClient:
            "An invalid MIDIClientRef was passed. (kMIDIInvalidClient)"
    
        case .invalidPort:
            "An invalid MIDIPortRef was passed. (kMIDIInvalidPort)"
    
        case .wrongEndpointType:
            "A source endpoint was passed to a function expecting a destination, or vice versa. (kMIDIWrongEndpointType)"
    
        case .noConnection:
            "Attempt to close a non-existent connection. (kMIDINoConnection)"
    
        case .unknownEndpoint:
            "An invalid MIDIEndpointRef was passed. (kMIDIUnknownEndpoint)"
    
        case .unknownProperty:
            "Attempt to query a property not set on the object. (kMIDIUnknownProperty)"
    
        case .wrongPropertyType:
            "Attempt to set a property with a value not of the correct type. (kMIDIWrongPropertyType)"
    
        case .noCurrentSetup:
            "Internal error; there is no current MIDI setup object. (kMIDINoCurrentSetup)"
    
        case .messageSendErr:
            "Communication with MIDIServer failed. (kMIDIMessageSendErr)"
    
        case .serverStartErr:
            "Unable to start MIDIServer. (kMIDIServerStartErr)"
    
        case .setupFormatErr:
            "Unable to read the saved state. (kMIDISetupFormatErr)"
    
        case .wrongThread:
            "A driver is calling a non-I/O function in the server from a thread other than the server's main thread. (kMIDIWrongThread)"
    
        case .objectNotFound:
            "The requested object does not exist. (kMIDIObjectNotFound)"
    
        case .idNotUnique:
            "Attempt to set a non-unique kMIDIPropertyUniqueID on an object. (kMIDIIDNotUnique)"
    
        case .notPermitted:
            "The process does not have privileges for the requested operation. (kMIDINotPermitted)"
    
        case .unknownError:
            "Internal error; unable to perform the requested operation. (kMIDIUnknownError)"
    
        case .ioError:
            "I/O Error. (kMIDIMsgIOError)"
    
        case .internalError:
            "Internal OSStatus error -50."
    
        case let .other(osStatus):
            "Unknown OSStatus error: \(osStatus)"
        }
    }
}

/// Throws an error of type ``MIDIIOError/osStatus(_:)-swift.enum.case`` if `OSStatus` return value
/// `!= noErr`.
func throwIfErr(_ closure: () -> OSStatus) throws {
    let result = closure()
    
    guard result == noErr else {
        throw MIDIIOError.osStatus(result)
    }
}

extension CoreMIDIOSStatus /* aka Int32 */ {
    /// Throws an error of type ``MIDIIOError/osStatus(_:)-swift.enum.case`` if `self as OSStatus !=
    /// noErr`.
    public func throwIfOSStatusErr() throws {
        guard self == noErr else {
            throw MIDIIOError.osStatus(self)
        }
    }
}

#endif
