//
//  MIDIOSStatus.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

@_implementationOnly import CoreMIDI

/// An enumeration representing `CoreMIDI.MIDIServices` `OSStatus` error codes, with verbose
/// descriptions.
public enum MIDIOSStatus: Hashable {
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
    /// - not starting the MIDI client after instancing it (``MIDIManager/start()``),
    /// - an uninitialized variable being passed,
    /// - or if the MIDI server has an issue getting a process ID back internally.
    case internalError
    
    /// Other `OSStatus`
    case other(CoreMIDIOSStatus)
}

extension MIDIOSStatus {
    /// Returns the corresponding Core MIDI `OSStatus` raw value.
    ///
    /// Core MIDI headers note: "These are the OSStatus error constants that are unique to Core
    /// MIDI. Note that Core MIDI functions may return other codes that are not listed here."
    public var rawValue: CoreMIDIOSStatus {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .invalidClient      : return kMIDIInvalidClient     // -10830
        case .invalidPort        : return kMIDIInvalidPort       // -10831
        case .wrongEndpointType  : return kMIDIWrongEndpointType // -10832
        case .noConnection       : return kMIDINoConnection      // -10833
        case .unknownEndpoint    : return kMIDIUnknownEndpoint   // -10834
        case .unknownProperty    : return kMIDIUnknownProperty   // -10835
        case .wrongPropertyType  : return kMIDIWrongPropertyType // -10836
        case .noCurrentSetup     : return kMIDINoCurrentSetup    // -10837
        case .messageSendErr     : return kMIDIMessageSendErr    // -10838
        case .serverStartErr     : return kMIDIServerStartErr    // -10839
        case .setupFormatErr     : return kMIDISetupFormatErr    // -10840
        case .wrongThread        : return kMIDIWrongThread       // -10841
        case .objectNotFound     : return kMIDIObjectNotFound    // -10842
        case .idNotUnique        : return kMIDIIDNotUnique       // -10843
        case .notPermitted       : return kMIDINotPermitted      // -10844
        case .unknownError       : return kMIDIUnknownError      // -10845
        case .ioError            : return 7 // no Core MIDI constant exists
        case .internalError      : return -50 // no Core MIDI constant exists
        case let .other(val)     : return val
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

extension MIDIOSStatus: CustomStringConvertible {
    public var localizedDescription: String {
        description
    }
    
    public var description: String {
        switch self {
        case .invalidClient:
            return "An invalid MIDIClientRef was passed. (kMIDIInvalidClient)"
    
        case .invalidPort:
            return "An invalid MIDIPortRef was passed. (kMIDIInvalidPort)"
    
        case .wrongEndpointType:
            return "A source endpoint was passed to a function expecting a destination, or vice versa. (kMIDIWrongEndpointType)"
    
        case .noConnection:
            return "Attempt to close a non-existent connection. (kMIDINoConnection)"
    
        case .unknownEndpoint:
            return "An invalid MIDIEndpointRef was passed. (kMIDIUnknownEndpoint)"
    
        case .unknownProperty:
            return "Attempt to query a property not set on the object. (kMIDIUnknownProperty)"
    
        case .wrongPropertyType:
            return "Attempt to set a property with a value not of the correct type. (kMIDIWrongPropertyType)"
    
        case .noCurrentSetup:
            return "Internal error; there is no current MIDI setup object. (kMIDINoCurrentSetup)"
    
        case .messageSendErr:
            return "Communication with MIDIServer failed. (kMIDIMessageSendErr)"
    
        case .serverStartErr:
            return "Unable to start MIDIServer. (kMIDIServerStartErr)"
    
        case .setupFormatErr:
            return "Unable to read the saved state. (kMIDISetupFormatErr)"
    
        case .wrongThread:
            return "A driver is calling a non-I/O function in the server from a thread other than the server's main thread. (kMIDIWrongThread)"
    
        case .objectNotFound:
            return "The requested object does not exist. (kMIDIObjectNotFound)"
    
        case .idNotUnique:
            return "Attempt to set a non-unique kMIDIPropertyUniqueID on an object. (kMIDIIDNotUnique)"
    
        case .notPermitted:
            return "The process does not have privileges for the requested operation. (kMIDINotPermitted)"
    
        case .unknownError:
            return "Internal error; unable to perform the requested operation. (kMIDIUnknownError)"
    
        case .ioError:
            return "I/O Error. (kMIDIMsgIOError)"
    
        case .internalError:
            return "Internal OSStatus error -50."
    
        case let .other(osStatus):
            return "Unknown OSStatus error: \(osStatus)"
        }
    }
}

/// Throws an error of type ``MIDIIOError/osStatus(_:)`` if `OSStatus` return value is != `noErr`
internal func throwIfErr(_ closure: () -> OSStatus) throws {
    let result = closure()
    
    guard result == noErr else {
        throw MIDIIOError.osStatus(result)
    }
}

extension CoreMIDIOSStatus /* aka Int32 */ {
    /// Throws an error of type ``MIDIIOError/osStatus(_:)`` if self as `OSStatus` is != `noErr`
    public func throwIfOSStatusErr() throws {
        guard self == noErr else {
            throw MIDIIOError.osStatus(self)
        }
    }
}

#endif
