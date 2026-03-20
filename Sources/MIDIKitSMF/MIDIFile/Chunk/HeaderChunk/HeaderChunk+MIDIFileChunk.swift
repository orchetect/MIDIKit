//
//  HeaderChunk+MIDIFileChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile.HeaderChunk: MIDIFileChunk {
    public struct Identifier: MIDIFile.ChunkIdentifier {
        public let string: String = "MThd"
        
        public init() { }
    }
    
    public var identifier: Identifier { Self.identifier }
    
    public static let identifier: Identifier = .init()
}
