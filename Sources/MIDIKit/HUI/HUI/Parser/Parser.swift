//
//  Parser.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

@_implementationOnly import OTCore
@_implementationOnly import SwiftRadix

extension MIDI.HUI {
	
    /// HUI MIDI Message Parser
	public class Parser {
		
        // MARK: local state variables
        
        private var timeDisplay: [String] = []
        private var largeDisplay: [String] = []
        private var faderMSB: [Int] = []
        private var switchesZoneSelect: UInt8? = nil
        
        // MARK: handlers
        
        /// Parser event handler that triggers when HUI events are received.
        private var eventHandler: ((Event) -> Void)?
        
        /// Set the handler used when a HUI MIDI message needs transmitting.
        public func setEventHandler(
            _ handler: ((Event) -> Void)?
        ) {
            
            eventHandler = handler
            
        }
        
        // MARK: - init
        
        public init(
            eventHandler: ((Event) -> Void)? = nil
        ) {
            
            self.eventHandler = eventHandler
            reset()
            
        }
        
        /// Resets the parser to original init state. Handlers are unaffected.
        public func reset() {
            
            timeDisplay = [String](repeating: "", count: 8) // ***** is 8 correct?
            largeDisplay = [String](repeating: "", count: 8)
            faderMSB = [Int](repeating: 0, count: 9) // ***** is 9 correct?
            switchesZoneSelect = nil
            
        }
        
	}
	
}

// MARK: MIDI Parser

extension MIDI.HUI.Parser {
    
    /// HUI MIDI message is received from host
    public func midiIn(data: [MIDI.Byte]) {
        
        // HUI ping-reply
        if data == MIDI.HUI.kMIDI.kPingFromHostMessage {
            // handler should send ping-reply to host
            eventHandler?(.pingReceived)
            return
        }
        
        guard let firstByte = data.first else { return }
        
        switch firstByte {
        case MIDI.HUI.kMIDI.kSysExStartByte :
            parse(sysEx: data)
            
        case MIDI.HUI.kMIDI.kControlStatus:
            parse(controlStatusMessage: data)
            
        case MIDI.HUI.kMIDI.kLevelMetersStatus:
            parse(levelMetersMessage: data)
            
        default:
            break
        }
        
    }
    
