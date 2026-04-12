//
//  AnyChunkView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitCore
import MIDIKitSMF

struct AnyChunkView: View {
    @Binding var chunk: MusicalMIDI1File.AnyChunk
    
    var body: some View {
        switch chunk {
        case let .track(track):
            TrackView(track: Binding(get: { track }, set: { chunk = .track($0) }))
        case let .undefined(undefinedChunk):
            UndefinedChunkView(chunk: Binding(get: { undefinedChunk }, set: { chunk = .undefined($0) }))
        }
    }
}
