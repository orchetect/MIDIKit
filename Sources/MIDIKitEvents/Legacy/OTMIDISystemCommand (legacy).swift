//
//  OTMIDISystemCommand (legacy).swift
//  MIDIKit (legacy)
//
//  Derived from AudioKit, 2016.

/// MIDI System Command
/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
public enum OTMIDISystemCommand: UInt8 {
	
	/// System Exclusive
	case sysExStart = 0xF0
	
	/// Song Position
	case songPosition = 0xF2
	
	/// Song Selection
	case songSelect = 0xF3
	
	/// Bus Select (unofficial)
	case unofficialBusSelect = 0xF5
	
	/// Request Tune
	case tuneRequest = 0xF6
	
	/// End System Exclusive
	case sysExEnd = 0xF7
	
	/// Clock
	case clock = 0xF8
	
	/// Start
	case start = 0xFA
	
	/// Continue
	case `continue` = 0xFB
	
	/// Stop
	case stop = 0xFC
	
	/// Active Sensing
	case activeSensing = 0xFE
	
	/// System Reset
	case sysReset = 0xFF
	
}

extension OTMIDISystemCommand: CustomStringConvertible {
	
	public var description: String {
		
		switch self {
		case .sysExStart:			return "SysEx Start"
		case .songPosition:			return "Song Position"
		case .songSelect:			return "Song Select"
		case .unofficialBusSelect:	return "Bus Select (unofficial)"
		case .tuneRequest:			return "Request Tune"
		case .sysExEnd:				return "SysEx End"
		case .clock:				return "Clock"
		case .start:				return "Start"
		case .continue:				return "Continue"
		case .stop:					return "Stop"
		case .activeSensing:		return "Active Sensing"
		case .sysReset:				return "System Reset"
		}
		
	}
	
}
