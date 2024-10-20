//
//  CC Controller allCases.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.CC.Controller: CaseIterable {
    public typealias AllCases = [Self]
    
    public static let allCases: [Self] = [
        .bankSelect,                    //   0
        .modWheel,                      //   1
        .breath,                        //   2
        .undefined(.cc3),               //   3
        .footController,                //   4
        .portamentoTime,                //   5
        .dataEntry,                     //   6
        .volume,                        //   7
        .balance,                       //   8
        .undefined(.cc9),               //   9
        .pan,                           //  10
        .expression,                    //  11
        .effectControl1,                //  12
        .effectControl2,                //  13
        .undefined(.cc14),              //  14
        .undefined(.cc15),              //  15
        .generalPurpose1,               //  16
        .generalPurpose2,               //  17
        .generalPurpose3,               //  18
        .generalPurpose4,               //  19
        .undefined(.cc20),              //  20
        .undefined(.cc21),              //  21
        .undefined(.cc22),              //  22
        .undefined(.cc23),              //  23
        .undefined(.cc24),              //  24
        .undefined(.cc25),              //  25
        .undefined(.cc26),              //  26
        .undefined(.cc27),              //  27
        .undefined(.cc28),              //  28
        .undefined(.cc29),              //  29
        .undefined(.cc30),              //  30
        .undefined(.cc31),              //  31
        .lsb(for: .bankSelect),         //  32
        .lsb(for: .modWheel),           //  33
        .lsb(for: .breath),             //  34
        .lsb(for: .undefined(.cc3)),    //  35
        .lsb(for: .footController),     //  36
        .lsb(for: .portamentoTime),     //  37
        .lsb(for: .dataEntry),          //  38
        .lsb(for: .channelVolume),      //  39
        .lsb(for: .balance),            //  40
        .lsb(for: .undefined(.cc9)),    //  41
        .lsb(for: .pan),                //  42
        .lsb(for: .expression),         //  43
        .lsb(for: .effectControl1),     //  44
        .lsb(for: .effectControl2),     //  45
        .lsb(for: .undefined(.cc14)),   //  46
        .lsb(for: .undefined(.cc15)),   //  47
        .lsb(for: .generalPurpose1),    //  48
        .lsb(for: .generalPurpose2),    //  49
        .lsb(for: .generalPurpose3),    //  50
        .lsb(for: .generalPurpose4),    //  51
        .lsb(for: .undefined(.cc20)),   //  52
        .lsb(for: .undefined(.cc21)),   //  53
        .lsb(for: .undefined(.cc22)),   //  54
        .lsb(for: .undefined(.cc23)),   //  55
        .lsb(for: .undefined(.cc24)),   //  56
        .lsb(for: .undefined(.cc25)),   //  57
        .lsb(for: .undefined(.cc26)),   //  58
        .lsb(for: .undefined(.cc27)),   //  59
        .lsb(for: .undefined(.cc28)),   //  60
        .lsb(for: .undefined(.cc29)),   //  61
        .lsb(for: .undefined(.cc30)),   //  62
        .lsb(for: .undefined(.cc31)),   //  63
        .sustainPedal,                  //  64
        .portamento,                    //  65
        .sostenutoPedal,                //  66
        .softPedal,                     //  67
        .legatoFootswitch,              //  68
        .hold2,                         //  69
        .soundCtrl1_soundVariation,     //  70
        .soundCtrl2_timbreIntensity,    //  71
        .soundCtrl3_releaseTime,        //  72
        .soundCtrl4_attackTime,         //  73
        .soundCtrl5_brightness,         //  74
        .soundCtrl6_decayTime,          //  75
        .soundCtrl7_vibratoRate,        //  76
        .soundCtrl8_vibratoDepth,       //  77
        .soundCtrl9_vibratoDelay,       //  78
        .soundCtrl10_defaultUndefined,  //  79
        .generalPurpose5,               //  80
        .generalPurpose6,               //  81
        .generalPurpose7,               //  82
        .generalPurpose8,               //  83
        .portamentoControl,             //  84
        .undefined(.cc85),              //  85
        .undefined(.cc86),              //  86
        .undefined(.cc87),              //  87
        .highResolutionVelocityPrefix,  //  88
        .undefined(.cc89),              //  89
        .undefined(.cc90),              //  90
        .effects1Depth_reverbSendLevel, //  91
        .effects2Depth,                 //  92
        .effects3Depth_chorusSendLevel, //  93
        .effects4Depth,                 //  94
        .effects5Depth,                 //  95
        .dataIncrement,                 //  96
        .dataDecrement,                 //  97
        .nrpnLSB,                       //  98
        .nrpnMSB,                       //  99
        .rpnLSB,                        // 100
        .rpnMSB,                        // 101
        .undefined(.cc102),             // 102
        .undefined(.cc103),             // 103
        .undefined(.cc104),             // 104
        .undefined(.cc105),             // 105
        .undefined(.cc106),             // 106
        .undefined(.cc107),             // 107
        .undefined(.cc108),             // 108
        .undefined(.cc109),             // 109
        .undefined(.cc110),             // 110
        .undefined(.cc111),             // 111
        .undefined(.cc112),             // 112
        .undefined(.cc113),             // 113
        .undefined(.cc114),             // 114
        .undefined(.cc115),             // 115
        .undefined(.cc116),             // 116
        .undefined(.cc117),             // 117
        .undefined(.cc118),             // 118
        .undefined(.cc119),             // 119
        .mode(.allSoundOff),            // 120
        .mode(.resetAllControllers),    // 121
        .mode(.localControl),           // 122
        .mode(.allNotesOff),            // 123
        .mode(.omniModeOff),            // 124
        .mode(.omniModeOn),             // 125
        .mode(.monoModeOn),             // 126
        .mode(.polyModeOn)              // 127
    ]
}
