//
//  UniversalSysExType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent {
    /// Universal System Exclusive message type.
    public enum UniversalSysExType: UInt7, Equatable, Hashable {
        /// Real-Time System Exclusive ID number (`0x7F`).
        case realTime = 0x7F
    
        /// Non- Real-Time System Exclusive ID number (`0x7E`).
        case nonRealTime = 0x7E
    
        // Note: this cannot be implemented as `init?(rawValue: UInt8)` because
        // Xcode 12.4 won't compile (Xcode 13 compiles fine however).
        // It seems the parameter name "rawValue:" confuses the compiler
        // and prevents it from synthesizing its own `init?(rawValue: UInt7)` init.
        /// Universal System Exclusive message type.
        ///
        /// Initialize from raw UInt8 byte.
        public init?(rawUInt8Value: UInt8) {
            guard let uInt7 = UInt7(exactly: rawUInt8Value) else { return nil }
    
            self.init(rawValue: uInt7)
        }
    }
}

extension MIDIEvent.UniversalSysExType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .realTime: return "realTime"
        case .nonRealTime: return "nonRealTime"
        }
    }
}

extension MIDIEvent {
    /// SysEx: Device Inquiry request message.
    ///
    /// When a device receives a Device Inquiry request message that matches its device ID or uses
    /// the device ID of `0x7F` (meaning "all devices"), it should respond with a Device Inquiry
    /// response message (``deviceInquiryResponse(deviceID:manufacturer:deviceFamilyCode:deviceFamilyMemberCode:softwareRevision:)``).
    ///
    /// - Parameter deviceID: SysEx Device ID. An ID of 0x7F indicates "all devices".
    /// - Returns: SysEx7 Message.
    public static func deviceInquiryRequest(deviceID: UInt7) -> Self {
        // guaranteed to work because errors are only thrown on invalid data bytes,
        // and bytes are empty here
        try! .universalSysEx7(
            universalType: .nonRealTime,
            deviceID: deviceID,
            subID1: 0x06, // General Information
            subID2: 0x01, // Identity Request
            data: []
        )
    }
    
    /// SysEx: Device Inquiry response message.
    ///
    /// When a device receives a Device Inquiry request message
    /// (``deviceInquiryRequest(deviceID:)``) that matches its device ID or uses the device ID of
    /// `0x7F` (meaning "all devices"), it should respond with a Device Inquiry response message.
    ///
    /// - Parameters:
    ///   - deviceID: SysEx Device ID. An ID of `0x7F` indicates "all devices".
    ///   - manufacturer: Manufacturer's System Exclusive ID code
    ///   - deviceFamilyCode: Device family code
    ///   - deviceFamilyMemberCode: Device family member code
    ///   - softwareRevision: Software revision level. Format is device-specific.
    /// - Returns: SysEx7 Message.
    public static func deviceInquiryResponse(
        deviceID: UInt7,
        manufacturer: SysExManufacturer,
        deviceFamilyCode: UInt14,
        deviceFamilyMemberCode: UInt14,
        softwareRevision: (UInt7, UInt7, UInt7, UInt7)
    ) -> Self {
        // guaranteed to work because errors are only thrown on invalid data bytes,
        // and bytes are all guaranteed 7-bit here
        try! .universalSysEx7(
            universalType: .nonRealTime,
            deviceID: deviceID,
            subID1: 0x06, // General Information
            subID2: 0x01, // Identity Reply
            data: manufacturer.sysEx7RawBytes()
                + [deviceFamilyCode.bytePair.lsb, deviceFamilyCode.bytePair.msb]
                + [deviceFamilyMemberCode.bytePair.lsb, deviceFamilyMemberCode.bytePair.msb]
                + [
                    softwareRevision.0.uInt8Value,
                    softwareRevision.1.uInt8Value,
                    softwareRevision.2.uInt8Value,
                    softwareRevision.3.uInt8Value
                ]
        )
    }
}
