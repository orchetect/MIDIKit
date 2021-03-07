//
//  MTC MTCFrameRate Translation.swift
//  MIDIKit
//
//  Created by Steffan Andrews on 2020-12-11.
//

import TimecodeKit


// MARK: - Derived rates

extension MTC.MTCFrameRate {
	
	/// Returns all timecode frame rates derived from the MTC base frame rate.
	public var derivedFrameRates: [Timecode.FrameRate] {
		
		// could hard-code these, but keeping it functional ensures compiler safety checking
		
		Timecode.FrameRate
			.allCases
			.filter { $0.transmitsMTC(using: self) }
		
	}
	
	/// Returns the timecode frame rate that exactly matches the MTC base frame rate.
	///
	/// Useful for internal calculations.
	///
	/// To get all timecode frame rates that are compatible, use `derivedFrameRates` instead.
	@inline(__always) public var directEquivalentFrameRate: Timecode.FrameRate {
		
		switch self {
		case .mtc24:	return ._24
		case .mtc25:	return ._25
		case .mtc2997d:	return ._29_97_drop
		case .mtc30:	return ._30
		}
		
	}
	
}

extension Timecode.FrameRate {
	
	/// Returns the base MTC frame rate that DAWs use to transmit timecode (scaling frame number if necessary)
	@inline(__always) public var mtcFrameRate: MTC.MTCFrameRate {
		
		switch self {
		case ._23_976:		return .mtc24
		case ._24:			return .mtc24
		case ._24_98:		return .mtc24
		case ._25:			return .mtc25
		case ._29_97:		return .mtc30
		case ._29_97_drop:	return .mtc2997d
		case ._30:			return .mtc30
		case ._30_drop:		return .mtc2997d
		case ._47_952:		return .mtc24
		case ._48:			return .mtc24
		case ._50:			return .mtc25
		case ._59_94:		return .mtc30
		case ._59_94_drop:	return .mtc2997d
		case ._60:			return .mtc30
		case ._60_drop:		return .mtc2997d
		case ._100:			return .mtc25
		case ._119_88:		return .mtc30
		case ._119_88_drop:	return .mtc2997d
		case ._120:			return .mtc30
		case ._120_drop:	return .mtc2997d
		}
		
	}
	
	/// Returns true if the timecode frame rate is derived from the MTC frame rate.
	@inlinable public func transmitsMTC(using mtcFrameRate: MTC.MTCFrameRate) -> Bool {
		
		self.mtcFrameRate == mtcFrameRate
		
	}
	
}


// MARK: - Scaled

extension MTC.MTCFrameRate {
	
	/// Scales MTC frames at `self` MTC base rate to actual frames at real timecode frame rate.
	///
	/// A `Double` is returned with the integer part representing frame number and the fractional part representing the fraction of the frame derived from quarter-frames.
	///
	/// - Note: This is a specialized calculation, and is intended to act upon raw MTC frames as decoded from quarter-frame messages; not intended to be a generalized scale function.
	///
	/// This is a double-duty function which first checks frame rate compatibility (and returns `nil` if rates are not H:MM:SS stable), then returns the scaled frames value if they are compatible.
	///
	/// - Parameters:
	///   - fromRawMTCFrames: raw MTC frame number, as decoded from quarter-frame messages
	///   - quarterFrames: 0...7 number of QFs elapsed
	///   - timecodeRate: real timecode frame rate to scale to
	/// - Returns: Frame number scaled to real timecode frame rate.
	internal func scaledFrames(fromRawMTCFrames: Int,
							   quarterFrames: UInt8,
							   to timecodeRate: Timecode.FrameRate) -> Double? {
		
		// if real timecode frame rates are not compatible (H:MM:SS stable), frame value scaling is not possible
		guard self.derivedFrameRates.contains(timecodeRate) else {
			return nil
		}
		
		// sanitize inputs
		let rawMTCFrames = fromRawMTCFrames.clamped(to: 0...)
		let quarterFrames = quarterFrames.clamped(to: 0...7)
		
		// baseline check: if MTC frame rate is exactly equivalent to resultant timecode frame rate, skip the scale math
		if self.directEquivalentFrameRate == timecodeRate {
			return quarterFrames == 0
				? Double(rawMTCFrames)
				: Double(rawMTCFrames) + (Double(quarterFrames) * 0.25)
		}
		
		// denominators
		let maxBaseFrames = fpsValueForScaling
		let maxRealFrames = timecodeRate.maxFrameNumberDisplayable + 1
		
		// prep
		let _rawMTCFrames = Double(rawMTCFrames)
		let _frameFraction = Double(quarterFrames) * 0.25
		let _scaleFactor = Double(maxRealFrames) / Double(maxBaseFrames)
		
		// calculation
		let scaled = (_rawMTCFrames + _frameFraction) * _scaleFactor
		
		// return
		return scaled
		
	}
	
}