    private func parse(sysEx data: [MIDI.Byte]) {
        
        // check for SysEx header
        guard data.starts(with: MIDI.HUI.kMIDI.kSysExHeader) else { return }
        
        let dataAfterHeader = data
            .suffix(
                from: data.index(data.startIndex,
                                 offsetBy: MIDI.HUI.kMIDI.kSysExHeader.count)
            )
        
        guard dataAfterHeader.count > 0 else { return }
        
        switch dataAfterHeader.first {
        case MIDI.HUI.kMIDI.kDisplayType.smallByte:
            // <header> 10 <channel> <char1> <char2> <char3> <char4> F7
            
            guard dataAfterHeader.count == 7 else {
                Log.debug("Received Small Display text MIDI message \(data.hex.stringValue(padTo: 2)) but length was not expected.")
                return
            }
            
            // channel can be 0-8 (0-7 = channel strips, 8 = Select Assign text display)
            let channel = dataAfterHeader[atOffset: 1]
            var newString = ""
            
            for byte in dataAfterHeader[atOffsets: 2...5] {
                newString += MIDI.HUI.kCharTables.smallDisplay[byte.int]
            }
            
            if channel.isContained(in: 0...7) {
                eventHandler?(.channelText(channel: channel.midiUInt4, text: newString))
            } else if channel == 8 {
                // ***** not storing local state yet - needs to be implemented
                
                // ***** should get folded into a master Select Assign callback
                eventHandler?(.selectAssignText(text: newString))
            } else {
                Log.debug("Small Display text message channel not expected: \(channel). Needs to be coded.")
            }
            
            return
            
        case MIDI.HUI.kMIDI.kDisplayType.largeByte:
            // message length test: remove first byte (0x12) and last byte (SysEx end 0xF7), then see if remainder is divisible by 11
            guard (dataAfterHeader.count - 2) % 11 == 0 else {
                Log.debug("Received Large Display text MIDI message \(data.hex.stringValue(padTo: 2)) but length was not expected.")
                return
            }
            
            var largeDisplayData = dataAfterHeader[atOffsets: 1...dataAfterHeader.count-1]
            
            // ***** this block of code assumes we won't be receiving malformed/unexpected data which could cause a crash (subscript indexes)
            while largeDisplayData[atOffset: 0] != MIDI.HUI.kMIDI.kSysExEndByte {
                let zone = largeDisplayData[atOffset: 0].int
                var newString = ""
                let letters = largeDisplayData[atOffsets: 1...10]
                
                for letter in letters {
                    newString += MIDI.HUI.kCharTables.largeDisplay[letter.int] // ***** could get index overflow
                }
                largeDisplay[zone] = newString // update local state
                
                largeDisplayData = largeDisplayData.dropFirst(11)
            }
            
            eventHandler?(.largeDisplayText(components: largeDisplay))
            return
            
        case MIDI.HUI.kMIDI.kDisplayType.timeDisplayByte:
            guard dataAfterHeader.count > 0 else { return }
            let tcData: [Int] = dataAfterHeader[atOffsets: 1...dataAfterHeader.count-1].map({Int($0)})
            var i = 0
            
            for number in tcData {
                if number != Int(MIDI.HUI.kMIDI.kSysExEndByte) { // kind of a lazy workaround but it works
                    var lookupChar = ""
                    
                    if number < MIDI.HUI.kCharTables.timeDisplay.count {
                        // in lookup table bounds
                        lookupChar = MIDI.HUI.kCharTables.timeDisplay[number]
                    } else {
                        // not recognized
                        lookupChar = "?"
                        Log.debug("Timecode character code not recognized:",
                                  number.hex.stringValue, "(Int: \(number))")
                    }
                    
                    // update local state
                    timeDisplay[7 - i] = lookupChar
                    i += 1
                }
            }
            
            eventHandler?(.timeDisplayText(components: timeDisplay))
            return
            
        default:
            Log.debug("Header detected but subsequent message is not recognized:",
                      dataAfterHeader.hex.stringValue(padToEvery: 2))
            
        }
        
    }
    
