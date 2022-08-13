//
//  AnyMIDIIOObject.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if !os(tvOS) && !os(watchOS)

/// Type-erased representation of a MIDIKit object conforming to `MIDIIOObjectProtocol`.
public struct AnyMIDIIOObject: MIDIIOObjectProtocol {
    // MARK: MIDIIOObjectProtocol
        
    public let objectType: MIDIIOObjectType
        
    public let name: String
        
    public let uniqueID: MIDIIdentifier
        
    public let coreMIDIObjectRef: CoreMIDIObjectRef
        
    // MARK: Init
        
    internal init<O: MIDIIOObjectProtocol>(_ base: O) {
        objectType = base.objectType
        name = base.name
        uniqueID = base.uniqueID
            
        coreMIDIObjectRef = base.coreMIDIObjectRef
    }
}

extension AnyMIDIIOObject: Equatable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension AnyMIDIIOObject: Hashable {
    // default implementation provided in MIDIIOObjectProtocol
}

extension AnyMIDIIOObject: Identifiable {
    public typealias ID = CoreMIDIObjectRef
    
    public var id: ID { coreMIDIObjectRef }
}

extension MIDIIOObjectProtocol {
    /// Return as `AnyMIDIIOObject`, a type-erased representation of a MIDIKit object conforming to `MIDIIOObjectProtocol`.
    public func asAnyMIDIIOObject() -> AnyMIDIIOObject {
        .init(self)
    }
}

extension Collection where Element: MIDIIOObjectProtocol {
    /// Return as [`AnyMIDIIOObject`], type-erased representations of MIDIKit objects conforming to `MIDIIOObjectProtocol`.
    public func asAnyMIDIIOObjects() -> [AnyMIDIIOObject] {
        map { $0.asAnyMIDIIOObject() }
    }
}

#endif
