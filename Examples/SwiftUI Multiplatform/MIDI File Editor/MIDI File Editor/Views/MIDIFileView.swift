//
//  MIDIFileView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitCore
import MIDIKitSMF

struct MIDIFileView: View {
    @Binding var document: MIDIFileDocument
    @State private var selectedChunkID: MusicalMIDI1File.Track.ID? = nil

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedChunkID) {
                Section("Header") {
                    Text(document.midiFile.header.format.name)
                        .foregroundStyle(.secondary)
                    Text(document.midiFile.header.timebase.description)
                        .foregroundStyle(.secondary)
                }

                Section("Chunks") {
                    ForEach($document.midiFile.chunks) { $chunk in
                        NavigationLink {
                            AnyChunkView(chunk: $chunk)
                            #if os(macOS)
                            .navigationSubtitle(chunk.title)
                            #else
                            .navigationTitle(chunk.title)
                            #endif
                        } label: {
                            chunk.label
                                .badge(chunk.trackEventCount ?? 0)
                        }
                        .tag($chunk.id)
                    }
                    .onMove { source, destination in
                        document.midiFile.chunks.move(fromOffsets: source, toOffset: destination)
                    }
                    .navigationBarBackButtonHidden()
                }
            }
            .navigationLinkIndicatorVisibility(.visible)
            #if os(macOS)
            .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 500)
            .onDeleteCommand {
                removeSelectedChunk()
            }
            #endif
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    Button { addNewTrack() } label: { Label("Add Track", systemImage: "plus") }
                        .help("Add Track")
                    Button { removeSelectedChunk() } label: { Label("Remove Chunk", systemImage: "minus") }
                        .help("Remove Track")
                        .disabled(selectedChunkID == nil)
                }
            }
        } detail: {
            Text("Select a chunk.")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationSplitViewStyle(.balanced)
        #if os(macOS)
        .onAppear {
            // pre-select first chunk if no track is selected
            if selectedChunkID == nil {
                selectChunk(id: document.midiFile.chunks.first?.id, delay: true)
            }
        }
        #endif
    }
}

// MARK: - ViewModel

extension MIDIFileView {
    private func addNewTrack() {
        document.addNewTrack()
        
        // select new track
        selectChunk(id: document.midiFile.chunks.last?.id, delay: false)
    }
    
    private func removeSelectedChunk() {
        guard let chunkIDToRemove = selectedChunkID else { return }
        
        do {
            let adjacentChunkID = try document.removeChunk(id: chunkIDToRemove)
            // select adjacent chunk
            selectChunk(id: adjacentChunkID, delay: false)
        } catch {
            // ignore errors
        }
    }
    
    private func selectChunk(id: MusicalMIDI1File.Track.ID?, delay: Bool) {
        // NavigationSplitView has quirk where it requires setting sidebar List selection asynchronously
        // otherwise the details UI will not update, especially when set from `onAppear { }`.
        Task {
            if delay { try await Task.sleep(for: .milliseconds(10)) }
            selectedChunkID = id
        }
    }
    
    private var selectedChunk: MusicalMIDI1File.AnyChunk? {
        document.midiFile.chunks.first(where: { $0.id == selectedChunkID })
    }
    
    private var selectedTrack: MusicalMIDI1File.Track? {
        guard let selectedChunk,
              case let .track(track) = selectedChunk
        else { return nil }
        return track
    }
}
