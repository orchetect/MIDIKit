//
//  CoreMIDI.m
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#include "CoreMIDI.h"

NS_ASSUME_NONNULL_BEGIN

/// C method to iterate on Core MIDI MIDIPackets within a MIDIPacketList
void CMIDIPacketListIterate(const MIDIPacketList *midiPacketList,
                            void (NS_NOESCAPE ^closure)(const MIDIPacket *midiPacket))
{
    
    if (midiPacketList->numPackets == 0) {
        return;
    }
    
    const MIDIPacket *midiPacket = &midiPacketList->packet[0];
    
    // call closure for first packet
    closure(midiPacket);
    
    // call closure for subsequent packets, if they exist
    for (unsigned idx = 1; idx < midiPacketList->numPackets; idx++) {
        midiPacket = MIDIPacketNext(midiPacket);
        closure(midiPacket);
    }
    
}

/// C method to iterate on Core MIDI MIDIEventPackets within a MIDIEventList
void CMIDIEventListIterate(const MIDIEventList *midiEventList,
                           void (NS_NOESCAPE ^closure)(const MIDIEventPacket *midiEventPacket))
{
    
    if (midiEventList->numPackets == 0) {
        return;
    }
    
    const MIDIEventPacket *midiEventPacket = &midiEventList->packet[0];
    
    // call closure for first packet
    closure(midiEventPacket);
    
    // call closure for subsequent packets, if they exist
    for (unsigned idx = 1; idx < midiEventList->numPackets; idx++) {
        midiEventPacket = MIDIEventPacketNext(midiEventPacket);
        closure(midiEventPacket);
    }
    
}

/// C method to invoke Core MIDI MIDIThruConnectionCreate to create a non-persistent MIDI play-thru connection.
///
/// There is a bug in Core MIDI's Swift bridging whereby passing nil into MIDIThruConnectionCreate fails to create a non-persistent thru connection and actually creates a persistent thru connection, despite what the Core MIDI documentation states.
/// 
/// This is a C function that wraps this method to accomplish this instead.
OSStatus CMIDIThruConnectionCreateNonPersistent(CFDataRef inConnectionParams,
                                                MIDIThruConnectionRef *outConnection)
{
    
    return MIDIThruConnectionCreate(NULL, inConnectionParams, outConnection);
    
}

NS_ASSUME_NONNULL_END
