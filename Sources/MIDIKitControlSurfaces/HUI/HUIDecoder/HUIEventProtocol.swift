//
//  HUIEventProtocol.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import Foundation

/// Protocol that all concrete HUI event types conform to.
public protocol HUIEventProtocol { }

internal protocol _HUIEventProtocol: HUIEventProtocol {
    init(from coreEvent: HUICoreEvent)
}
