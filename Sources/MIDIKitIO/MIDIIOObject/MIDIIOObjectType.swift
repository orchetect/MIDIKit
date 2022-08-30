//
//  MIDIIOObjectType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Describes the type of a ``MIDIIOObject`` instance.
public enum MIDIIOObjectType: CaseIterable, Equatable, Hashable {
    case device
    case entity
    case inputEndpoint
    case outputEndpoint
}

#endif
