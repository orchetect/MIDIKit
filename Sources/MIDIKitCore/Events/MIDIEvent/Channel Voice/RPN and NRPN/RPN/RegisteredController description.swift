//
//  RegisteredController description.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.RegisteredController: CustomStringConvertible {
    public var description: String {
        switch self {
        // MIDI Spec
    
        case let .pitchBendSensitivity(semitones, cents):
            return "pitchBendSensitivity(semitones: \(semitones), cents: \(cents))"
    
        case let .channelFineTuning(value):
            return "channelFineTuning(\(value))"
    
        case let .channelCoarseTuning(value):
            return "channelCoarseTuning(\(value))"
    
        case let .tuningProgramChange(number):
            return "tuningProgramChange(zero-based: \(number))"
    
        case let .tuningBankSelect(number):
            return "tuningBankSelect(zero-based: \(number))"
    
        case let .modulationDepthRange(dataEntryMSB, dataEntryLSB):
            let msb = dataEntryMSB != nil ? "\(dataEntryMSB!)" : "nil (0)"
            let lsb = dataEntryLSB != nil ? "\(dataEntryLSB!)" : "nil (0)"
            return "modulationDepthRange(dataMSB: \(msb), dataLSB: \(lsb))"
    
        case let .mpeConfigurationMessage(dataEntryMSB, dataEntryLSB):
            let msb = dataEntryMSB != nil ? "\(dataEntryMSB!)" : "nil (0)"
            let lsb = dataEntryLSB != nil ? "\(dataEntryLSB!)" : "nil (0)"
            return "mpeConfigurationMessage(dataMSB: \(msb), dataLSB: \(lsb))"
    
        case .null:
            return "null"
    
        case let .raw(
            parameter: parameter,
            dataEntryMSB: dataEntryMSB,
            dataEntryLSB: dataEntryLSB
        ):
            let msb = dataEntryMSB != nil ? "\(dataEntryMSB!)" : "nil (0)"
            let lsb = dataEntryLSB != nil ? "\(dataEntryLSB!)" : "nil (0)"
            return "raw(param: \(parameter), dataMSB: \(msb), dataLSB: \(lsb))"
    
        // 3D Sound Controllers
    
        case let .threeDimensionalAzimuthAngle(dataEntryMSB, dataEntryLSB):
            return "threeDimensionalAzimuthAngle(dataMSB: \(dataEntryMSB), dataLSB: \(dataEntryLSB))"
    
        case let .threeDimensionalElevationAngle(dataEntryMSB, dataEntryLSB):
            return "threeDimensionalElevationAngle(dataMSB: \(dataEntryMSB), dataLSB: \(dataEntryLSB))"
    
        case let .threeDimensionalGain(dataEntryMSB, dataEntryLSB):
            return "threeDimensionalGain(dataMSB: \(dataEntryMSB), dataLSB: \(dataEntryLSB))"
    
        case let .threeDimensionalDistanceRatio(dataEntryMSB, dataEntryLSB):
            return "threeDimensionalDistanceRatio(dataMSB: \(dataEntryMSB), dataLSB: \(dataEntryLSB))"
            
        case let .threeDimensionalMaximumDistance(dataEntryMSB, dataEntryLSB):
            return "threeDimensionalMaximumDistance(dataMSB: \(dataEntryMSB), dataLSB: \(dataEntryLSB))"
    
        case let .threeDimensionalGainAtMaximumDistance(dataEntryMSB, dataEntryLSB):
            return "threeDimensionalGainAtMaximumDistance(dataMSB: \(dataEntryMSB), dataLSB: \(dataEntryLSB))"
    
        case let .threeDimensionalReferenceDistanceRatio(dataEntryMSB, dataEntryLSB):
            return "threeDimensionalReferenceDistanceRatio(dataMSB: \(dataEntryMSB), dataLSB: \(dataEntryLSB))"
    
        case let .threeDimensionalPanSpreadAngle(dataEntryMSB, dataEntryLSB):
            return "threeDimensionalPanSpreadAngle(dataMSB: \(dataEntryMSB), dataLSB: \(dataEntryLSB))"
    
        case let .threeDimensionalRollAngle(dataEntryMSB, dataEntryLSB):
            return "threeDimensionalRollAngle(dataMSB: \(dataEntryMSB), dataLSB: \(dataEntryLSB))"
        }
    }
}
