//
//  MTC Encoder.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import MIDIKitInternals
import TimecodeKit
@_implementationOnly import OTCore

extension MIDI.MTC {
	
	/// MTC (MIDI Timecode) stream encoder object.
	///
	/// Takes timecode values and produces a stream of MIDI events.
	///
	/// This object is not affected by or reliant on timing at all and simply processes events as they are received. For outbound MTC sync, use the `MTC.Generator` wrapper object which adds additional abstraction for generating MTC sync.
	public class Encoder {
		
		// MARK: - Public properties
		
		/// Returns current `Timecode` at `localFrameRate`, scaling if necessary.
		public var timecode: Timecode {
			
			guard let scaledFrames = mtcFrameRate.scaledFrames(
				fromRawMTCFrames: mtcComponents.f,
				quarterFrames: mtcQuarterFrame,
				to: localFrameRate
			) else {
				// rates are not compatible; return a default instead of failing
				return Timecode(at: localFrameRate)
			}
			
			var scaledComponents = mtcComponents
			scaledComponents.f = Int(scaledFrames)
			// sanitize: clear subframes since we're working at 1-frame resolution with timecode display values
			scaledComponents.sf = 0
			
			return Timecode(
				wrapping: scaledComponents,
				at: localFrameRate,
				limit: ._24hours
			)
			
		}
		
		/// Last internal MTC SPMTE timecode components formed from outgoing MTC data.
		public internal(set) var mtcComponents = Timecode.Components()
		
		internal func setMTCComponents(mtc newComponents: Timecode.Components) {
			
			mtcComponents = newComponents
			
		}
		
		/// Local frame rate (desired rate, not internal MTC SMPTE frame rate).
		public internal(set) var localFrameRate: Timecode.FrameRate = ._30
		
		/// Set local frame rate (desired rate, not internal MTC SMPTE frame rate).
		internal func setLocalFrameRate(_ newFrameRate: Timecode.FrameRate) {
			
			localFrameRate = newFrameRate
			mtcFrameRate = newFrameRate.mtcFrameRate
			
		}
		
		/// The base MTC frame rate last transmitted.
		public internal(set) var mtcFrameRate: MTCFrameRate = .mtc30
		
		/// Called when a MTC MIDI message needs transmitting.
		internal var midiEventSendHandler: ((_ midiMessage: [Byte]) -> Void)? = nil
		
		/// Set the handler used when a MTC MIDI message needs transmitting.
		public func setMIDIEventSendHandler(
			_ handler: ((_ midiMessage: [Byte]) -> Void)?
		) {
			
			midiEventSendHandler = handler
			
		}
		
		
		// MARK: - Internal properties
		
		/// Last internal MTC quarter-frame formed. (0...7)
		public internal(set) var mtcQuarterFrame: UInt8 = 0
		
		/// Internal: flag indicating whether the quarter-frame output stream has already started since the last `locate(to:)` (or since initializing the class if `locate(to:)` has not yet been called).
		internal var mtcQuarterFrameStreamHasStartedSinceLastLocate = false
		
		
		// MARK: - init
		
		/// Initialize and optionally set the handler used when a MTC MIDI message needs transmitting.
		init(
			midiEventSendHandler: ((_ midiMessage: [Byte]) -> Void)? = nil
		) {
			
			setMIDIEventSendHandler(midiEventSendHandler)
			
		}
		
		
		// MARK: - methods
		
		/// Locates to a new timecode.
		/// Subframes will be stripped if != 0.
		///
		/// - Parameters:
		///   - timecode: Timecode; frame rate is derived as well.
		///   - triggerFullFrame: Triggers the MIDI handler to send a full-frame message.
		public func locate(to timecode: Timecode,
						   triggerFullFrame: Bool = true) {
			
			locate(to: timecode.components,
				   frameRate: timecode.frameRate,
				   triggerFullFrame: triggerFullFrame)
			
		}
		
		/// Locates to a new timecode.
		/// Subframes will be stripped if != 0.
		///
		/// - Parameters:
		///   - components: Timecode components
		///   - frameRate: Frame rate
		///   - triggerFullFrame: Triggers the MIDI handler to send a full-frame message.
		public func locate(to components: Timecode.Components,
						   frameRate: Timecode.FrameRate? = nil,
						   triggerFullFrame: Bool = true) {
			
			if let frameRate = frameRate {
				setLocalFrameRate(frameRate)
			}
			
			let scaledFrames = localFrameRate
				.scaledFrames(fromTimecodeFrames: Double(components.f))
			
			var newComponents = components
			newComponents.f = scaledFrames.rawMTCFrames
			// sanitize: clear subframes since we're working at 1-frame resolution with timecode display values
			newComponents.sf = 0
			
			setMTCComponents(mtc: newComponents)
			mtcQuarterFrame = scaledFrames.rawMTCQuarterFrames
			mtcQuarterFrameStreamHasStartedSinceLastLocate = false
			
			// tell handler to transmit MIDI message
			if triggerFullFrame {
				sendFullFrameMIDIMessage()
			}
			
		}
		
