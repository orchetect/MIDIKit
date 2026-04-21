//
//  TrackView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitCore
import MIDIKitSMF

struct TrackView: View {
    @Binding var track: MusicalMIDI1File.Track
    @State private var selectedEventIDs: Set<MusicalMIDI1File.Track.Event.ID> = []
    
    var body: some View {
        List(selection: $selectedEventIDs) {
            ForEach(track.events) { timedEvent in
                HStack(alignment: .top) {
                    Text(timedEvent.delta.description)
                        .frame(width: 100, alignment: .leading)
                    Text(timedEvent.event.eventType.name)
                        .frame(width: 150, alignment: .leading)
                    Text(timedEvent.event.wrapped.description)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .onMove { source, destination in
                track.events.move(fromOffsets: source, toOffset: destination)
            }
        }
        .frame(maxWidth: .infinity)
        #if os(macOS)
        .onDeleteCommand {
            removeSelectedEvents()
        }
        #endif
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button { addNewEvent() } label: { Text("Add Event") }
                
                Button { removeSelectedEvents() } label: { Text(removeEventsLabel) }
                    .disabled(selectedEventIDs.isEmpty) // TODO: doesn't update when selecting a different chunk in the sidebar
            }
        }
    }
}

// MARK: - ViewModel

extension TrackView {
    private var removeEventsLabel: LocalizedStringKey {
        switch selectedEventIDs.count {
        case 0, 1: "Remove Event"
        default: "Remove ^[\(selectedEventIDs.count) Events](inflect: true)"
        }
    }
    
    private func addNewEvent() {
        var sampleEvents: [MIDIFileEvent] {
            [
                .cc(
                    controller: (1 ... 120).randomElement()!,
                    value: .midi1((0 ... 127).randomElement()!),
                    channel: (0 ... 15).randomElement()!
                ),
                .noteOn(
                    note: (0 ... 127).randomElement()!,
                    velocity: .midi1((0 ... 127).randomElement()!),
                    channel: (0 ... 15).randomElement()!
                )
            ]
        }
        
        let event = MusicalMIDI1File.Track.Event(
            delta: .ticks((0 ... 1920).randomElement()!),
            event: sampleEvents.randomElement()!
        )
        track.events.append(event)
        
        // select newly-created event
        selectedEventIDs = [event.id]
    }
    
    private func removeSelectedEvents() {
        guard !selectedEventIDs.isEmpty, let firstID = selectedEventIDs.first else { return }
        let idsToRemove = selectedEventIDs
        let firstItemIndex = track.events.index(ofID: firstID)
        selectedEventIDs = []
        
        track.events.removeAll(where: { idsToRemove.contains($0.id) })
        
        // select event that was above topmost selected event before event(s) removal
        let newSelectionID: MusicalMIDI1File.Track.Event.ID? =
            if let firstItemIndex,
               let newIndex = track.events.indexAfterOrBefore(index: firstItemIndex)
            {
                track.events[newIndex].id
            } else if let lastIndex = track.events.indices.last {
                track.events[lastIndex].id
            } else {
                nil
            }

        selectedEventIDs = if let newSelectionID { [newSelectionID] } else { [] }
    }
}
