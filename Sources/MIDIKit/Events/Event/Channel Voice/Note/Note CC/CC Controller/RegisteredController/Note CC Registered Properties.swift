//
//  Note CC Registered Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.Note.CC.Controller.Registered {
    /// Returns the controller number.
    @inline(__always)
    public var number: UInt8 {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .modWheel                      : return 1
        case .breath                        : return 2
        case .pitch7_25                     : return 3
        
        case .volume                        : return 7
        case .balance                       : return 8
        
        case .pan                           : return 10
        case .expression                    : return 11
        
        case .soundCtrl1_soundVariation     : return 70
        case .soundCtrl2_timbreIntensity    : return 71
        case .soundCtrl3_releaseTime        : return 72
        case .soundCtrl4_attackTime         : return 73
        case .soundCtrl5_brightness         : return 74
        case .soundCtrl6_decayTime          : return 75
        case .soundCtrl7_vibratoRate        : return 76
        case .soundCtrl8_vibratoDepth       : return 77
        case .soundCtrl9_vibratoDelay       : return 78
        case .soundCtrl10_defaultUndefined  : return 79
        
        case .effects1Depth_reverbSendLevel : return 91
        case .effects2Depth                 : return 92
        case .effects3Depth_chorusSendLevel : return 93
        case .effects4Depth                 : return 94
        case .effects5Depth                 : return 95
            
        case let .undefined(cc)             : return cc.controller
        }
        // swiftformat:enable spacearoundoperators
    }
}
