//
//  AdvancedMIDI2Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Wrapper for MIDI 2.0 event parser that adds certain heuristics, including RPN/NRPN bundling.
public class AdvancedMIDI2Parser {
    // MARK: - Options
    
    public var bundleRPNAndNRPNDataEntryLSB: Bool = false
    public var handleEvents: (_ events: [MIDIEvent]) -> Void
    
    // MARK: - Internal State
    
    private let parser = MIDI2Parser()
    private var pnBundler: PNBundler!
    
    public init(
        handleEvents: @escaping (_ events: [MIDIEvent]) -> Void
    ) {
        self.handleEvents = handleEvents
        
        pnBundler = PNBundler { events in
            handleEvents(events)
        }
    }
}

// MARK: - Public Methods

extension AdvancedMIDI2Parser {
    public func parseEvents(
        in packetData: UniversalMIDIPacketData
    ) {
        parseEvents(in: packetData.bytes)
    }
    
    public func parseEvents(
        in bytes: [UInt8]
    ) {
        var events = parser.parsedEvents(in: bytes)
        process(parsedEvents: &events)
    }
}

// MARK: - Internal Methods

extension AdvancedMIDI2Parser {
    // This method is broken out to make unit testing easier.
    func process(parsedEvents events: inout [MIDIEvent]) {
        var events = events
        
        if bundleRPNAndNRPNDataEntryLSB {
            pnBundler.process(events: &events)
        }
        
        handleEvents(events)
    }
}

#endif
