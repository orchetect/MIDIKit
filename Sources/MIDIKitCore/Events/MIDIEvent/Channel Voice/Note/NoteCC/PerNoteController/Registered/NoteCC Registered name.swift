//
//  NoteCC Registered name.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.NoteCC.PerNoteController.Registered {
    /// Returns the controller name as a human-readable String.
    public var name: String {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .modWheel                      : "Mod Wheel"
        case .breath                        : "Breath Controller"
        case .pitch7_25                     : "Pitch 7.25"
        case .volume                        : "Volume"
        case .balance                       : "Balance"
        case .pan                           : "Pan"
        case .expression                    : "Expression"
        case .soundCtrl1_soundVariation     : "Sound Control 1 - Sound Variation"
        case .soundCtrl2_timbreIntensity    : "Sound Control 2 - Timbre Intensity"
        case .soundCtrl3_releaseTime        : "Sound Control 3 - Release Time"
        case .soundCtrl4_attackTime         : "Sound Control 4 - Attack Time"
        case .soundCtrl5_brightness         : "Sound Control 5 - Brightness"
        case .soundCtrl6_decayTime          : "Sound Control 6 - Decay Time"
        case .soundCtrl7_vibratoRate        : "Sound Control 7 - Vibrato Rate"
        case .soundCtrl8_vibratoDepth       : "Sound Control 8 - Vibrato Depth"
        case .soundCtrl9_vibratoDelay       : "Sound Control 9 - Vibrato Delay"
        case .soundCtrl10_defaultUndefined  : "Sound Control 10 - Undefined"
        case .effects1Depth_reverbSendLevel : "Effects 1 Depth - Reverb Send Level"
        case .effects2Depth                 : "Effects 2 Depth"
        case .effects3Depth_chorusSendLevel : "Effects 3 Depth - Chorus Send Level"
        case .effects4Depth                 : "Effects 4 Depth"
        case .effects5Depth                 : "Effects 5 Depth"
        case let .undefined(cc)             : cc.name
        }
        // swiftformat:enable spacearoundoperators
    }
}
