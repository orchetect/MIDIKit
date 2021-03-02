//
//  MTC Direction.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2020-12-20.
//

extension MTC {
	
	/// Describes the timeline direction of MTC events
	public enum Direction {
		
		/// Normal playback with timecode incrementing
		case forwards
		
		/// Backwards playback with timecode decrementing
		case backwards
		
	}
	
}

extension MTC.Direction {
	
	/// Infers playback direction by comparing previous and current quarter-frames received, taking into account value wrapping around min/max.
	///
	/// Returns nil if direction cannot be reasonably inferred. This may happen if both values are identical, or if values are not adjacent +/- 1 of each other, which may indicate the quarter-frame stream has been interrupted ie: when the transmitter has located to a new timecode entirely.
	///
	/// - Parameters:
	///   - previousQF: the last quarter-frame received
	///   - newQF: the current quarter-frame received
	public init?(previousQF: UInt8, newQF: UInt8) {
		
		// sanity check: bounds
		if previousQF > 0b111 || newQF > 0b111 {
			return nil
		}
		
		// check if identical first
		if newQF == previousQF {
			// can't be inferred
			return nil
		}
		// next check min/max wrapping (0b111 -> 0b000 is forwards, 0b000 to 0b111 is backwards
		else if newQF == 0b000 && previousQF == 0b111 {
			self = .forwards
		}
		else if newQF == 0b111 && previousQF == 0b000 {
			self = .backwards
		}
		// next check for adjacent quarter-frames
		else if newQF == previousQF + 0b1 {
			self = .forwards
		}
		else if previousQF > UInt8.min && // underflow protection
					newQF == previousQF - 0b1 {
			self = .backwards
		}
		// default (ie: when a jump happens and quarter-frames are not neighbouring):
		else {
			// can't be inferred
			return nil
		}
		
	}
	
}
