//
//  MTC Generator.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import Foundation
import MIDIKitInternals
import TimecodeKit

extension MIDI.MTC {
	
	/// MTC sync generator.
	public class Generator {
		
		// MARK: - Public properties
		
		public private(set) var name: String
		
		/// The MTC SMPTE frame rate (24, 25, 29.97d, or 30) that was last transmitted by the generator.
		///
		/// This property should only be inspected purely for developer informational or diagnostic purposes. For production code or any logic related to MTC, it should be ignored -- only the local `timecode.frameRate` property is used for automatic selection of MTC SMPTE frame rate and scaling of outgoing timecode accordingly.
		public var mtcFrameRate: MTCFrameRate {
			
			encoder.mtcFrameRate
			
		}
		
		public private(set) var state: State = .idle
		
		/// Property updated whenever outgoing MTC timecode changes.
		public var timecode: Timecode {
			
			encoder.timecode
			
		}
		
		public var localFrameRate: Timecode.FrameRate {
			
			encoder.localFrameRate
			
		}
		
		/// Behavior determining when MTC Full-Frame MIDI messages should be generated.
		///
		/// `.ifDifferent` is recommended and suitable for most implementations.
		public var locateBehavior: MTC.Encoder.FullFrameBehavior = .ifDifferent
		
		
		// MARK: - Stored closures
		
		/// Closure called every time a MIDI message needs to be transmitted by the generator.
		///
		/// - Note: Handler is called on a dedicated thread so do not make UI updates from it.
		internal var midiEventSendHandler: ((_ midiMessage: [Byte]) -> Void)? = nil
		
		/// Sets the closure called every time a MIDI message needs to be transmitted by the generator.
		public func setMIDIEventSendHandler(
			_ handler: ((_ midiMessage: [Byte]) -> Void)?
		) {
			
			midiEventSendHandler = handler
			
		}
		
		
		// MARK: - init
		
		public init(
			name: String? = nil,
			midiEventSendHandler: ((_ midiMessage: [Byte]) -> Void)? = nil
		) {
			
			// handle init arguments
			
			let name = name ?? UUID().uuidString
			
			self.name = name
			
			self.midiEventSendHandler = midiEventSendHandler
			
			// queue
			
			queue = DispatchQueue(label: "midikit.mtcgenerator.\(name)",
								  qos: .userInteractive)
			
			timer = MIDI.SafeDispatchTimer(rate: .seconds(1.0), // default, will be changed later
										   queue: queue,
										   eventHandler: { })
			
			timer.setEventHandler { [weak self] in
				
				self?.timerFired()
				
			}
			
			setTimerRate(from: timecode.frameRate)
			
			// encoder setup
			
			encoder = Encoder()
			
			encoder.setMIDIEventSendHandler { [weak self] midiMessage in
				
				self?.midiEventSendHandler?(midiMessage)
				
			}
			
		}
		
		
		// MARK: - Queue (internal)
		
		/// Maintain a high-priority internal thread
		internal var queue: DispatchQueue
		
		
		// MARK: - Encoder (internal)
		
		internal var encoder = Encoder()
		
		
		// MARK: - Timer (internal)
		
		internal var timer: MIDI.SafeDispatchTimer
		
		/// Internal: Fired from our timer object.
		internal func timerFired() {
			
			encoder.increment()
			
		}
		
		/// Sets timer rate to corresponding MTC quarter-frame duration in Hz.
		internal func setTimerRate(from frameRate: Timecode.FrameRate) {
			
			// const values generated from:
			// TCC(f: 1).toTimecode(at: frameRate)!.realTimeValue
			
			// duration in seconds for one quarter-frame
			let rate: Double
			
			switch frameRate {
			case ._23_976:      rate = 0.010427083333333333
			case ._24:          rate = 0.010416666666666666
			case ._24_98:       rate = 0.010009999999999998
			case ._25:          rate = 0.01
			case ._29_97:       rate = 0.008341666666666666
			case ._29_97_drop:  rate = 0.008341666666666666
			case ._30:          rate = 0.008333333333333333
			case ._30_drop:     rate = 0.008341666666666666
			case ._47_952:      rate = 0.010427083333333333
			case ._48:          rate = 0.010416666666666666
			case ._50:          rate = 0.01
			case ._59_94:       rate = 0.008341666666666666
			case ._59_94_drop:  rate = 0.008341666666666666
			case ._60:          rate = 0.008333333333333333
			case ._60_drop:     rate = 0.008341666666666666
			case ._100:         rate = 0.01
			case ._119_88:      rate = 0.008341666666666666
			case ._119_88_drop: rate = 0.008341666666666666
			case ._120:         rate = 0.008333333333333333
			case ._120_drop:    rate = 0.008341666666666666
			}
			
			timer.setRate(.seconds(rate))
			
		}
		
		
		// MARK: - Public methods
		
		/// Locate to a new timecode, while not generating continuous playback MIDI message stream.
		/// Sends a MTC full-frame message.
		public func locate(to timecode: Timecode) {
			
			encoder.locate(to: timecode, transmitFullFrame: locateBehavior)
			setTimerRate(from: timecode.frameRate)
			
		}
		
		/// Locate to a new timecode, while not generating continuous playback MIDI message stream.
		/// Sends a MTC full-frame message.
		public func locate(to components: Timecode.Components) {
			
			encoder.locate(to: components, transmitFullFrame: locateBehavior)
			setTimerRate(from: timecode.frameRate)
			
		}
		
		/// Starts generating MTC continuous playback MIDI message stream events from the current time position at the current local frame rate.
		public func start() {
			
			state = .generating
			
			timer.restart()
			
		}
		
		/// Starts generating MTC continuous playback MIDI message stream events.
		/// Call this method at the exact time that `timecode` occurs.
		///
		/// Frame rate will be derived from the `timecode` object passed in.
		///
		/// - Note: It is not necessary to send a `locate(to:)` message simultaneously or immediately prior, and is actually undesirable as it can confuse the receiving entity.
		///
		/// Call `stop()` to stop generating events.
		public func start(at timecode: Timecode) {
			
			start(at: timecode.components,
				  frameRate: timecode.frameRate)
			
		}
		
		/// Starts generating MTC continuous playback MIDI message stream events.
		/// Call this method at the exact time that `realTime` occurs.
		///
		/// - Note: It is not necessary to send a `locate(to:)` message simultaneously or immediately prior, and is actually undesirable as it can confuse the receiving entity.
		///
		/// Call `stop()` to stop generating events.
		public func start(at components: Timecode.Components,
						  frameRate: Timecode.FrameRate) {
			
			if state == .generating {
				timer.stop()
			}
			
			encoder.locate(to: components,
						   frameRate: frameRate,
						   transmitFullFrame: .always)
			
			start()
			
		}
		
		/// Starts generating MTC continuous playback MIDI message stream events.
		/// Call this method at the exact time that `realTime` occurs.
		///
		/// - Note: It is not necessary to send a `locate(to:)` message simultaneously or immediately prior, and is actually undesirable as it can confuse the receiving entity.
		///
		/// Call `stop()` to stop generating events.
		public func start(at realTime: TimeInterval,
						  frameRate: Timecode.FrameRate) {
			
			guard let tc = Timecode(
				realTimeValue: realTime,
				at: frameRate,
				limit: ._24hours
			) else { return }
			
			start(at: tc.components,
				  frameRate: frameRate)
			
		}
		
		/// Stops generating MTC continuous playback MIDI message stream events.
		public func stop() {
			
			state = .idle
			
			timer.stop()
			
		}
		
	}
	
}
