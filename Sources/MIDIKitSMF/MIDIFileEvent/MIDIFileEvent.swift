//
//  MIDIFileEvent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitCore

/// MIDI File Track Event.
public enum MIDIFileEvent: Equatable, Hashable {
    // ------------------------------------
    // NOTE: When revising these documentation blocks, they are duplicated in:
    //   - MIDIFileEvent enum case (`case keySignature(delta:event:)`, etc.)
    //   - MIDIFileEvent static constructors (`static func keySignature(...)`, etc.)
    //   - MIDIFileEvent concrete payload structs (`KeySignature`, etc.)
    //   - DocC documentation for each MIDIFileEvent type
    // ------------------------------------
    
    /// Channel Voice Message: Control Change (CC)
    case cc(delta: DeltaTime, event: CC)
    
    /// MIDI Channel Prefix event.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > The MIDI channel (`0 ... 15`) contained in this event may be used to associate a MIDI
    /// > channel with all events which follow, including System Exclusive and meta-events. This
    /// > channel is "effective" until the next normal MIDI event (which contains a channel) or the
    /// > next MIDI Channel Prefix meta-event. If MIDI channels refer to "tracks", this message may
    /// > help jam several tracks into a format 0 file, keeping their non-MIDI data associated with
    /// > a track. This capability is also present in Yamaha's ESEQ file format.
    case channelPrefix(delta: DeltaTime, event: ChannelPrefix)
    
    /// Key Signature event.
    ///
    /// For a format 1 MIDI file, Key Signature Meta events should only occur within the first
    /// `MTrk` chunk.
    ///
    /// If there are no key signature events in a MIDI file, C major is assumed.
    case keySignature(delta: DeltaTime, event: KeySignature)
    
    /// Channel Voice Message: Note Off
    case noteOff(delta: DeltaTime, event: NoteOff)
    
    /// Channel Voice Message: Note On
    case noteOn(delta: DeltaTime, event: NoteOn)
    
    /// Channel Voice Message: Note Pressure (Polyphonic Aftertouch)
    ///
    /// Also known as:
    /// - Pro Tools: "Polyphonic Aftertouch"
    /// - Logic Pro: "Polyphonic Aftertouch"
    /// - Cubase: "Poly Pressure"
    case notePressure(delta: DeltaTime, event: NotePressure)
    
    /// Channel Voice Message: Pitch Bend
    case pitchBend(delta: DeltaTime, event: PitchBend)
    
    /// MIDI Port Prefix event.
    ///
    /// Specifies out of which MIDI Port (ie, buss) the MIDI events in the MIDI track go.
    /// The data byte is the port number, where 0 would be the first MIDI buss in the system.
    case portPrefix(delta: DeltaTime, event: PortPrefix)
    
    /// Channel Voice Message: Channel Pressure (Aftertouch)
    ///
    /// Also known as:
    /// - Pro Tools: "Mono Aftertouch"
    /// - Logic Pro: "Aftertouch"
    /// - Cubase: "Aftertouch"
    case pressure(delta: DeltaTime, event: Pressure)
    
    /// Channel Voice Message: Program Change
    ///
    /// > Note: When decoding, bank information is not decoded as part of the Program Change event
    /// > but will be decoded as individual CC messages. This may be addressed in a future release
    /// > of MIDIKit.
    case programChange(delta: DeltaTime, event: ProgramChange)
    
    /// Channel Voice Message: RPN (Registered Parameter Number),
    /// also referred to as Registered Controller in MIDI 2.0.
    case rpn(delta: DeltaTime, event: RPN)
    
    /// Channel Voice Message: NRPN (Non-Registered Parameter Number),
    /// also referred to as Assignable Controller in MIDI 2.0.
    case nrpn(delta: DeltaTime, event: NRPN)
    
    /// Sequence Number event.
    ///
    /// - For MIDI file type 0/1, this should only be on the first track. This is used to identify
    /// each track. If omitted, the sequences are numbered sequentially in the order the tracks
    /// appear.
    ///
    /// - For MIDI file type 2, each track can contain a sequence number event.
    case sequenceNumber(delta: DeltaTime, event: SequenceNumber)
    
    /// Sequencer-specific data.
    /// Typically begins with a 1 or 3 byte manufacturer ID, similar to SysEx.
    case sequencerSpecific(delta: DeltaTime, event: SequencerSpecific)
    
