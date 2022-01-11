//
//  SysExID.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation

extension MIDI.Event {
    
    public enum SysExID: Hashable, Equatable {
        
        case manufacturer(SysExManufacturer)
        case universal(UniversalSysExType)
        
    }
    
}

extension MIDI.Event.SysExID: CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        case .universal(let universalType):
            return "universal(\(universalType))"
            
        case .manufacturer(let mfr):
            return "manufacturer(\(mfr))"
        }
        
    }
    
}

extension MIDI.Event.SysExID {
    
    public init?(sysEx7RawBytes: [MIDI.Byte]) {
        
        if let mfr = MIDI.Event.SysExManufacturer(sysEx7RawBytes: sysEx7RawBytes) {
            self = .manufacturer(mfr)
            return
        }
        
        if sysEx7RawBytes.count == 1,
           let ustype = MIDI.Event.UniversalSysExType(rawUInt8Value: sysEx7RawBytes[0])
        {
            self = .universal(ustype)
            return
        }
        
        return nil
        
    }
    
    public init?(sysEx8RawBytes: [MIDI.Byte]) {
        
        if let mfr = MIDI.Event.SysExManufacturer(sysEx8RawBytes: sysEx8RawBytes) {
            self = .manufacturer(mfr)
            return
        }
        
        if sysEx8RawBytes.count == 2,
           sysEx8RawBytes[0] == 0x00,
           let ustype = MIDI.Event.UniversalSysExType(rawUInt8Value: sysEx8RawBytes[1])
        {
            self = .universal(ustype)
            return
        }
        
        return nil
        
    }
    
}
