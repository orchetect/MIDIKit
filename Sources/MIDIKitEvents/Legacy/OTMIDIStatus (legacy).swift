//
//  OTMIDIStatus (legacy).swift
//  MIDIKit (legacy)
//
//  Derived from AudioKit, 2016.

/// Status nibble of a MIDI message (X in 0xX0).
/// **(⚠️ Legacy: will be replaced in a future version of MIDIKit.)**
public enum OTMIDIStatus: UInt8 {
	
	/// Note off is something resembling a keyboard key release
	case noteOff = 0x8
	
	/// Note on is triggered when a new note is created, or a keyboard key press
	case noteOn = 0x9
	
	/// Polyphonic aftertouch is a rare MIDI control on controllers in which every key has separate touch sensing
	case polyphonicAftertouch = 0xA
	
	/// Controller changes represent a wide range of control types including volume, expression, modulation and a host of unnamed controllers with numbers
	case controllerChange = 0xB
	
	/// Program change messages are associated with changing the basic character of the sound preset
	case programChange = 0xC
	
	/// A single aftertouch for all notes on a given channel (most common aftertouch type in keyboards)
	case channelAftertouch = 0xD
	
	/// A pitch wheel is a common keyboard control that allow for a pitch to be bent up or down a given number of semitones
	case pitchWheel = 0xE
	
	/// System commands differ from system to system
	case systemCommand = 0xF
	
	/// Returns whether the status type implicitly has a channel number associated with the status byte.
	public var hasAssociatedChannel: Bool {
		switch self {
		case .systemCommand: return false
		default: return true
		}
	}
	
}
