//
//  CoreMIDI.m
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#include "CoreMIDI.h"

NS_ASSUME_NONNULL_BEGIN

/// Obj-C method to invoke Core MIDI MIDIThruConnectionCreate to create a non-persistent MIDI play-thru connection.
///
/// There is a bug in Core MIDI's Swift bridging whereby passing nil into MIDIThruConnectionCreate fails to create a non-persistent thru connection and actually creates a persistent thru connection, despite what the Core MIDI documentation states.
/// 
/// This is an Obj-C function that wraps this method to accomplish this instead.
OSStatus CMIDIThruConnectionCreateNonPersistent(CFDataRef inConnectionParams,
                                                MIDIThruConnectionRef *outConnection)
{
    
    return MIDIThruConnectionCreate(NULL, inConnectionParams, outConnection);
    
}

NS_ASSUME_NONNULL_END