		/// Advances to the next quarter-frame and triggers a quarter-frame MIDI message sent to the MIDI handler.
		///
		/// - Note: If it is the first time `increment()` is being called since the last call to `locate(to:)` (or since initializing the class), this method will transmit the current quarter-frame without incrementing.
		///
		/// Used when playhead is moving later in time.
		@inline(__always) public func increment() {
			
			if mtcQuarterFrameStreamHasStartedSinceLastLocate {
				if mtcQuarterFrame < 7 {
					mtcQuarterFrame += 1
				} else {
					guard var tc = Timecode(
						mtcComponents,
						at: mtcFrameRate.directEquivalentFrameRate
					) else { return }
					
					tc.add(wrapping: TCC(f: 2))
					mtcComponents = tc.components
					mtcQuarterFrame = 0
				}
			}
			
			// tell handler to transmit MIDI message
			sendQuarterFrameMIDIMessage()
			mtcQuarterFrameStreamHasStartedSinceLastLocate = true
			
		}
		
		/// Decrements to the previous quarter-frame and triggers a quarter-frame MIDI message sent to the MIDI handler.
		///
		/// - Note: If it is the first time `decrement()` is being called since the last call to `locate(to:)` (or since initializing the class), this method will transmit the current quarter-frame without decrementing.
		///
		/// Used when playhead is moving earlier in time.
		@inline(__always) public func decrement() {
			
			if mtcQuarterFrameStreamHasStartedSinceLastLocate {
			if mtcQuarterFrame > 0 {
				mtcQuarterFrame -= 1
			} else {
				guard var tc = Timecode(
					mtcComponents,
					at: mtcFrameRate.directEquivalentFrameRate
				) else { return }
				
				tc.subtract(wrapping: TCC(f: 2))
				mtcComponents = tc.components
				mtcQuarterFrame = 7
			}
			}
			
			// tell handler to transmit MIDI message
			sendQuarterFrameMIDIMessage()
			mtcQuarterFrameStreamHasStartedSinceLastLocate = true
			
		}
		
		/// Manually trigger a MIDI handler event to transmit a full-frame message at the current timecode.
		public func sendFullFrameMIDIMessage() {
			
			midiEventSendHandler?(generateFullFrameMIDIMessage())
			
		}
		
		/// Internal: generates a full-frame message at current position.
		internal func generateFullFrameMIDIMessage() -> [Byte] {
			
			// MTC Full Timecode message
			// (1-frame resolution, does not carry subframe information)
			// ---------------------
			// F0 7F 7F 01 01 hh mm ss ff F7
			
			// hour byte includes base framerate info
			// 0rrhhhhh: Rate (0–3) and hour (0–23).
			// rr == 00: 24 frames/s
			// rr == 01: 25 frames/s
			// rr == 10: 29.97d frames/s (SMPTE drop-frame timecode)
			// rr == 11: 30 frames/s
			
			let midiMessage: [Byte] = [
				0xF0,
				0x7F,
				0x7F,
				0x01,
				0x01,
				(Byte(mtcComponents.h) & 0b0001_1111) + (mtcFrameRate.bitValue << 5),
				Byte(mtcComponents.m),
				Byte(mtcComponents.s),
				Byte(mtcComponents.f),
				0xF7
			]
			
			return midiMessage
			
		}
		
		/// Internal: triggers a handler event to transmit a quarter-frame message.
		@inline(__always) internal func sendQuarterFrameMIDIMessage() {
			
			midiEventSendHandler?(generateQuarterFrameMIDIMessage())
			
		}
		
		/// Internal: generates a quarter-frame message at current position.
		@inline(__always) internal func generateQuarterFrameMIDIMessage() -> [Byte] {
			
			// Piece #	Data byte	Significance
			// -------	---------	------------
			// 0		0000 ffff	Frame number lsbits
			// 1		0001 000f	Frame number msbit
			// 2		0010 ssss	Seconds lsbits
			// 3		0011 00ss	Seconds msbits
			// 4		0100 mmmm	Minutes lsbits
			// 5		0101 00mm	Minutes msbits
			// 6		0110 hhhh	Hours lsbits
			// 7		0111 0rrh	Rate and hours msbit
			
			var midiMessage: [Byte] = [0xF1, 0x00]
			
			var dataByte: Byte = mtcQuarterFrame << 4
			
			switch mtcQuarterFrame {
			case 0b000: // QF 0
				dataByte += (Byte(mtcComponents.f) & 0b0000_1111)
			case 0b001: // QF 1
				dataByte += (Byte(mtcComponents.f) & 0b0001_0000) >> 4
			case 0b010: // QF 2
				dataByte += (Byte(mtcComponents.s) & 0b0000_1111)
			case 0b011: // QF 3
				dataByte += (Byte(mtcComponents.s) & 0b0011_0000) >> 4
			case 0b100: // QF 4
				dataByte += (Byte(mtcComponents.m) & 0b0000_1111)
			case 0b101: // QF 5
				dataByte += (Byte(mtcComponents.m) & 0b0011_0000) >> 4
			case 0b110: // QF 6
				dataByte += (Byte(mtcComponents.h) & 0b0000_1111)
			case 0b111: // QF 7
				dataByte += ((Byte(mtcComponents.h) & 0b0001_0000) >> 4)
					+ (mtcFrameRate.bitValue << 1)
			default:
				break // will never happen
			}
			
			midiMessage[1] = dataByte
			
			return midiMessage
			
		}
		
	}
	
}
