//
//  CC Controller init.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.Event.CC.Controller {
    /// MIDI Control Change Controller
    /// (MIDI 1.0 / MIDI 2.0)
    ///
    /// Initialize an enum case from the controller number.
    public init(number: MIDI.UInt7) {
        switch number {
        case   0: self = .bankSelect
        case   1: self = .modWheel
        case   2: self = .breath
        case   3: self = .undefined(.cc3)
        case   4: self = .footController
        case   5: self = .portamentoTime
        case   6: self = .dataEntry
        case   7: self = .volume
        case   8: self = .balance
        case   9: self = .undefined(.cc9)
        case  10: self = .pan
        case  11: self = .expression
        case  12: self = .effectControl1
        case  13: self = .effectControl2
        case  14: self = .undefined(.cc14)
        case  15: self = .undefined(.cc15)
        case  16: self = .generalPurpose1
        case  17: self = .generalPurpose2
        case  18: self = .generalPurpose3
        case  19: self = .generalPurpose4
        case  20: self = .undefined(.cc20)
        case  21: self = .undefined(.cc21)
        case  22: self = .undefined(.cc22)
        case  23: self = .undefined(.cc23)
        case  24: self = .undefined(.cc24)
        case  25: self = .undefined(.cc25)
        case  26: self = .undefined(.cc26)
        case  27: self = .undefined(.cc27)
        case  28: self = .undefined(.cc28)
        case  29: self = .undefined(.cc29)
        case  30: self = .undefined(.cc30)
        case  31: self = .undefined(.cc31)
        case  32: self = .lsb(for: .bankSelect)
        case  33: self = .lsb(for: .modWheel)
        case  34: self = .lsb(for: .breath)
        case  35: self = .lsb(for: .undefined(.cc3))
        case  36: self = .lsb(for: .footController)
        case  37: self = .lsb(for: .portamentoTime)
        case  38: self = .lsb(for: .dataEntry)
        case  39: self = .lsb(for: .channelVolume)
        case  40: self = .lsb(for: .balance)
        case  41: self = .lsb(for: .undefined(.cc9))
        case  42: self = .lsb(for: .pan)
        case  43: self = .lsb(for: .expression)
        case  44: self = .lsb(for: .effectControl1)
        case  45: self = .lsb(for: .effectControl2)
        case  46: self = .lsb(for: .undefined(.cc14))
        case  47: self = .lsb(for: .undefined(.cc15))
        case  48: self = .lsb(for: .generalPurpose1)
        case  49: self = .lsb(for: .generalPurpose2)
        case  50: self = .lsb(for: .generalPurpose3)
        case  51: self = .lsb(for: .generalPurpose4)
        case  52: self = .lsb(for: .undefined(.cc20))
        case  53: self = .lsb(for: .undefined(.cc21))
        case  54: self = .lsb(for: .undefined(.cc22))
        case  55: self = .lsb(for: .undefined(.cc23))
        case  56: self = .lsb(for: .undefined(.cc24))
        case  57: self = .lsb(for: .undefined(.cc25))
        case  58: self = .lsb(for: .undefined(.cc26))
        case  59: self = .lsb(for: .undefined(.cc27))
        case  60: self = .lsb(for: .undefined(.cc28))
        case  61: self = .lsb(for: .undefined(.cc29))
        case  62: self = .lsb(for: .undefined(.cc30))
        case  63: self = .lsb(for: .undefined(.cc31))
        case  64: self = .sustainPedal
        case  65: self = .portamento
        case  66: self = .sostenutoPedal
        case  67: self = .softPedal
        case  68: self = .legatoFootswitch
        case  69: self = .hold2
        case  70: self = .soundCtrl1_soundVariation
        case  71: self = .soundCtrl2_timbreIntensity
        case  72: self = .soundCtrl3_releaseTime
        case  73: self = .soundCtrl4_attackTime
        case  74: self = .soundCtrl5_brightness
        case  75: self = .soundCtrl6_decayTime
        case  76: self = .soundCtrl7_vibratoRate
        case  77: self = .soundCtrl8_vibratoDepth
        case  78: self = .soundCtrl9_vibratoDelay
        case  79: self = .soundCtrl10_defaultUndefined
        case  80: self = .generalPurpose5
        case  81: self = .generalPurpose6
        case  82: self = .generalPurpose7
        case  83: self = .generalPurpose8
        case  84: self = .portamentoControl
        case  85: self = .undefined(.cc85)
        case  86: self = .undefined(.cc86)
        case  87: self = .undefined(.cc87)
        case  88: self = .highResolutionVelocityPrefix
        case  89: self = .undefined(.cc89)
        case  90: self = .undefined(.cc90)
        case  91: self = .effects1Depth_reverbSendLevel
        case  92: self = .effects2Depth
        case  93: self = .effects3Depth_chorusSendLevel
        case  94: self = .effects4Depth
        case  95: self = .effects5Depth
        case  96: self = .dataIncrement
        case  97: self = .dataDecrement
        case  98: self = .nrpnLSB
        case  99: self = .nrpnMSB
        case 100: self = .rpnLSB
        case 101: self = .rpnMSB
        case 102: self = .undefined(.cc102)
        case 103: self = .undefined(.cc103)
        case 104: self = .undefined(.cc104)
        case 105: self = .undefined(.cc105)
        case 106: self = .undefined(.cc106)
        case 107: self = .undefined(.cc107)
        case 108: self = .undefined(.cc108)
        case 109: self = .undefined(.cc109)
        case 110: self = .undefined(.cc110)
        case 111: self = .undefined(.cc111)
        case 112: self = .undefined(.cc112)
        case 113: self = .undefined(.cc113)
        case 114: self = .undefined(.cc114)
        case 115: self = .undefined(.cc115)
        case 116: self = .undefined(.cc116)
        case 117: self = .undefined(.cc117)
        case 118: self = .undefined(.cc118)
        case 119: self = .undefined(.cc119)
        case 120: self = .mode(.allSoundOff)
        case 121: self = .mode(.resetAllControllers)
        case 122: self = .mode(.localControl)
        case 123: self = .mode(.allNotesOff)
        case 124: self = .mode(.omniModeOff)
        case 125: self = .mode(.omniModeOn)
        case 126: self = .mode(.monoModeOn)
        case 127: self = .mode(.polyModeOn)
            
        default:
            // should never happen since the switch case covers all 128 values of MIDI.UInt7
            assertionFailure("Unhandled MIDI CC controller number: \(number).")
            self = .modWheel
        }
    }
}
