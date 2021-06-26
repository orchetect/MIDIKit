//
//  CoreMIDI.h
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

extern
void CMIDIPacketListIterate(const MIDIPacketList *midiPacketList,
							void (NS_NOESCAPE ^closure)(const MIDIPacket *midiPacket));

extern
void CMIDIEventListIterate(const MIDIEventList *midiEventList,
						   void (NS_NOESCAPE ^closure)(const MIDIEventPacket *midiEventPacket));

extern
OSStatus CMIDIThruConnectionCreateNonPersistent(CFDataRef inConnectionParams,
												MIDIThruConnectionRef *outConnection);
