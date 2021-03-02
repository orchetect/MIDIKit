//
//  MTC Generator.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2020-11-25.
//

import Dispatch
import TimecodeKit

// NOTE!!
// generator can take `Timecode` as an input.
// the generator should wait until the NEXT even frame number to start generating, in order to establish a reliable origin absolute time.
// I am almost certain this is how Pro Tools works when it transmits timecode.
// you CAN'T start transmitting MTC immediately from the first timecode the generator is given.
//

extension MTC {
	
	/// Encapsulates MTC generation
	public class Generator {
		
		// MARK: - Public properties
		
		/// The base MTC frame rate last transmitted
		public internal(set) var mtcFrameRate: MTCFrameRate? = nil
		
		
		// MARK: - Stored closures
		
		/// Closure called every time a MIDI message needs to be transmitted by the generator
		internal var midiEventSendHandler: ((_ messageBytes: [Byte]) -> Void)? = nil
		
		/// Sets the closure called every time a MIDI message needs to be transmitted by the generator
		public func setMIDIEventSendHandler(_ handler: ((_ messageBytes: [Byte]) -> Void)?) {
			
			midiEventSendHandler = handler
			
		}
		
		// MARK: - Internal properties
		
		internal var timer: SafeDispatchTimer
		
		
		// MARK: - init
		
		public init(midiEventSendHandler: ((_ messageBytes: [Byte]) -> Void)? = nil) {
			
			self.midiEventSendHandler = midiEventSendHandler
			
			timer = SafeDispatchTimer(frequencyInHz: 1.0,
									  queue: DispatchQueue.main,
									  eventHandler: { })
			
		}
		
		
		// MARK: - Public methods
		
		/// Locate to a new timecode, while not generating continuous playback MIDI message stream.
		/// Sends a MTC full-frame message.
		public func locate(to timecode: Timecode) {
			
		}
		
		/// Starts generating MTC continuous playback MIDI message stream events.
		///
		/// - note: It is not necessary to send a `locate(to:)` message prior,
		/// and is actually undesirable as it can confuse the receiving entity.
		///
		/// Call `stop()` to stop generating events.
		public func start(at timecode: Timecode) {
			
		}
		
		/// Stops generating MTC continuous playback MIDI message stream events.
		public func stop() {
			
		}
		
	}
	
}