    private func parse(controlStatusMessage data: [MIDI.Byte]) {
        
        guard let dataByte1 = data[safe: 1],
              let dataByte2 = data[safe: 2]
        else { return }
        
        // Control Segment
        
        // V-Pots
        // ***** CODE HAS NOT BEEN TESTED
        if dataByte1.isContained(in: MIDI.HUI.kMIDI.kVPotData1UpperNibble
                                    ... MIDI.HUI.kMIDI.kVPotData1UpperNibble + 0xB)
        {
            let channel = (dataByte1 % 0x10).midiUInt4
            let value = dataByte2.int
            
            eventHandler?(.vPot(channel: channel, value: value))
            return
        }
        
        // Fader levels (channel strips 1-8)
        if dataByte1.isContained(in: 0...7)
        {
            parseFaderLevel(dataByte1: dataByte1, dataByte2: dataByte2)
            return
        }
        
        // Switches (2 discrete MIDI messages of 3 bytes each, all to perform one switch state change)
        // This includes buttons and LEDs, as well as some internal HUI behavior functions
        switch dataByte1 {
        case MIDI.HUI.kMIDI.kControlDataByte1.zoneSelectByte:
            // zone select (1st message)
            
            switchesZoneSelect = dataByte2
            return
            
        case MIDI.HUI.kMIDI.kControlDataByte1.portOnOffByte:
            // port on, or port off (2nd message)
            
            defer { switchesZoneSelect = nil }
            
            let port = dataByte2.hex.nibble(0).value.midiUInt4
            var state: Bool
            
            switch dataByte2.hex.nibble(1).value {
            case 0x0:
                state = false
            case 0x4:
                state = true
            default:
                if let zone = switchesZoneSelect {
                    if let guess = MIDI.HUI.Parameter(zone: zone,
                                                      port: port)
                    {
                        Log.debug("Received message 2 of a switch command \(data.hex.stringValue(padTo: 2, prefix: true)) matching \(guess) but has unexpected state bit \(dataByte2.hex.nibble(1).stringValue(prefix: true)). Ignoring message.")
                    } else {
                        Log.debug("Received message 2 of a switch command \(data.hex.stringValue(padTo: 2, prefix: true)) but has unexpected state bit (\(dataByte2.hex.nibble(1).stringValue(prefix: true))). Additionally, could not guess zone and port pair name. Ignoring message.")
                    }
                } else {
                    Log.debug("Received message 2 of a switch command \(data.hex.stringValue(padTo: 2, prefix: true)) but has unexpected state bit (\(dataByte2.hex.nibble(1).stringValue(prefix: true))). Additionally, could not lookup zone and port name because zone select message was not received prior. Ignoring message.")
                }
                
                return
                
            }
            
            if let zone = switchesZoneSelect {
                eventHandler?(.switch(zone: zone, port: port, state: state))
                switchesZoneSelect = nil // reset zone select
            } else {
                Log.debug("Received message 2 of a switch command (\(data.hex.stringValue(padTo: 2, prefix: true)) port: \(port), state: \(state)) without first receiving a zone select message. Ignoring.")
            }
            
            return
            
        default:
            Log.debug("Unrecognized HUI MIDI control status data byte 1: \(dataByte1.hex.stringValue(padTo: 2, prefix: true)).")
        }
        
    }
    
    private func parseFaderLevel(dataByte1: MIDI.Byte, dataByte2: MIDI.Byte) {
        
        let channel = dataByte1.hex.nibble(0).value.int
        let part = dataByte1.hex.nibble(1).value
        
        switch part {
        case 0x0:
            // MSB (1st message) of fader move
            
            faderMSB[channel] = dataByte2.int
            return
            
        case 0x2:
            // LSB (2nd message) of fader move
            
            let lsb = dataByte2.int
            let level = (faderMSB[channel] << 7) + lsb
            
            eventHandler?(.faderLevel(channel: channel.midiUInt4, level: level))
            return
            
        default:
            Log.debug("Malformed Fader Level message.")
            break
            
        }
        
    }
    
    private func parse(levelMetersMessage data: [MIDI.Byte]) {
        
        guard data.count >= 3 else { return }
        
        guard let channel = MIDI.UInt4(exactly: data[atOffset: 1]) else { return }
        let sideAndValue = data[atOffset: 2] // encodes both side and value
        
        var side: MIDI.HUI.Surface.State.StereoLevelMeter.Side
        var level: Int
        
        if sideAndValue >= 0x10 {
            side = .right // right
            level = (sideAndValue % 0x10).int
        } else {
            side = .left // left
            level = sideAndValue.int
        }
        
        eventHandler?(.levelMeters(channel: channel, side: side, level: level))
        
    }
    
}

extension RandomAccessCollection {
    
    /// Utility
    fileprivate func range(ofOffsets range: ClosedRange<Int>) -> ClosedRange<Index> {
        let inIndex = index(startIndex, offsetBy: range.lowerBound)
        let outIndex = index(startIndex, offsetBy: range.upperBound)
        return inIndex...outIndex
    }
    
    /// Utility
    fileprivate subscript(atOffsets range: ClosedRange<Int>) -> Self.SubSequence {
        let inIndex = index(startIndex, offsetBy: range.lowerBound)
        let outIndex = index(startIndex, offsetBy: range.upperBound)
        return self[inIndex...outIndex]
    }
    
    /// Utility
    fileprivate subscript(atOffset offset: Int) -> Element {
        self[index(startIndex, offsetBy: offset)]
    }
    
}
