//
//  MTCFrameRate.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore
import TimecodeKitCore

// MTC hour byte includes frame rate information
// Only 4 base frame rates are described according to the MTC spec
//
//   0rrhhhhh: Rate (0–3) and hour (0–23).
//   rr == 0b00: 24 frames/s
//   rr == 0b01: 25 frames/s
//   rr == 0b10: 29.97 frames/s (SMPTE drop-frame timecode)
//   rr == 0b11: 30 frames/s
//
// This means that actual frame rate cannot be reliably inferred from the MTC stream.
// See chart below for details.
//
// MTC can only describe four base frame rates. 24, 25, drop, and 30.
// All other actual rates in the DAW just become derived from one of those
// in order to transmit MTC. Backwards-compatibility basically.
// The frames as sent via MTC get scaled down to the appropriate base rate.
// ie:
//   01:00:00:15 @ 30fps  will be received as 01:00:00:15 @ 30fps
//   01:00:00:30 @ 60fps  will be received as 01:00:00:15 @ 30fps
//   01:00:00:60 @ 120fps will be received as 01:00:00:15 @ 30fps
//
// MTC frame rates as transmitted from DAWs:
//
// DAW Frame Rate      MTC Base Frame Rate                     Tested from DAW
// -----------------   --------------------------------------  -----------------
// 23.976              0b00 - 24                               Pro Tools 2020.11
// 24                  0b00 - 24                               Pro Tools 2020.11
// 24.98               0b00 - 24 (h:m:s == 23.976, 47.952)     Cubase Pro 11
// 25                  0b01 - 25                               Pro Tools 2020.11
// 29.97               0b11 - 30                               Pro Tools 2020.11
// 29.97d              0b10 - 29.97d                           Pro Tools 2020.11
// 30                  0b11 - 30                               Pro Tools 2020.11
// 30d                 0b10 - 29.97d                           Pro Tools 2020.11
// 47.952  (2*23.976)  0b00 - 24                               Pro Tools 2020.11
// 48      (2*24)      0b00 - 24                               Pro Tools 2020.11
// 50      (2*25)      0b01 - 25                               Pro Tools 2020.11
// 59.94   (2*29.97)   0b11 - 30                               Pro Tools 2020.11
// 59.94d  (2*29.97d)  0b10 - 29.97d                           Pro Tools 2020.11
// 60      (2*30)      0b11 - 30                               Pro Tools 2020.11
// 60d     (2*30d)     0b10 - 29.97d                           Pro Tools 2020.11
// 100     (4*25)      0b01 - 25                               Pro Tools 2020.11
// 119.88  (4*29.97)   0b11 - 30                               Pro Tools 2020.11
// 119.88d (4*29.97d)  0b10 - 29.97d                           Pro Tools 2020.11
// 120     (4*30)      0b11 - 30                               Pro Tools 2020.11
// 120d    (4*30d)     0b10 - 29.97d                           Pro Tools 2020.11
//
// MTC distinguishes between film speed and video speed only by the rate at which
// timecode advances, not by the information contained in the timecode messages;
// thus, 29.97 fps dropframe is represented as 30 fps dropframe at 0.1% pulldown.
    
/// Standard base timecode frame rate families expressed in MTC.
///
/// This does not always directly correlate to the actual frame rate the transmitting and receiving
/// DAW is using.
/// When DAWs transmit MTC, the frame rate gets scaled down to one of the four base MTC frame rates.
/// It is the job of the receiving DAW to scale the MTC frame data back up to the desired actual
/// frame rate.
public enum MTCFrameRate: Hashable, CaseIterable {
    /// MTC frame rate classification of 24 fps and related rates
    case mtc24
        
    /// MTC frame rate classification of 25 fps and related rates
    case mtc25
        
    /// MTC frame rate classification of 29.97 drop fps and related rates
    case mtc2997d
        
    /// MTC frame rate classification of 30 fps and related rates
    case mtc30
        
    // MARK: - Init
        
    /// Construct based on the corresponding real timecode frame rate
    init(_ timecodeFrameRate: TimecodeFrameRate) {
        self = timecodeFrameRate.mtcFrameRate
    }
        
    /// Construct from MTC bits
    init?(_ bitValue: UInt8) {
        switch bitValue {
        case 0b00:      self = .mtc24
        case 0b01:      self = .mtc25
        case 0b10:      self = .mtc2997d
        case 0b11:      self = .mtc30
        default:        return nil
        }
    }
        
    // MARK: - Public properties
        
    /// Raw bit value transmitted in MTC messages
    public var bitValue: UInt8 {
        switch self {
        case .mtc24:    return 0b00
        case .mtc25:    return 0b01
        case .mtc2997d: return 0b10
        case .mtc30:    return 0b11
        }
    }
        
    /// Human-readable descriptive string
    public var stringValue: String {
        switch self {
        case .mtc24:    return "SMPTE-24"
        case .mtc25:    return "SMPTE-25"
        case .mtc2997d: return "SMPTE-29.97d"
        case .mtc30:    return "SMPTE-30"
        }
    }
        
    /// Returns true if the rate is drop-frame
    public var isDrop: Bool {
        switch self {
        case .mtc24:    return false
        case .mtc25:    return false
        case .mtc2997d: return true
        case .mtc30:    return false
        }
    }
        
    // MARK: - Internal properties
        
    /// FPS Value for scaling MTC frame rate
    var fpsValueForScaling: Int {
        switch self {
        case .mtc24:    return 24
        case .mtc25:    return 25
        case .mtc2997d: return 30
        case .mtc30:    return 30
        }
    }
}

extension MTCFrameRate: Identifiable {
    public var id: Self { self }
}

extension MTCFrameRate: Sendable { }
