//
//  CoreMIDI.h
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

extern void CPacketListIterate(const MIDIPacketList *midiPacketList,
							   void (NS_NOESCAPE ^closure)(const MIDIPacket *midiPacket));
