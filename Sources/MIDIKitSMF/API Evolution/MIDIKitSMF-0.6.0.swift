//
//  MIDIKitSMF-0.6.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import Foundation

// Symbols that were renamed or removed.

// NOTE: This is not by any means exhaustive, as nearly every symbol had namespace changes from 0.5.x -> 0.6.0 but the most common symbols are covered here to help guide code migration.

extension MIDIFileEvent {
    // concrete types
    
    @available(*, unavailable, renamed: "SysEx7")
    public typealias SysEx = SysEx7
    
    @available(*, unavailable, renamed: "UniversalSysEx7")
    public typealias UniversalSysEx = UniversalSysEx7
    
    // cases
    
    @available(*, unavailable, renamed: "sysEx7(delta:event:)")
    public static func sysEx(
        delta: DeltaTime,
        event: SysEx7
    ) -> Self { fatalError() }
    
    @available(*, unavailable, renamed: "universalSysEx7(delta:event:)")
    public static func universalSysEx(
        delta: DeltaTime,
        event: UniversalSysEx7
    ) -> Self { fatalError() }
    
    // static constructors
    
    @available(*, unavailable, renamed: "sysEx7(delta:manufacturer:data:)")
    public static func sysEx(
        delta: DeltaTime = .none,
        manufacturer: MIDIEvent.SysExManufacturer,
        data: [UInt8]
    ) -> Self { fatalError() }
    
    @available(
        *,
        unavailable,
        renamed: "universalSysEx7(delta:universalType:deviceID:subID1:subID2:data:)"
    )
    public static func universalSysEx(
        delta: DeltaTime = .none,
        universalType: MIDIEvent.UniversalSysExType,
        deviceID: UInt7,
        subID1: UInt7,
        subID2: UInt7,
        data: [UInt8]
    ) -> Self { fatalError() }
}

extension MIDIFileEventType {
    @available(*, unavailable, renamed: "sysEx7")
    public static let sysEx: Self = .sysEx7
    
    @available(*, unavailable, renamed: "universalSysEx7")
    public static let universalSysEx: Self = .universalSysEx7
}
