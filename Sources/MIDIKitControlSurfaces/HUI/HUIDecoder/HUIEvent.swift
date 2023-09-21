//
//  HUIEvent.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol that all concrete HUI event types conform to.
public protocol HUIEvent { }

protocol _HUIEvent: HUIEvent {
    init(from coreEvent: HUICoreEvent)
}
