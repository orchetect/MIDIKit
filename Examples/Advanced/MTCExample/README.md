# MTC Example

## Supported Platforms

- macOS

## Overview

This project demonstrates both MTC generation and chase (receive).

## Usage

By default, this demo will transmit MTC to itself in order to demonstrate it in action.

- While the 'Receive from MTC Generator Window' checkbox is enabled, the MTC Receiver window will listen for events being transmit by the MTC Generator window.

However it can be used to interact with a DAW that supports MTC (Logic Pro, Pro Tools, Cubase, Reaper, etc.) or MTC-compatible hardware.

- Two virtual MIDI endpoints are created when launching the demo: "MIDIKit MTC Gen" and "MIDIKit MTC Rec".
- Use the MTC Generator window to transmit MTC messages to a DAW and have the DAW chase it.
- Use the MTC Receiver window to receive MTC messages from a DAW and display the timecode being received.
