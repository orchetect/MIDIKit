//
//  CC Controller Name.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDIEvent.CC.Controller {
    /// Returns the controller name as a human-readable String.
    @inlinable
    public var name: String {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .bankSelect                    : return "Bank Select"
        case .modWheel                      : return "Mod Wheel"
        case .breath                        : return "Breath Controller"
        case .footController                : return "Foot Controller"
        case .portamentoTime                : return "Portamento Time"
        case .dataEntry                     : return "Data Entry MSB"
        case .volume                        : return "Volume"
        case .balance                       : return "Balance"
        case .pan                           : return "Pan"
        case .expression                    : return "Expression"
        case .effectControl1                : return "Effect Control 1"
        case .effectControl2                : return "Effect Control 2"
        case .generalPurpose1               : return "General Purpose 1"
        case .generalPurpose2               : return "General Purpose 2"
        case .generalPurpose3               : return "General Purpose 3"
        case .generalPurpose4               : return "General Purpose 4"
            
        case let .lsb(lsb)                  : return lsb.name
            
        case .sustainPedal                  : return "Sustain Pedal"
        case .portamento                    : return "Portamento"
        case .sostenutoPedal                : return "Sostenuto Pedal"
        case .softPedal                     : return "Soft Pedal"
        case .legatoFootswitch              : return "Legato Footswitch"
        case .hold2                         : return "Hold 2"
        case .soundCtrl1_soundVariation     : return "Sound Control 1 - Sound Variation"
        case .soundCtrl2_timbreIntensity    : return "Sound Control 2 - Timbre Intensity"
        case .soundCtrl3_releaseTime        : return "Sound Control 3 - Release Time"
        case .soundCtrl4_attackTime         : return "Sound Control 4 - Attack Time"
        case .soundCtrl5_brightness         : return "Sound Control 5 - Brightness"
        case .soundCtrl6_decayTime          : return "Sound Control 6 - Decay Time"
        case .soundCtrl7_vibratoRate        : return "Sound Control 7 - Vibrato Rate"
        case .soundCtrl8_vibratoDepth       : return "Sound Control 8 - Vibrato Depth"
        case .soundCtrl9_vibratoDelay       : return "Sound Control 9 - Vibrato Delay"
        case .soundCtrl10_defaultUndefined  : return "Sound Control 10 - Undefined"
        case .generalPurpose5               : return "General Purpose 5"
        case .generalPurpose6               : return "General Purpose 6"
        case .generalPurpose7               : return "General Purpose 7"
        case .generalPurpose8               : return "General Purpose 8"
        case .portamentoControl             : return "Portamento Control"
        case .highResolutionVelocityPrefix  : return "High Resolution Velocity Prefix"
        case .effects1Depth_reverbSendLevel : return "Effects 1 Depth - Reverb Send Level"
        case .effects2Depth                 : return "Effects 2 Depth"
        case .effects3Depth_chorusSendLevel : return "Effects 3 Depth - Chorus Send Level"
        case .effects4Depth                 : return "Effects 4 Depth"
        case .effects5Depth                 : return "Effects 5 Depth"
        case .dataIncrement                 : return "Data Increment"
        case .dataDecrement                 : return "Data Decrement"
        case .nrpnLSB                       : return "NRPN LSB"
        case .nrpnMSB                       : return "NRPN MSB"
        case .rpnLSB                        : return "RPN LSB"
        case .rpnMSB                        : return "RPN MSB"
            
        case let .mode(mode)                : return mode.name
            
        case let .undefined(cc)             : return cc.name
        }
        // enable:disable spacearoundoperators
    }
}
