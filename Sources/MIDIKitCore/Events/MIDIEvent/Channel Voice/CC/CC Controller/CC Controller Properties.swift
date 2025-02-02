//
//  CC Controller Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.CC.Controller {
    /// Returns the controller number.
    @inlinable
    public var number: UInt7 {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .bankSelect:                    0
        case .modWheel:                      1
        case .breath:                        2
        case .footController:                4
        case .portamentoTime:                5
        case .dataEntry:                     6
        case .volume:                        7
        case .balance:                       8
        case .pan:                           10
        case .expression:                    11
        case .effectControl1:                12
        case .effectControl2:                13
        case .generalPurpose1:               16
        case .generalPurpose2:               17
        case .generalPurpose3:               18
        case .generalPurpose4:               19
        case let .lsb(lsb):                  lsb.controller
        case .sustainPedal:                  64
        case .portamento:                    65
        case .sostenutoPedal:                66
        case .softPedal:                     67
        case .legatoFootswitch:              68
        case .hold2:                         69
        case .soundCtrl1_soundVariation:     70
        case .soundCtrl2_timbreIntensity:    71
        case .soundCtrl3_releaseTime:        72
        case .soundCtrl4_attackTime:         73
        case .soundCtrl5_brightness:         74
        case .soundCtrl6_decayTime:          75
        case .soundCtrl7_vibratoRate:        76
        case .soundCtrl8_vibratoDepth:       77
        case .soundCtrl9_vibratoDelay:       78
        case .soundCtrl10_defaultUndefined:  79
        case .generalPurpose5:               80
        case .generalPurpose6:               81
        case .generalPurpose7:               82
        case .generalPurpose8:               83
        case .portamentoControl:             84
        case .highResolutionVelocityPrefix:  88
        case .effects1Depth_reverbSendLevel: 91
        case .effects2Depth:                 92
        case .effects3Depth_chorusSendLevel: 93
        case .effects4Depth:                 94
        case .effects5Depth:                 95
        case .dataIncrement:                 96
        case .dataDecrement:                 97
        case .nrpnLSB:                       98
        case .nrpnMSB:                       99
        case .rpnLSB:                        100
        case .rpnMSB:                        101
        case let .mode(mode):                mode.controller
        case let .undefined(cc):             cc.controller
        }
        // swiftformat:enable spacearoundoperators
    }
}

extension MIDIEvent.CC.Controller: CustomStringConvertible {
    public var description: String {
        "\(number)"
    }
}
