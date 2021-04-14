//
//  CoreMIDI.h
//  MIDIKit
//
//  Created by Steffan Andrews on 2021-04-13.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

extern void CPacketListIterate(const MIDIPacketList *midiPacketList,
							   void (NS_NOESCAPE ^closure)(const MIDIPacket *midiPacket));
