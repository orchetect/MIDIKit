//
//  MIDIParameterNumber.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol which all Parameter Number events conform.
/// This includes RPN (Registered Controller) and NRPN (Assignable Controller).
public protocol MIDIParameterNumber {
    /// The parameter number type.
    static var type: MIDIParameterNumberType { get }
    
    /// Returns the parameter number byte pair.
    var parameterBytes: UInt7Pair { get }
    
    /// Returns the data entry bytes, if present.
    var dataEntryBytes: (msb: UInt7?, lsb: UInt7?) { get }
    
    /// Controllers used for MSB and LSB CC messages.
    static var controllers: (msb: MIDIEvent.CC.Controller, lsb: MIDIEvent.CC.Controller) { get }
}

extension MIDIParameterNumber {
    /// Returns the MIDI 1.0 RPN compound message consisting of between 2-4 MIDI 1.0 Events.
    public func midi1Events(
        channel: UInt4,
        group: UInt4 = 0
    ) -> [MIDIEvent] {
        var rpnEvents: [MIDIEvent] = [
            .cc(
                Self.controllers.msb,
                value: .midi1(parameterBytes.msb),
                channel: channel,
                group: group
            ),
            .cc(
                Self.controllers.lsb,
                value: .midi1(parameterBytes.lsb),
                channel: channel,
                group: group
            )
        ]
        
        let dataEntryBytes = dataEntryBytes
        
        if let dataEntryMSB = dataEntryBytes.msb {
            rpnEvents.append(.cc(
                .dataEntry,
                value: .midi1(dataEntryMSB),
                channel: channel,
                group: group
            ))
        }
        
        if let dataEntryLSB = dataEntryBytes.lsb {
            rpnEvents.append(.cc(
                .lsb(for: .dataEntry),
                value: .midi1(dataEntryLSB),
                channel: channel,
                group: group
            ))
        }
        
        return rpnEvents
    }
}

extension MIDIParameterNumber {
    /// Returns the complete raw MIDI 1.0 message bytes that comprise the event.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func midi1RawBytes(
        channel: UInt4,
        group: UInt4 = 0
    ) -> [UInt8] {
        Array(
            midi1Events(channel: channel, group: group)
                .map { $0.midi1RawBytes() }
                .joined()
        )
    }
    
    private func umpMessageType(
        protocol midiProtocol: MIDIProtocolVersion
    ) -> MIDIUMPMessageType {
        switch midiProtocol {
        case ._1_0:
            return .midi1ChannelVoice
            
        case ._2_0:
            return .midi2ChannelVoice
        }
    }
    
    /// Returns the raw MIDI 2.0 UMP (Universal MIDI Packet) message bytes that comprise the event.
    /// May return 1 or more packets which is why this method returns an array of word arrays.
    /// Each inner array contains words for one packet.
    ///
    /// - Note: This is mainly for internal use and is not necessary to access during typical usage
    /// of MIDIKit, but is provided publicly for introspection and debugging purposes.
    public func umpRawWords(
        protocol midiProtocol: MIDIProtocolVersion,
        change: MIDI2ParameterNumberChange,
        channel: UInt4,
        group: UInt4 = 0
    ) -> [[UMPWord]] {
        let mtAndGroup = (umpMessageType(protocol: midiProtocol).rawValue.uInt8Value << 4) + group
            .uInt8Value
        
        switch midiProtocol {
        case ._1_0:
            // UMP has no MIDI 1.0 RPN/NRPN message, so we send all the CC messages individually.
            // this will produce more than one UMP packet.
            return Array(
                midi1Events(channel: channel, group: group)
                    .map { $0.umpRawWords(protocol: midiProtocol) }
                    .joined()
            )
            
        case ._2_0:
            // UMP has a dedicated MIDI 2.0 RPN/NRPN message
            let statusNibble = Self.type.umpStatusNibble(for: change).uInt8Value << 4
            let paramPair = parameterBytes
            let word1 = UMPWord(
                mtAndGroup,
                statusNibble + channel.uInt8Value,
                paramPair.msb.uInt8Value,
                paramPair.lsb.uInt8Value
            ) // reserved
            
            // MIDI 2.0 RPN/NRPN UMP upscales 14-bit data value to 32-bit
            let dataBytes = UInt7Pair(
                msb: dataEntryBytes.msb ?? 0x00,
                lsb: dataEntryBytes.lsb ?? 0x00
            )
            let upscaledData = MIDIEvent.ChanVoice14Bit32BitValue
                .midi1(UInt14(uInt7Pair: dataBytes))
                .midi2Value
            let word2 = upscaledData
            
            // only need to return one packet containing 2 words
            let ump = [word1, word2]
            return [ump]
        }
    }
}
