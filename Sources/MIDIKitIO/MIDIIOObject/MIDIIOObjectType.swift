//
//  MIDIIOObjectType.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
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

extension MIDIIOObjectType: Sendable { }

#endif
