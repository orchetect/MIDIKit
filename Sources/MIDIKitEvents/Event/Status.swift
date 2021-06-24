//
//  Status.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import MIDIKitCommon

extension MIDI.Event {
	
	/// Status nibble of a MIDI message (X in 0xX0)
	public enum Status: MIDI.UInt4 {
		
		/// Note off
		case noteOff = 0x8
		/// Note on
		case noteOn = 0x9
		/// Polyphonic aftertouch
		case polyphonicAftertouch = 0xA
		/// Controller changes
		case controllerChange = 0xB
		/// Program change message
		case programChange = 0xC
		/// A single aftertouch for all notes on a given channel (most common aftertouch type in keyboards)
		case channelAftertouch = 0xD
		/// A pitch wheel, also known as pitch bend
		case pitchWheel = 0xE
		/// System command
		case systemCommand = 0xF
		
		/// Returns true if the status type implicitly has a channel number associated with the status byte
		public var hasAssociatedChannel: Bool {
			switch self {
			case .systemCommand: return false
			default: return true
			}
		}
		
	}
	
}
