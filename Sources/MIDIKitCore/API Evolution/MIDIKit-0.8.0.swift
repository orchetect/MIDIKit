//
//  MIDIKit-0.8.0.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

extension MIDIEvent.CC.Controller {
    @available(*, unavailable, renamed: "MIDIEvent.RegisteredController")
    public enum RPN { }
    
    @available(*, unavailable, renamed: "MIDIEvent.AssignableController")
    public enum NRPN { }
}

extension MIDIEvent {
    @available(*, deprecated, renamed: "midi1RPN")
    public static func ccRPN(
        _ rpn: RegisteredController,
        channel: UInt4,
        group: UInt4 = 0
    ) -> [MIDIEvent] {
        MIDIEvent.midi1RPN(rpn, change: .absolute, channel: channel, group: group)
    }
    
    @available(*, deprecated, renamed: "midi1NRPN")
    public static func ccNRPN(
        _ nrpn: AssignableController,
        channel: UInt4,
        group: UInt4 = 0
    ) -> [MIDIEvent] {
        MIDIEvent.midi1NRPN(nrpn, change: .absolute, channel: channel, group: group)
    }
}
