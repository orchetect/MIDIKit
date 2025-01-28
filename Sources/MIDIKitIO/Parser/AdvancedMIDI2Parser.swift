//
//  AdvancedMIDI2Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Wrapper for MIDI 2.0 event parser that adds certain heuristics, including RPN/NRPN bundling.
public class AdvancedMIDI2Parser {
    // MARK: - Options
    
    public var bundleRPNAndNRPNDataEntryLSB: Bool = false
    
    public typealias EventsHandler = @Sendable (
        _ events: [MIDIEvent],
        _ timeStamp: CoreMIDITimeStamp,
        _ source: MIDIOutputEndpoint?
    ) -> Void
    public var handleEvents: EventsHandler
    
    // MARK: - Internal State
    
    private let parser = MIDI2Parser()
    private var pnBundler: ParameterNumberEventBundler!
    
    public init(
        handleEvents: @escaping EventsHandler
    ) {
        self.handleEvents = handleEvents
        
        pnBundler = ParameterNumberEventBundler { events, timeStamp, source in
            handleEvents(events, timeStamp, source)
        }
    }
}

// MARK: - Public Methods

extension AdvancedMIDI2Parser {
    public func parseEvents(
        in packetData: UniversalMIDIPacketData
    ) {
        parseEvents(
            in: packetData.bytes,
            timeStamp: packetData.timeStamp,
            source: packetData.source
        )
    }
    
    public func parseEvents(
        in bytes: [UInt8],
        timeStamp: CoreMIDITimeStamp = 0,
        source: MIDIOutputEndpoint? = nil
    ) {
        var events = parser.parsedEvents(in: bytes)
        process(
            parsedEvents: &events,
            timeStamp: timeStamp,
            source: source
        )
    }
}

// MARK: - Internal Methods

extension AdvancedMIDI2Parser {
    // This method is broken out to make unit testing easier.
    func process(
        parsedEvents events: inout [MIDIEvent],
        timeStamp: CoreMIDITimeStamp = 0,
        source: MIDIOutputEndpoint? = nil
    ) {
        var events = events
        
        if bundleRPNAndNRPNDataEntryLSB {
            pnBundler.process(events: &events, timeStamp: timeStamp, source: source)
        }
        
        handleEvents(events, timeStamp, source)
    }
}

#endif
