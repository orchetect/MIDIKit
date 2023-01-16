//
//  NoteCC Registered name.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.NoteCC.PerNoteController.Registered {
    /// Returns the controller name as a human-readable String.
    public var name: String {
        // swiftformat:disable spacearoundoperators
        switch self {
        case .modWheel                      : return "Mod Wheel"
        case .breath                        : return "Breath Controller"
        case .pitch7_25                     : return "Pitch 7.25"
    
        case .volume                        : return "Volume"
        case .balance                       : return "Balance"
    
        case .pan                           : return "Pan"
        case .expression                    : return "Expression"
    
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
    
        case .effects1Depth_reverbSendLevel : return "Effects 1 Depth - Reverb Send Level"
        case .effects2Depth                 : return "Effects 2 Depth"
        case .effects3Depth_chorusSendLevel : return "Effects 3 Depth - Chorus Send Level"
        case .effects4Depth                 : return "Effects 4 Depth"
        case .effects5Depth                 : return "Effects 5 Depth"
    
        case let .undefined(cc)             : return cc.name
        }
        // swiftformat:enable spacearoundoperators
    }
}
