//
//  CoreMIDI.m
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#include "CoreMIDI.h"

NS_ASSUME_NONNULL_BEGIN

/// C method to iterate on CoreMIDI MIDIPackets within a MIDIPacketList
void CMIDIPacketListIterate(const MIDIPacketList *midiPacketList,
							void (NS_NOESCAPE ^closure)(const MIDIPacket *midiPacket))
{
	
	if (midiPacketList->numPackets == 0) {
		return;
	}
	
	const MIDIPacket *midiPacket = &midiPacketList->packet[0];
	
	for (UInt32 idx = 0; idx < midiPacketList->numPackets; idx++) {
		closure(midiPacket);
		midiPacket = MIDIPacketNext(midiPacket);
	}
	
}

/// C method to iterate on CoreMIDI MIDIEventPackets within a MIDIEventList
void CMIDIEventListIterate(const MIDIEventList *midiEventList,
						   void (NS_NOESCAPE ^closure)(const MIDIEventPacket *midiEventPacket))
{
	
	if (midiEventList->numPackets == 0) {
		return;
	}
	
	const MIDIEventPacket *midiEventPacket = &midiEventList->packet[0];
	
	for (UInt32 idx = 0; idx < midiEventList->numPackets; idx++) {
		closure(midiEventPacket);
		midiEventPacket = MIDIEventPacketNext(midiEventPacket);
	}
	
}

/// C method to invoke CoreMIDI MIDIThruConnectionCreate to create a non-persistent MIDI play-thru connection.
///
/// There is a bug in CoreMIDI's Swift bridging whereby passing nil into MIDIThruConnectionCreate fails to create a non-persistent thru connection and actually creates a persistent thru connection, despite what the CoreMIDI documentation states.
/// 
/// This is a C function that wraps this method to accomplish this instead.
OSStatus CMIDIThruConnectionCreateNonPersistent(CFDataRef inConnectionParams,
												MIDIThruConnectionRef *outConnection)
{
	
	return MIDIThruConnectionCreate(NULL, inConnectionParams, outConnection);
	
}

NS_ASSUME_NONNULL_END
