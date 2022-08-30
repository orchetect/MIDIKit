# Event Filters

## Table of Contents

- [Channel Voice](#Channel-Voice)
- [System Common](#System-Common)
- [System Exclusive](#System-Exclusive)
- [System Real-Time](#System-Real-Time)
- [UMP Group](#UMP-Group) (MIDI 2.0 Only)

## Summary

Filters are available as category methods on `[` ``MIDIEvent`` `]`.

For example:

```swift
let events: [MIDIEvent] = [ ... ]

let onlyChannel0Events = events.filter(chanVoice: .onlyChannel(0))
```

Filters may be chained easily:

```swift
// - removes Active Sensing,
// - removes all channel voice except CC 1, 11, or 64 events on "channel 1"
// - retains all other Sys Common, Sys Exclusive, and Sys Real-Time events
let filteredEvents = events
    .filter(sysRealTime: .dropTypes([.activeSensing]))
    .filter(chanVoice: .keepChannel(0x0))
    .filter(chanVoice: .keepCCs([1, 11, 64]))
```

## Channel Voice

There are three main categories of Channel Voice event filters:

- **only**: retains only events matching the criteria
- **keep**: keeps Channel Voice events matching the criteria, while all non-Channel Voice events are retained
- **drop**: drops Channel Voice events matching the criteria, while all non-Channel Voice events are retained

Channel Voice filter type(s) (``MIDIEvent/ChanVoiceType``) available:

- ``MIDIEvent/ChanVoiceType/noteOn``
- ``MIDIEvent/ChanVoiceType/noteOff``
- ``MIDIEvent/ChanVoiceType/noteCC`` (MIDI 2.0 Only)
- ``MIDIEvent/ChanVoiceType/notePitchBend`` (MIDI 2.0 Only)
- ``MIDIEvent/ChanVoiceType/notePressure``
- ``MIDIEvent/ChanVoiceType/noteManagement`` (MIDI 2.0 Only)
- ``MIDIEvent/ChanVoiceType/cc``
- ``MIDIEvent/ChanVoiceType/programChange``
- ``MIDIEvent/ChanVoiceType/pressure``
- ``MIDIEvent/ChanVoiceType/pitchBend``

### Only

`.filter(chanVoice: .only*)` methods:

- retains only Channel Voice events matching the criteria

```swift
// return only Channel Voice events
.filter(chanVoice: .only)
```

```swift
// return only certain event type(s)
.filter(chanVoice: .onlyType(.noteOn))
.filter(chanVoice: .onlyTypes([.noteOn, .noteOff]))
```

```swift
// return only events on certain channel(s)
.filter(chanVoice: .onlyChannel(0x0))
.filter(chanVoice: .onlyChannels([0x0, 0x1, 0x2]))
```

```swift
// return only CC events matching certain controller(s)
.filter(chanVoice: .onlyCC(1))
.filter(chanVoice: .onlyCCs([1, 11, 64]))
```

```swift
// return only note on/off events within certain note number range(s)
.filter(chanVoice: .onlyNotesInRange(40 ... 80))
.filter(chanVoice: .onlyNotesInRanges([20 ... 40, 60 ... 80]))
```

### Keep

`.filter(chanVoice: .keep*)` methods:

- retains Channel Voice events matching the given criteria
- retains all non-Channel Voice events

```swift
// retains Channel Voice events only with certain type(s),
// while retaining all non-Channel Voice events
.filter(chanVoice: .keepType(.noteOn))
.filter(chanVoice: .keepTypes([.noteOn, .noteOff]))
```

```swift
// retains Channel Voice events only with certain channel(s),
// while retaining all non-Channel Voice events
.filter(chanVoice: .keepChannel(0x0))
.filter(chanVoice: .keepChannels([0x0, 0x1, 0x2]))
```

```swift
// retains only CC events with certain controller(s),
// while retaining all non-Channel Voice events
.filter(chanVoice: .keepCC(1))
.filter(chanVoice: .keepCCs([1, 11, 64]))
```

```swift
// retains only note on/off events within certain note ranges(s),
// while retaining all non-Channel Voice events
.filter(chanVoice: .keepNotesInRange(40 ... 80))
.filter(chanVoice: .keepNotesInRanges([20 ... 40, 60 ... 80]))
```

### Drop

`.filter(chanVoice: .drop*)` methods:

- filter any Channel Voice events by the given criteria
- do not affect non-Channel Voice events

```swift
// drop all Channel Voice events,
// while retaining all non-Channel Voice events
.filter(chanVoice: .drop)
```

```swift
// drop Channel Voice events only with certain type(s),
// while retaining all non-Channel Voice events
.filter(chanVoice: .dropType(.noteOn))
.filter(chanVoice: .dropTypes([.noteOn, .noteOff]))
```

```swift
// drop Channel Voice events only with certain channel(s),
// while retaining all non-Channel Voice events
.filter(chanVoice: .dropChannel(0x0))
.filter(chanVoice: .dropChannels([0x0, 0x1, 0x2]))
```

```swift
// drop CC events with certain controller(s),
// while retaining all non-Channel Voice events
.filter(chanVoice: .dropCC(1))
.filter(chanVoice: .dropCCs([1, 11, 64]))
```

```swift
// drop note on/off events within certain note ranges(s),
// while retaining all non-Channel Voice events
.filter(chanVoice: .dropNotesInRange(40 ... 80))
.filter(chanVoice: .dropNotesInRanges([20 ... 40, 60 ... 80]))
```

## System Common

System Common filter type(s) (``MIDIEvent/SysCommonType``) available:

- ``MIDIEvent/SysCommonType/songPositionPointer``
- ``MIDIEvent/SysCommonType/songSelect``
- ``MIDIEvent/SysCommonType/timecodeQuarterFrame``
- ``MIDIEvent/SysCommonType/tuneRequest``
- ``MIDIEvent/SysCommonType/unofficialBusSelect``

### Only

```swift
.filter(sysCommon: .only)
.filter(sysCommon: .onlyType(.songSelect))
.filter(sysCommon: .onlyTypes([.songSelect, .tuneRequest]))
```

### Keep

```swift
.filter(sysCommon: .keepType(.songSelect))
.filter(sysCommon: .keepTypes([.songSelect, .tuneRequest]))
```

### Drop

```swift
.filter(sysCommon: .drop)
.filter(sysCommon: .dropType(.songSelect))
.filter(sysCommon: .dropTypes([.songSelect, .tuneRequest]))
```

## System Exclusive

System Exclusive filter type(s) (``MIDIEvent/SysExType``) available:

- ``MIDIEvent/SysExType/sysEx7``
- ``MIDIEvent/SysExType/universalSysEx7``
- ``MIDIEvent/SysExType/sysEx8`` (MIDI 2.0 Only)
- ``MIDIEvent/SysExType/universalSysEx8`` (MIDI 2.0 Only)

### Only

```swift
.filter(sysEx: .only)
.filter(sysEx: .onlyType(.sysEx))
.filter(sysEx: .onlyTypes([.sysEx, .universalSysEx]))
```

### Keep

```swift
.filter(sysEx: .keepType(.sysEx))
.filter(sysEx: .keepTypes([.sysEx, .universalSysEx]))
```

### Drop

```swift
.filter(sysEx: .drop)
.filter(sysEx: .dropType(.sysEx))
.filter(sysEx: .dropTypes([.sysEx, .universalSysEx]))
```

## System Real-Time

System Real-Time filter type(s) (``MIDIEvent/SysRealTimeType``) available:

- ``MIDIEvent/SysRealTimeType/activeSensing`` (deprecated in MIDI 2.0)
- ``MIDIEvent/SysRealTimeType/continue``
- ``MIDIEvent/SysRealTimeType/start``
- ``MIDIEvent/SysRealTimeType/stop``
- ``MIDIEvent/SysRealTimeType/systemReset``
- ``MIDIEvent/SysRealTimeType/timingClock``

### Only

```swift
.filter(sysRealTime: .only)
.filter(sysRealTime: .onlyType(.timingClock))
.filter(sysRealTime: .onlyTypes([.start, .stop, .continue]))
```

### Keep

```swift
.filter(sysRealTime: .keepType(.timingClock))
.filter(sysRealTime: .keepTypes([.start, .stop, .continue]))
```

### Drop

```swift
.filter(sysRealTime: .drop)
.filter(sysRealTime: .dropType(.activeSensing))
.filter(sysRealTime: .dropTypes([.activeSensing, .timingClock]))
```

## UMP Group

### Filter

```swift
// retains only events in the given UMP group(s)
.filter(group: 0)
.filter(groups: [0, 1])
```

### Drop

```swift
// drops events in the given UMP group(s)
.drop(group: 0)
.drop(groups: [0, 1])
```

## Topics

### Types

- ``MIDIEventFilter``
- ``MIDIEventFilterGroup``
