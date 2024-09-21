//
//  RegisteredController init.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.RegisteredController {
    /// Initialize an enum case from the controller number.
    /// If a case matching the param bytes is not found, the
    /// ``MIDIEvent/RegisteredController/raw(parameter:dataEntryMSB:dataEntryLSB:)`` case will be
    /// returned.
    public init(
        parameter: UInt7Pair,
        data: (msb: UInt7?, lsb: UInt7?)
    ) {
        func dataPair() -> UInt7Pair {
            UInt7Pair(msb: data.msb ?? 0, lsb: data.lsb ?? 0)
        }
        func data14Bit() -> UInt14 {
            UInt14(uInt7Pair: dataPair())
        }
        
        switch (parameter.msb, parameter.lsb) {
        // MIDI Spec
            
        case (0x00, 0x00):
            let dataPair = dataPair()
            self = .pitchBendSensitivity(semitones: dataPair.msb, cents: dataPair.lsb)
            
        case (0x00, 0x01):
            self = .channelFineTuning(data14Bit())
        
        case (0x00, 0x02):
            self = .channelCoarseTuning(data.msb ?? 0x00)
            
        case (0x00, 0x03):
            self = .tuningProgramChange(number: data.msb ?? 0x00)
            
        case (0x00, 0x04):
            self = .tuningBankSelect(number: data.msb ?? 0x00)
            
        case (0x00, 0x05):
            self = .modulationDepthRange(dataEntryMSB: data.msb, dataEntryLSB: data.lsb)
            
        case (0x00, 0x06):
            self = .mpeConfigurationMessage(dataEntryMSB: data.msb, dataEntryLSB: data.lsb)
            
        case (0x7F, 0x7F):
            self = .null // ignore data entry bytes
            
        // 3D Sound Controllers
            
        case (0x3D, 0x00):
            let dataPair = dataPair()
            self = .threeDimensionalAzimuthAngle(
                dataEntryMSB: dataPair.msb,
                dataEntryLSB: dataPair.lsb
            )
            
        case (0x3D, 0x01):
            let dataPair = dataPair()
            self = .threeDimensionalElevationAngle(
                dataEntryMSB: dataPair.msb,
                dataEntryLSB: dataPair.lsb
            )
            
        case (0x3D, 0x02):
            let dataPair = dataPair()
            self = .threeDimensionalGain(dataEntryMSB: dataPair.msb, dataEntryLSB: dataPair.lsb)
            
        case (0x3D, 0x03):
            let dataPair = dataPair()
            self = .threeDimensionalDistanceRatio(
                dataEntryMSB: dataPair.msb,
                dataEntryLSB: dataPair.lsb
            )
            
        case (0x3D, 0x04):
            let dataPair = dataPair()
            self = .threeDimensionalMaximumDistance(
                dataEntryMSB: dataPair.msb,
                dataEntryLSB: dataPair.lsb
            )
            
        case (0x3D, 0x05):
            let dataPair = dataPair()
            self = .threeDimensionalGainAtMaximumDistance(
                dataEntryMSB: dataPair.msb,
                dataEntryLSB: dataPair.lsb
            )
            
        case (0x3D, 0x06):
            let dataPair = dataPair()
            self = .threeDimensionalReferenceDistanceRatio(
                dataEntryMSB: dataPair.msb,
                dataEntryLSB: dataPair.lsb
            )
            
        case (0x3D, 0x07):
            let dataPair = dataPair()
            self = .threeDimensionalPanSpreadAngle(
                dataEntryMSB: dataPair.msb,
                dataEntryLSB: dataPair.lsb
            )
            
        case (0x3D, 0x08):
            let dataPair = dataPair()
            self = .threeDimensionalRollAngle(
                dataEntryMSB: dataPair.msb,
                dataEntryLSB: dataPair.lsb
            )
            
        default:
            self = .raw(
                parameter: parameter,
                dataEntryMSB: data.msb,
                dataEntryLSB: data.lsb
            )
        }
    }
}
