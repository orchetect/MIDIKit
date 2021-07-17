//
//  Surface.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
@_implementationOnly import OTCore

extension MIDI.HUI {
    
    /// A class representing a single HUI control surface device.
    public class Surface {
        
        // MARK: - State
        
        public internal(set) var state: State
        
        // MARK: - Handlers
        
        /// Parser event handler that triggers when HUI events are received.
        private var eventHandler: ((Event) -> Void)? = nil
        
        /// Called when a HUI MIDI message needs transmitting.
        internal var midiEventSendHandler: ((_ midiMessage: [MIDI.Byte]) -> Void)? = nil
        
        /// Set the handler used when a HUI MIDI message needs transmitting.
        public func setMIDIEventSendHandler(
            _ handler: ((_ midiMessage: [MIDI.Byte]) -> Void)?
        ) {
            
            midiEventSendHandler = handler
            
        }
        
        // MARK: - Parser
        
        internal var parser: Parser
        
        // MARK: - init
        
        public init(
            eventHandler: ((Event) -> Void)? = nil,
            midiEventSendHandler: ((_ midiMessage: [MIDI.Byte]) -> Void)? = nil
        ) {
            
            self.eventHandler = eventHandler
            self.midiEventSendHandler = midiEventSendHandler
            
            state = State()
            
            parser = Parser()
            
            parser.setEventHandler { event in
                if event == .pingReceived {
                    midiEventSendHandler?(MIDI.HUI.kMIDI.kPingReplyToHostMessage)
                } else {
                    if let surfaceEvent = self.state.updateState(receivedEvent: event) {
                        self.eventHandler?(surfaceEvent)
                    }
                }
            }
            
        }
        
        // MARK: - Methods
        
        /// Incoming MIDI messages
        public func midiIn(data: [MIDI.Byte]) {
            
            parser.midiIn(data: data)
            
        }
        
        /// Resets state back to init state. Handlers are unaffected.
        public func reset() {
            
            state = State()
            parser.reset()
            
        }
        
    }
    
}
