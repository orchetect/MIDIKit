//
//  MTC Encoder FullFrameBehavior.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

extension MIDI.MTC.Encoder {
	
	/// Behavior determining when MTC Full-Frame MIDI messages should be generated.
	public enum FullFrameBehavior: Hashable, CaseIterable {
		
		/// Always trigger a MTC Full-Frame MIDI message, with no data thinning.
		case always
		
		/// Trigger a MTC Full-Frame MIDI message only if different from the last Full-Frame message formed by the `Encoder`. (default)
		///
		/// This is the default and best-practise option, since there is no benefit to the receiver of MTC messages to get duplicate Full-Frame messages and it is ideal to optimize the amount of unnecessary data transmitted.
		case ifDifferent
		
		/// Do not trigger a MTC Full-Frame MIDI message.
		///
		/// This is not a typical condition and may likely only be used for debugging. It is recommended to use `ifDifferent`.
		case never
		
	}
	
}
