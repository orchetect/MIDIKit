//
//  HUI Types.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

/// Raw HUI zone byte.
public typealias HUIZone = UInt8

/// Raw HUI port nibble.
public typealias HUIPort = UInt4

/// Raw HUI zone and port pair.
public typealias HUIZoneAndPort = (zone: HUIZone, port: HUIPort)
