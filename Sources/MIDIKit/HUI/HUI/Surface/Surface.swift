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
        
        public typealias HUIEventHandler = ((Event) -> Void)
        
        /// Parser event handler that triggers when HUI events are received.
        public var huiEventHandler: HUIEventHandler? = nil
        
        /// Called when a HUI MIDI message needs transmitting.
        public var midiOutHandler: MIDIOutHandler? = nil
        
        
        // MARK: - init
        
        public init(
            huiEventHandler: HUIEventHandler? = nil,
            midiOutHandler: MIDIOutHandler? = nil
        ) {
            
            self.huiEventHandler = huiEventHandler
            self.midiOutHandler = midiOutHandler
            
            state = State()
            
            parser = Parser()
            
            parser.huiEventHandler = { [weak self] event in
                switch event {
                case .pingReceived:
                    self?.transmitPing()
                    
                default:
                    if let surfaceEvent = self?.state.updateState(receivedEvent: event) {
                        self?.huiEventHandler?(surfaceEvent)
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
        
        /// Resets state back to init state. Handlers are unaffected.
        public func reset() {
            
            state = State()
            parser.reset()
            
        }
        
    }
    
}

extension MIDI.HUI.Surface: ReceivesMIDIEvents {
    
    public func midiIn(event: MIDI.Event) {
        
        parser.midiIn(event: event)
        
    }
    
}

extension MIDI.HUI.Surface: SendsMIDIEvents {
    
}

#if canImport(Combine)
import Combine

@available(macOS 10.15, macCatalyst 13, iOS 13, *)
extension MIDI.HUI.Surface: ObservableObject {
    // nothing here; just add ObservableObject conformance
}
#endif
