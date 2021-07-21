//
//  Surface.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import OTCore

extension MIDI.HUI {
    
    /// Object representing a single HUI control surface device.
    public class Surface {
        
        // MARK: - State
        
        public internal(set) var state: State
        {
            willSet {
                if #available(macOS 10.15, macCatalyst 13, iOS 13, *) {
                    objectWillChange.send()
                }
            }
        }
        
        // MARK: - Parser
        
        internal var parser: Parser
        
        // MARK: - Handlers
        
        /// Parser event handler that triggers when HUI events are received.
        private var eventHandler: ((Event) -> Void)? = nil
        
        /// Set the handler used when HUI events are received.
        public func setEventHandler(
            _ handler: ((Event) -> Void)?
        ) {
            
            self.eventHandler = handler
            
        }
        
        /// Called when a HUI MIDI message needs transmitting.
        internal var midiEventSendHandler: ((_ event: MIDI.Event) -> Void)? = nil
        
        /// Set the handler used when a HUI MIDI message needs transmitting.
        public func setMIDIEventSendHandler(
            _ handler: ((_ event: MIDI.Event) -> Void)?
        ) {
            
            self.midiEventSendHandler = handler
            
        }
        
        // MARK: - init
        
        public init(
            eventHandler: ((Event) -> Void)? = nil,
            midiEventSendHandler: ((_ event: MIDI.Event) -> Void)? = nil
        ) {
            
            self.eventHandler = eventHandler
            self.midiEventSendHandler = midiEventSendHandler
            
            state = State()
            
            parser = Parser()
            
            parser.setEventHandler { [weak self] event in
                switch event {
                case .pingReceived:
                    self?.transmitPing()
                    
                default:
                    if let surfaceEvent = self?.state.updateState(receivedEvent: event) {
                        self?.eventHandler?(surfaceEvent)
                    }
                }
            }
            
            // HUI control surfaces send a System Reset message when they are powered on
            transmitSystemReset()
            
        }
        
        deinit {
            // HUI control surfaces send a System Reset message when they are powered off
            transmitSystemReset()
        }
        
        // MARK: - Methods
        
        /// Process incoming MIDI messages.
        public func midiIn(event: MIDI.Event) {
            
            parser.midiIn(event: event)
            
        }
        
        /// Process incoming MIDI messages.
        public func midiIn(events: [MIDI.Event]) {
            
            parser.midiIn(events: events)
            
        }
        
        /// Resets state back to init state. Handlers are unaffected.
        public func reset() {
            
            state = State()
            parser.reset()
            
        }
        
    }
    
}

#if canImport(Combine)
import Combine

@available(macOS 10.15, macCatalyst 13, iOS 13, *)
extension MIDI.HUI.Surface: ObservableObject {
    // nothing here; just add ObservableObject conformance
}
#endif
