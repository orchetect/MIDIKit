//
//  SysExID.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDIEvent {
    public enum SysExID: Hashable, Equatable {
        case manufacturer(SysExManufacturer)
        case universal(UniversalSysExType)
    }
}

extension MIDIEvent.SysExID: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .universal(universalType):
            return "universal(\(universalType))"
            
        case let .manufacturer(mfr):
            return "manufacturer(\(mfr))"
        }
    }
}

extension MIDIEvent.SysExID {
    public init?(sysEx7RawBytes: [Byte]) {
        if let mfr = MIDIEvent.SysExManufacturer(sysEx7RawBytes: sysEx7RawBytes) {
            self = .manufacturer(mfr)
            return
        }
        
        if sysEx7RawBytes.count == 1,
           let ustype = MIDIEvent.UniversalSysExType(rawUInt8Value: sysEx7RawBytes[0])
        {
            self = .universal(ustype)
            return
        }
        
        return nil
    }
    
    public init?(sysEx8RawBytes: [Byte]) {
        if let mfr = MIDIEvent.SysExManufacturer(sysEx8RawBytes: sysEx8RawBytes) {
            self = .manufacturer(mfr)
            return
        }
        
        if sysEx8RawBytes.count == 2,
           sysEx8RawBytes[0] == 0x00,
           let ustype = MIDIEvent.UniversalSysExType(rawUInt8Value: sysEx8RawBytes[1])
        {
            self = .universal(ustype)
            return
        }
        
        return nil
    }
}

extension MIDIEvent.SysExID {
    /// Returns the Manufacturer byte(s) formatted for MIDI 1.0 SysEx7, as one byte (7-bit) or three bytes (21-bit).
    @inline(__always)
    public func sysEx7RawBytes() -> [Byte] {
        switch self {
        case let .manufacturer(mfr):
            return mfr.sysEx7RawBytes()
            
        case let .universal(uSysEx):
            return [uSysEx.rawValue.uInt8Value]
        }
    }
    
    /// Returns the Manufacturer byte(s) formatted for MIDI 2.0 SysEx8, as two bytes (16-bit).
    @inline(__always)
    public func sysEx8RawBytes() -> [Byte] {
        switch self {
        case let .manufacturer(mfr):
            return mfr.sysEx8RawBytes()
            
        case let .universal(uSysEx):
            return [0x00, uSysEx.rawValue.uInt8Value]
        }
    }
}
