//
//  MTCFrameRate Translation.swift
//  MIDIKitSync • https://github.com/orchetect/MIDIKitSync
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import MIDIKit
import TimecodeKit

// MARK: - Derived rates

extension MTCFrameRate {
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
    public var directEquivalentFrameRate: Timecode.FrameRate {
        switch self {
        case .mtc24:    return ._24
        case .mtc25:    return ._25
        case .mtc2997d: return ._29_97_drop
        case .mtc30:    return ._30
        }
    }
}

extension Timecode.FrameRate {
    /// Returns the base MTC frame rate that DAWs use to transmit timecode (scaling frame number if necessary)
    public var mtcFrameRate: MTCFrameRate {
        switch self {
        case ._23_976:      return .mtc24
        case ._24:          return .mtc24
        case ._24_98:       return .mtc24
        case ._25:          return .mtc25
        case ._29_97:       return .mtc30
        case ._29_97_drop:  return .mtc2997d
        case ._30:          return .mtc30
        case ._30_drop:     return .mtc2997d
        case ._47_952:      return .mtc24
        case ._48:          return .mtc24
        case ._50:          return .mtc25
        case ._59_94:       return .mtc30
        case ._59_94_drop:  return .mtc2997d
        case ._60:          return .mtc30
        case ._60_drop:     return .mtc2997d
        case ._100:         return .mtc25
        case ._119_88:      return .mtc30
        case ._119_88_drop: return .mtc2997d
        case ._120:         return .mtc30
        case ._120_drop:    return .mtc2997d
        }
    }
    
    /// Returns true if the timecode frame rate is derived from the MTC frame rate.
    public func transmitsMTC(using mtcFrameRate: MTCFrameRate) -> Bool {
        self.mtcFrameRate == mtcFrameRate
    }
}

// MARK: - Scaled

extension MTCFrameRate {
    /// Scales MTC frames at `self` MTC base rate to frames at other timecode frame rate.
    ///
    /// - Note: This is a specialized calculation, and is intended to act upon raw MTC frames as decoded from quarter-frame messages; not intended to be a generalized scale function.
    ///
    /// This is a double-duty function which first checks frame rate compatibility (and returns `nil` if rates are not H:MM:SS stable), then returns the scaled frames value if they are compatible.
    ///
    /// - Parameters:
    ///   - fromRawMTCFrames: Raw MTC frame number, as decoded from quarter-frame messages.
    ///   - quarterFrames: Number of QFs elapsed (0...7).
    ///   - timecodeRate: Real timecode frame rate to scale to.
    ///
    /// - Returns: A `Double` is returned with the integer part representing frame number and the fractional part representing the fraction of the frame derived from quarter-frames.
    internal func scaledFrames(
        fromRawMTCFrames: Int,
        quarterFrames: UInt8,
        to timecodeRate: Timecode.FrameRate
    ) -> Double? {
        // if real timecode frame rates are not compatible (H:MM:SS stable), frame value scaling is not possible
        guard derivedFrameRates.contains(timecodeRate) else {
            return nil
        }
        
        // clean inputs
        let rawMTCFrames = max(0, fromRawMTCFrames)
        let rawMTCQuarterFrames = min(max(0, quarterFrames), 7)
        
        // baseline check: if MTC frame rate is exactly equivalent to resultant timecode frame rate, skip the scale math
        if directEquivalentFrameRate == timecodeRate {
            return rawMTCQuarterFrames == 0
                ? Double(rawMTCFrames)
                : Double(rawMTCFrames) + (Double(rawMTCQuarterFrames) * 0.25)
        }
        
        // prep
        let _rawMTCFrames = Double(rawMTCFrames)
        let _frameFraction = Double(rawMTCQuarterFrames) * 0.25
        
        // calculation
        var scaled = (_rawMTCFrames + _frameFraction) * timecodeRate.mtcScaleFactor
        
        // account for 24.98fps rounding weirdness
        // due to it being transmit as MTC-24fps, the scaled value will always be underestimated so adding a static offset is a clumsy but effective workaround
        if timecodeRate == ._24_98 {
            if scaled > 0.0 {
                scaled += 0.24
            }
        }
        
        // return
        return scaled
    }
}

extension Timecode.FrameRate {
    /// Scales frames at other timecode frame rate to MTC frames at `self` MTC base rate.
    ///
    /// - Note: This is a specialized calculation, and is intended to produce raw MTC frames and quarter-frame messages; not intended to be a generalized scale function.
    ///
    /// - Parameter fromTimecodeFrames: A `Double` with the integer part representing frame number and the fractional part representing the fraction of the frame.
    ///
    /// - Returns: `(rawMTCFrames: Int, rawMTCQuarterFrames: UInt8)` where `rawMTCFrames` is raw MTC frame number, as decoded from quarter-frame messages and `rawMTCQuarterFrames` is number of QFs elapsed (0...7).
    internal func scaledFrames(
        fromTimecodeFrames: Double
    ) -> (
        rawMTCFrames: Int,
        rawMTCQuarterFrames: UInt8
    ) {
        // account for 24.98fps rounding weirdness
        let scaleFactor = self == ._24_98
            ? mtcScaleFactor - 0.001
            : mtcScaleFactor
        
        // prep
        let scaled = fromTimecodeFrames / scaleFactor
        let _tcFrameFraction = scaled.truncatingRemainder(dividingBy: 2)
        
        let _rawMTCFrames = Int(scaled - _tcFrameFraction) // truncates at decimal
        let _rawMTCQuarterFrames = UInt8(_tcFrameFraction / 0.25)
        
        return (
            rawMTCFrames: _rawMTCFrames,
            rawMTCQuarterFrames: _rawMTCQuarterFrames
        )
    }
}

extension Timecode.FrameRate {
    /// Internal: scale factor used when scaling timecode frame rate to/from MTC SMPTE frame rates
    internal var mtcScaleFactor: Double {
        // calculated from:
        // (self.maxFrameNumberDisplayable + 1) / self.mtcFrameRate.fpsValueForScaling
        
        switch self {
        case ._23_976:      return 1
        case ._24:          return 1
        case ._24_98:       return 1.0416666666666666666666 // 25.0/24.0
        case ._25:          return 1
        case ._29_97:       return 1
        case ._29_97_drop:  return 1
        case ._30:          return 1
        case ._30_drop:     return 1
        case ._47_952:      return 2
        case ._48:          return 2
        case ._50:          return 2
        case ._59_94:       return 2
        case ._59_94_drop:  return 2
        case ._60:          return 2
        case ._60_drop:     return 2
        case ._100:         return 4
        case ._119_88:      return 4
        case ._119_88_drop: return 4
        case ._120:         return 4
        case ._120_drop:    return 4
        }
    }
}
