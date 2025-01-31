//
//  MTCFrameRate Translation.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import TimecodeKitCore

// MARK: - Derived rates

extension MTCFrameRate {
    /// Returns all timecode frame rates derived from the MTC base frame rate.
    public var derivedFrameRates: [TimecodeFrameRate] {
        // could hard-code these, but keeping it functional ensures compiler safety checking
        
        TimecodeFrameRate
            .allCases
            .filter { $0.transmitsMTC(using: self) }
    }
    
    /// Returns the timecode frame rate that exactly matches the MTC base frame rate.
    ///
    /// Useful for internal calculations.
    ///
    /// To get all timecode frame rates that are compatible, use ``derivedFrameRates`` instead.
    @inline(__always)
    public var directEquivalentFrameRate: TimecodeFrameRate {
        switch self {
        case .mtc24:    return .fps24
        case .mtc25:    return .fps25
        case .mtc2997d: return .fps29_97d
        case .mtc30:    return .fps30
        }
    }
}

extension TimecodeFrameRate {
    /// Returns the base MTC frame rate that DAWs use to transmit timecode (scaling frame number if
    /// necessary)
    @inline(__always)
    public var mtcFrameRate: MTCFrameRate {
        switch self {
        case .fps23_976:  return .mtc24
        case .fps24:      return .mtc24
        case .fps24_98:   return .mtc24
        case .fps25:      return .mtc25
        case .fps29_97:   return .mtc30
        case .fps29_97d:  return .mtc2997d
        case .fps30:      return .mtc30
        case .fps30d:     return .mtc2997d
        case .fps47_952:  return .mtc24
        case .fps48:      return .mtc24
        case .fps50:      return .mtc25
        case .fps59_94:   return .mtc30
        case .fps59_94d:  return .mtc2997d
        case .fps60:      return .mtc30
        case .fps60d:     return .mtc2997d
        case .fps90:      return .mtc30
        case .fps95_904:  return .mtc24
        case .fps96:      return .mtc24
        case .fps100:     return .mtc25
        case .fps119_88:  return .mtc30
        case .fps119_88d: return .mtc2997d
        case .fps120:     return .mtc30
        case .fps120d:    return .mtc2997d
        }
    }
    
    /// Returns true if the timecode frame rate is derived from the MTC frame rate.
    @inlinable
    public func transmitsMTC(using mtcFrameRate: MTCFrameRate) -> Bool {
        self.mtcFrameRate == mtcFrameRate
    }
}

// MARK: - Scaled

extension MTCFrameRate {
    /// Scales MTC frames at `self` MTC base rate to frames at other timecode frame rate.
    ///
    /// - Note: This is a specialized calculation, and is intended to act upon raw MTC frames as
    /// decoded from quarter-frame messages; not intended to be a generalized scale function.
    ///
    /// This is a double-duty function which first checks frame rate compatibility (and returns
    /// `nil` if rates are not H:MM:SS stable), then returns the scaled frames value if they are
    /// compatible.
    ///
    /// - Parameters:
    ///   - fromRawMTCFrames: Raw MTC frame number, as decoded from quarter-frame messages.
    ///   - quarterFrames: Number of QFs elapsed (0...7).
    ///   - timecodeRate: Real timecode frame rate to scale to.
    ///
    /// - Returns: A `Double` is returned with the integer part representing frame number and the
    ///   fractional part representing the fraction of the frame derived from quarter-frames.
    func scaledFrames(
        fromRawMTCFrames: Int,
        quarterFrames: UInt8,
        to timecodeRate: TimecodeFrameRate
    ) -> Double? {
        // if real timecode frame rates are not compatible (H:MM:SS stable), frame value scaling is
        // not possible
        guard derivedFrameRates.contains(timecodeRate) else {
            return nil
        }
        
        // clean inputs
        let rawMTCFrames = max(0, fromRawMTCFrames)
        let rawMTCQuarterFrames = min(max(0, quarterFrames), 7)
        
        // baseline check: if MTC frame rate is exactly equivalent to resultant timecode frame rate,
        // skip the scale math
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
        // due to it being transmit as MTC-24fps, the scaled value will always be underestimated so
        // adding a static offset is a clumsy but effective workaround
        if timecodeRate == .fps24_98 {
            if scaled > 0.0 {
                scaled += 0.24
            }
        }
        
        // return
        return scaled
    }
}

extension TimecodeFrameRate {
    /// Scales frames at other timecode frame rate to MTC frames at `self` MTC base rate.
    ///
    /// - Note: This is a specialized calculation, and is intended to produce raw MTC frames and
    /// quarter-frame messages; not intended to be a generalized scale function.
    ///
    /// - Parameter fromTimecodeFrames: A `Double` with the integer part representing frame number
    /// and the fractional part representing the fraction of the frame.
    ///
    /// - Returns: `(rawMTCFrames: Int, rawMTCQuarterFrames: UInt8)` where `rawMTCFrames` is raw MTC
    /// frame number, as decoded from quarter-frame messages and `rawMTCQuarterFrames` is number of
    /// QFs elapsed (`0 ... 7`).
    func scaledFrames(
        fromTimecodeFrames: Double
    ) -> (
        rawMTCFrames: Int,
        rawMTCQuarterFrames: UInt8
    ) {
        // account for 24.98fps rounding weirdness
        let scaleFactor = self == .fps24_98
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

extension TimecodeFrameRate {
    /// Internal: scale factor used when scaling timecode frame rate to/from MTC SMPTE frame rates
    @inline(__always)
    var mtcScaleFactor: Double {
        // calculated from:
        // (self.maxFrameNumberDisplayable + 1) / self.mtcFrameRate.fpsValueForScaling
        
        switch self {
        case .fps23_976:  return 1
        case .fps24:      return 1
        case .fps24_98:   return 1.0416666666666666666666 // 25.0/24.0
        case .fps25:      return 1
        case .fps29_97:   return 1
        case .fps29_97d:  return 1
        case .fps30:      return 1
        case .fps30d:     return 1
        case .fps47_952:  return 2
        case .fps48:      return 2
        case .fps50:      return 2
        case .fps59_94:   return 2
        case .fps59_94d:  return 2
        case .fps60:      return 2
        case .fps60d:     return 2
        case .fps90:      return 3
        case .fps95_904:  return 4
        case .fps96:      return 4
        case .fps100:     return 4
        case .fps119_88:  return 4
        case .fps119_88d: return 4
        case .fps120:     return 4
        case .fps120d:    return 4
        }
    }
}
