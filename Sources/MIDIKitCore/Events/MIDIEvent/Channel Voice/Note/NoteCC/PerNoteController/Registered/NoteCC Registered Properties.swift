//
//  NoteCC Registered Properties.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.NoteCC.PerNoteController.Registered {
    /// Returns the controller number.
    @inlinable
    public var number: UInt8 {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .modWheel                     : 1
        case .breath                       : 2
        case .pitch7_25                    : 3
        case .volume                       : 7
        case .balance                      : 8
        case .pan                          : 10
        case .expression                   : 11
        case .soundCtrl1_soundVariation    : 70
        case .soundCtrl2_timbreIntensity   : 71
        case .soundCtrl3_releaseTime       : 72
        case .soundCtrl4_attackTime        : 73
        case .soundCtrl5_brightness        : 74
        case .soundCtrl6_decayTime         : 75
        case .soundCtrl7_vibratoRate       : 76
        case .soundCtrl8_vibratoDepth      : 77
        case .soundCtrl9_vibratoDelay      : 78
        case .soundCtrl10_defaultUndefined : 79
        case .effects1Depth_reverbSendLevel: 91
        case .effects2Depth                : 92
        case .effects3Depth_chorusSendLevel: 93
        case .effects4Depth                : 94
        case .effects5Depth                : 95
        case let .undefined(cc)            : cc.controller
        }
        // swiftformat:enable spacearoundoperators
    }
}
