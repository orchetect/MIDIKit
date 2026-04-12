//
//  MIDIFileDocument.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import MIDIKitCore
import MIDIKitSMF

struct MIDIFileDocument: FileDocument {
    var midiFile: MusicalMIDI1File
    
    init() {
        midiFile = MusicalMIDI1File()
    }
    
    static let readableContentTypes: [UTType] = [.midi]
    
    init(configuration: ReadConfiguration) throws {
        switch configuration.contentType {
        case .midi:
            guard let contents = configuration.file.regularFileContents else {
                throw MIDIFileDecodeError.fileReadError
            }
            midiFile = try /* await */ MusicalMIDI1File(data: contents)
            return
            
        default:
            throw MIDIFileDecodeError.malformed("File does not appear to be a MIDI File.")
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try midiFile.rawData()
        return FileWrapper(regularFileWithContents: data)
    }
}

// MARK: - ViewModel Methods

extension MIDIFileDocument {
    mutating func addNewTrack() {
        midiFile.chunks.append(.track(.init(events: [])))
    }
    
    /// Removes the chunk with the given ID if it exists, and returns an adjacent track ID
    /// to select. Returns `nil` if tracks are empty after removing the track.
    /// Throws an error if no track with the given ID is found.
    mutating func removeChunk(id trackIDToRemove: MusicalMIDI1File.Track.ID) throws -> MusicalMIDI1File.Track.ID? {
        guard midiFile.chunks.contains(where: { $0.id == trackIDToRemove })
        else { throw MIDIFileDocumentError.trackIDDoesNotExist }
        
        // find adjacent track
        let adjacentTrackID = midiFile.chunks.idAfterOrBefore(id: trackIDToRemove)
        
        // remove track
        midiFile.chunks.removeAll(where: { $0.id == trackIDToRemove })
        
        // return adjacent track ID
        return adjacentTrackID
    }
}
