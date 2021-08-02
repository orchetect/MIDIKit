//
//  CC Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.CC {
    
    /// Returns the controller number.
    @inlinable public var controller: MIDI.UInt7 {
        
        switch self {
        
        case .bankSelect                    : return 0
        case .modWheel                      : return 1
        case .breath                        : return 2
        case .footController                : return 4
        case .portamentoTime                : return 5
        case .dataEntry                     : return 6
        case .channelVolume                 : return 7
        case .balance                       : return 8
        case .pan                           : return 10
        case .expression                    : return 11
        case .effectControl1                : return 12
        case .effectControl2                : return 13
        case .generalPurpose1               : return 16
        case .generalPurpose2               : return 17
        case .generalPurpose3               : return 18
        case .generalPurpose4               : return 19
            
        case .lsb(let lsb): return lsb.controller
            
        case .sustainPedal                  : return 64
        case .portamento                    : return 65
        case .sostenutoPedal                : return 66
        case .softPedal                     : return 67
        case .legatoFootswitch              : return 68
        case .hold2                         : return 69
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
        case .generalPurpose5               : return 80
        case .generalPurpose6               : return 81
        case .generalPurpose7               : return 82
        case .generalPurpose8               : return 83
        case .portamentoControl             : return 84
        case .highResolutionVelocityPrefix  : return 88
        case .effects1Depth_reverbSendLevel : return 91
        case .effects2Depth                 : return 92
        case .effects3Depth_chorusSendLevel : return 93
        case .effects4Depth                 : return 94
        case .effects5Depth                 : return 95
        case .dataIncrement                 : return 96
        case .dataDecrement                 : return 97
        case .nrpnLSB                       : return 98
        case .nrpnMSB                       : return 99
        case .rpnLSB                        : return 100
        case .rpnMSB                        : return 101
            
        case .mode(let mode): return mode.controller
            
        case .undefined(let cc): return cc.controller
            
        }
        
    }
    
}
