//
//  CoreMIDI.h
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

extern
OSStatus CMIDIThruConnectionCreateNonPersistent(CFDataRef inConnectionParams,
                                                MIDIThruConnectionRef *outConnection);
