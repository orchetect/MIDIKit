//
//  Header+MIDIFileChunk.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

extension MIDIFile.Chunk.Header: MIDIFileChunk {
    public struct Identifier: MIDIFileChunkIdentifier {
        public let string: String = "MThd"
        
        public init() { }
    }
    
    public var identifier: Identifier { Self.identifier }
    
    public static let identifier: Identifier = .init()
}
