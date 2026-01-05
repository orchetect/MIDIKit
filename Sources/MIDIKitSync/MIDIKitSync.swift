//
//  MIDIKitSync.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@_documentation(visibility: internal)
@_exported import MIDIKitCore

@_documentation(visibility: internal)
@_exported import SwiftTimecodeCore

// MARK: - MTC

// Protocol information:
// https://en.wikipedia.org/wiki/MIDI_timecode
//
// "MTC allows the synchronization of a sequencer or DAW with other devices that can synchronize to
// MTC"
//
// "MIDI time code (MTC) embeds the same timing information as standard SMPTE timecode as a series
// of small 'quarter-frame' MIDI messages. There is no provision for the user bits in the standard
// MIDI time code messages, and SysEx messages are used to carry this information instead. The
// quarter-frame messages are transmitted in a sequence of eight messages, thus a complete timecode
// value is specified every two frames. If the MIDI data stream is running close to capacity, the
// MTC data may arrive a little behind schedule which has the effect of introducing a small amount
// of jitter. In order to avoid this it is ideal to use a completely separate MIDI port for MTC
// data. Larger full-frame messages, which encapsulate a frame worth of timecode in a single
// message, are used to locate to a time while timecode is not running."
//
// "Unlike standard SMPTE timecode, MIDI timecode's quarter-frame and full-frame messages carry a
// two-bit flag value that identifies the rate of the timecode, specifying it as either:
//
// - 24 frame/s (standard rate for film work)
// - 25 frame/s (standard rate for PAL video)
// - 29.97 frame/s (drop-frame timecode for NTSC video)
// - 30 frame/s (non-drop timecode for NTSC video)"
//
// It is important to note that not all DAWs implement all features of MTC. For example, Pro Tools
// can generate or chase MTC quarter frames, but does not transmit or receive full-frame messages
// - meaning Pro Tools will not locate to new timecodes when the MTC stream is not running. However,
// some other DAWs will.
//
// It is also important to note that MTC communication from source to target must be stable and
// low-latency/low-jitter. This means that using physical MIDI cables, USB MIDI interfaces, orusing
// virtual software-based MIDI ports, such as macOS's IAC (inter-app-communication) ports is ideal.
// If sending MTC data over a network, it must be a physically wired network (copper ethernet LAN)
// and not wireless protocols such as Wi-Fi or Bluetooth/BTLE. Wireless protocols introduce too much
// latency and jitter and will not sustain reliable MTC timing.
