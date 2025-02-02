//
//  CC Controller name.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.CC.Controller {
    /// Returns the controller name as a human-readable String.
    public var name: String {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .bankSelect:                    "Bank Select"
        case .modWheel:                      "Mod Wheel"
        case .breath:                        "Breath Controller"
        case .footController:                "Foot Controller"
        case .portamentoTime:                "Portamento Time"
        case .dataEntry:                     "Data Entry MSB"
        case .volume:                        "Volume"
        case .balance:                       "Balance"
        case .pan:                           "Pan"
        case .expression:                    "Expression"
        case .effectControl1:                "Effect Control 1"
        case .effectControl2:                "Effect Control 2"
        case .generalPurpose1:               "General Purpose 1"
        case .generalPurpose2:               "General Purpose 2"
        case .generalPurpose3:               "General Purpose 3"
        case .generalPurpose4:               "General Purpose 4"
        case let .lsb(lsb):                  lsb.name
        case .sustainPedal:                  "Sustain Pedal"
        case .portamento:                    "Portamento"
        case .sostenutoPedal:                "Sostenuto Pedal"
        case .softPedal:                     "Soft Pedal"
        case .legatoFootswitch:              "Legato Footswitch"
        case .hold2:                         "Hold 2"
        case .soundCtrl1_soundVariation:     "Sound Control 1 - Sound Variation"
        case .soundCtrl2_timbreIntensity:    "Sound Control 2 - Timbre Intensity"
        case .soundCtrl3_releaseTime:        "Sound Control 3 - Release Time"
        case .soundCtrl4_attackTime:         "Sound Control 4 - Attack Time"
        case .soundCtrl5_brightness:         "Sound Control 5 - Brightness"
        case .soundCtrl6_decayTime:          "Sound Control 6 - Decay Time"
        case .soundCtrl7_vibratoRate:        "Sound Control 7 - Vibrato Rate"
        case .soundCtrl8_vibratoDepth:       "Sound Control 8 - Vibrato Depth"
        case .soundCtrl9_vibratoDelay:       "Sound Control 9 - Vibrato Delay"
        case .soundCtrl10_defaultUndefined:  "Sound Control 10 - Undefined"
        case .generalPurpose5:               "General Purpose 5"
        case .generalPurpose6:               "General Purpose 6"
        case .generalPurpose7:               "General Purpose 7"
        case .generalPurpose8:               "General Purpose 8"
        case .portamentoControl:             "Portamento Control"
        case .highResolutionVelocityPrefix:  "High Resolution Velocity Prefix"
        case .effects1Depth_reverbSendLevel: "Effects 1 Depth - Reverb Send Level"
        case .effects2Depth:                 "Effects 2 Depth"
        case .effects3Depth_chorusSendLevel: "Effects 3 Depth - Chorus Send Level"
        case .effects4Depth:                 "Effects 4 Depth"
        case .effects5Depth:                 "Effects 5 Depth"
        case .dataIncrement:                 "Data Increment"
        case .dataDecrement:                 "Data Decrement"
        case .nrpnLSB:                       "NRPN LSB"
        case .nrpnMSB:                       "NRPN MSB"
        case .rpnLSB:                        "RPN LSB"
        case .rpnMSB:                        "RPN MSB"
        case let .mode(mode):                mode.name
        case let .undefined(cc):             cc.name
        }
        // enable:disable spacearoundoperators
    }
}
