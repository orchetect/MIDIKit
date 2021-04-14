//
//  CoreMIDI.m
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-04-13.
//

#include "CoreMIDI.h"

NS_ASSUME_NONNULL_BEGIN

/// C method to iterate on `MIDIPacket`s within a `MIDIPacketList`
void CPacketListIterate(const MIDIPacketList *midiPacketList,
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

NS_ASSUME_NONNULL_END
