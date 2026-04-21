//
//  UndefinedChunkView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitCore
import MIDIKitSMF

struct UndefinedChunkView: View {
    @Binding var chunk: MusicalMIDI1File.UndefinedChunk
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Undefined chunk ID: \(chunk.identifier.string)")
                .font(.title)
            
            Text("Chunk Data Length: \(chunk.rawData.count) bytes")
        }
    }
}
