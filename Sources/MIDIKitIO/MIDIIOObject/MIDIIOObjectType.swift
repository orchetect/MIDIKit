//
//  MIDIIOObjectType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if !os(tvOS) && !os(watchOS)

import Foundation

/// Describes the type of a ``MIDIIOObject`` instance.
public enum MIDIIOObjectType {
    case device
    case entity
    case inputEndpoint
    case outputEndpoint
}

extension MIDIIOObjectType: Equatable { }

extension MIDIIOObjectType: Hashable { }

extension MIDIIOObjectType: CaseIterable { }

extension MIDIIOObjectType: Sendable { }

#endif
