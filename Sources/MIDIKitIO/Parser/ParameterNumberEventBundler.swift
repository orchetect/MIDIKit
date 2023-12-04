//
//  ParameterNumberEventBundler.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// RPN/NRPN bundling.
public class ParameterNumberEventBundler {
    // MARK: - Options
    
    public var bundleRPNAndNRPNDataEntryLSB: Bool = false
    public var handleEvents: (_ events: [MIDIEvent]) -> Void
    
    // MARK: - Internal State
    
    private let parser = MIDI2Parser()
    private var rpnHolder: EventHolder<MIDIEvent.RPN>!
    private var nrpnHolder: EventHolder<MIDIEvent.NRPN>!
    
    public init(
        handleEvents: @escaping (_ events: [MIDIEvent]) -> Void
    ) {
        self.handleEvents = handleEvents
        
        rpnHolder = EventHolder(
            storedEventWrapper: { event in
                .rpn(event)
            },
            timerExpired: { [weak self] storedEvent in
                self?.handleEvents([storedEvent])
            }
        )
        
        nrpnHolder = EventHolder(
            storedEventWrapper: { event in
                .nrpn(event)
            },
            timerExpired: { [weak self] storedEvent in
                self?.handleEvents([storedEvent])
            }
        )
    }
}

// MARK: - Public Methods

extension ParameterNumberEventBundler {
    public func process(events: inout [MIDIEvent]) {
        var newEvents: [MIDIEvent] = []
        var indicesToRemove: [Int] = []
        
        for index in events.indices {
            let processed = processPN(in: events[index])
            
            switch processed.eventResult {
            case .noChange: break
            case .remove: indicesToRemove.append(index)
            case let .replace(newEvent): events[index] = newEvent
            }
            
            newEvents.append(contentsOf: processed.newEvents)
        }
        indicesToRemove.sorted().reversed().forEach { events.remove(at: $0) }
        events.insert(contentsOf: newEvents, at: 0)
    }
}

// MARK: - Internal Methods

extension ParameterNumberEventBundler {
    enum ProcessResult {
        case noChange
        case remove
        case replace(MIDIEvent)
    }
    
    private func processPN(in event: MIDIEvent) -> (eventResult: ProcessResult, newEvents: [MIDIEvent]) {
        var eventResult: ProcessResult = .noChange
        var newEvents: [MIDIEvent] = []
        
        if case let .rpn(event) = event {
            let processed = processPN(event: event, holder: rpnHolder)
            eventResult = processed.eventResult
            newEvents.append(contentsOf: processed.newEvents)
        } else {
            if let storedEvent = rpnHolder.returnStoredAndReset() {
                newEvents.append(.rpn(storedEvent))
            }
        }
        
        if case let .nrpn(event) = event {
            let processed = processPN(event: event, holder: nrpnHolder)
            eventResult = processed.eventResult
            newEvents.append(contentsOf: processed.newEvents)
        } else {
            if let storedEvent = nrpnHolder.returnStoredAndReset() {
                newEvents.append(.nrpn(storedEvent))
            }
        }
        
        return (eventResult, newEvents)
    }
    
    private func processPN<T>(
        event: T, 
        holder: EventHolder<T>
    ) -> (eventResult: ProcessResult, newEvents: [MIDIEvent]) {
        // could be 1st UMP in a two UMP packet series where first packet has data entry LSB of 0,
        // or could be single UMP with data entry LSB of 0
        let currentEventHasDataEntryLSB0 = event.parameter.dataEntryBytes.lsb ?? 0 == 0
        
        if let storedEvent = holder.storedEvent {
            holder.reset() // drop stored event
            
            if currentEventHasDataEntryLSB0 {
                // we can only assume that the stored event was 'complete' with a 0 Data Entry LSB.
                // it doesn't mater if the param/LSB match;
                // they could be consecutive PN messages each with a Data Entry LSB of 0.
                return (eventResult: .noChange, newEvents: [holder.storedEventWrapper(storedEvent)])
            } else {
                // could be either the 2nd UMP of a two UMP packet series,
                // or could be its own fully contained PN UMP
                
                let paramAndDataEntryLSBMatch =
                    event.parameter.parameterBytes == storedEvent.parameter.parameterBytes &&
                    event.parameter.dataEntryBytes.msb == storedEvent.parameter.dataEntryBytes.msb
                
                if paramAndDataEntryLSBMatch {
                    // looks like stored event is a packet #1 in a two UMP packet series
                    return (eventResult: .noChange, newEvents: []) // keep only new event
                } else {
                    // looks like stored event is unrelated, so add it
                    return (eventResult: .noChange, newEvents: [holder.storedEventWrapper(storedEvent)])
                }
            }
        } else {
            if currentEventHasDataEntryLSB0 {
                // PN UMP packet with Data Entry MSB, but 0 LSB.
                // could be complete, or could be first of 2 UMP packets.
                // store it and start the timer
                holder.storedEvent = event
                holder.restartTimer()
                return (eventResult: .remove, newEvents: [])
            } else {
                // fully complete PN UMP packet, pass through as-is
                return (eventResult: .noChange, newEvents: [])
            }
        }
    }
}

#endif