    /// Specify the SMPTE time at which the track is to start.
    /// This optional event, if present, should occur at the start of a track,
    /// at `time == 0`, and prior to any MIDI events.
    /// Defaults to `00:00:00:00 @ 24fps`.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > MIDI SMPTE Offset subframes (fractional frames) are always in 100ths of a frame, even in
    /// > SMPTE-based tracks which specify a different frame subdivision for delta-times.
    case smpteOffset(delta: DeltaTime, event: SMPTEOffset)
    
    /// System Exclusive: Manufacturer-specific (7-bit)
    case sysEx7(delta: DeltaTime, event: SysEx7)
    
    /// Universal System Exclusive (7-bit)
    ///
    /// Some standard Universal System Exclusive messages have been defined by the MIDI Spec. See
    /// the official MIDI 1.0 and 2.0 specs for details.
    ///
    /// - `deviceID` of `0x7F` indicates "All Devices".
    case universalSysEx7(delta: DeltaTime, event: UniversalSysEx7)
    
    /// Tempo event.
    /// For a format 1 MIDI file, Tempo events should only occur within the first `MTrk` chunk.
    /// If there are no tempo events in a MIDI file, 120 bpm is assumed.
    case tempo(delta: DeltaTime, event: Tempo)
    
    /// Text event.
    /// Includes copyright, marker, cue point, track/sequence name, instrument name, generic text,
    /// program name, device name, or lyric.
    ///
    /// Text is restricted to ASCII format only. If extended characters or encodings are used, it
    /// will be converted to ASCII lossily before encoding into the MIDI file.
    case text(delta: DeltaTime, event: Text)
    
    /// Time Signature event.
    /// For a format 1 MIDI file, Time Signature meta events should only occur within the first
    /// `MTrk` chunk.
    /// If there are no Time Signature events in a MIDI file, 4/4 is assumed.
    case timeSignature(delta: DeltaTime, event: TimeSignature)
    
    /// Unrecognized Meta Event.
    ///
    /// > Note: This is not designed to be instanced, but is instead a placeholder for unrecognized
    /// > or malformed data while parsing the contents of a MIDI file. In then allows for manual
    /// > parsing or introspection of the unrecognized data.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > All meta-events begin with `0xFF`, then have an event type byte (which is always less than
    /// > 128), and then have the length of the data stored as a variable-length quantity, and then
    /// > the data itself. If there is no data, the length is `0`. As with chunks, future
    /// > meta-events may be designed which may not be known to existing programs, so programs must
    /// > properly ignore meta-events which they do not recognize, and indeed, should expect to see
    /// > them.
    /// > Programs must never ignore the length of a meta-event which they do recognize, and they
    /// > shouldn't be surprised if it's bigger than they expected. If so, they must ignore
    /// > everything past what they know about. However, they must not add anything of their own to
    /// > the end of a meta-event.
    /// >
    /// > SysEx events and meta-events cancel any running status which was in effect. Running status
    /// > does not apply to and may not be used for these messages.
    case unrecognizedMeta(delta: DeltaTime, event: UnrecognizedMeta)
    
    /// XMF Patch Type Prefix event.
    ///
    /// > Standard MIDI File 1.0 Spec:
    /// >
    /// > XMF Type 0 and Type 1 files contain Standard MIDI Files (SMF). Each SMF Track in such XMF
    /// > files may be designated to use either standard General MIDI 1 or General MIDI 2
    /// > instruments supplied by the player, or custom DLS instruments supplied via the XMF file.
    /// > This document defines a new SMF Meta-Event to be used for this purpose.
    /// >
    /// > In a Type 0 or Type 1 XMF File, this meta-event specifies how to interpret subsequent
    /// > Program Change and Bank Select messages appearing in the same SMF Track: as General MIDI
    /// > 1, General MIDI 2, or DLS. In the absence of an initial XMF Patch Type Prefix Meta-Event,
    /// > General MIDI 1 (instrument set and system behavior) is chosen by default.
    /// >
    /// > In a Type 0 or Type 1 XMF File, no SMF Track may be reassigned to a different instrument
    /// > set (GM1, GM2, or DLS) at any time. Therefore, this meta-event should only be processed if
    /// > it appears as the first message in an SMF Track; if it appears anywhere else in an SMF
    /// > Track, it must be ignored.
    /// >
    /// > See [RP-032](https://www.midi.org/specifications/file-format-specifications/standard-midi-files/xmf-patch-type-prefix-meta-event).
    case xmfPatchTypePrefix(delta: DeltaTime, event: XMFPatchTypePrefix)
}

// Sendable must be applied in the same file as the struct for it to be compiler-checked.
extension MIDIFileEvent: Sendable { }
