//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import AVKit
import MIDIKit
import SwiftUI

// TO DO
// -----
// - timecode entry text boxes don't support shorthand entry, ie "1.0.0.0"
// - can't modify or remove the on-screen playback controls on the VideoPlayer... possible but not
// easy (?)
// - current timecode location variable doesn't update from user scrubbing the video or playing it
// back in the window
// - need to write incoming MTC chase code
// - if controlsStyle is set to .none, video can still be scrubbed using mouse/trackpad scrolling
// over the video player view

struct ContentView: View {
    @EnvironmentObject var midiManager: MIDIManager
    @EnvironmentObject var midiHelper: MIDIHelper
    
    @State var player = AVPlayer()
    @State var playbackStatus: AVPlayer.TimeControlStatus = .paused
    @State var startTimecodeString: String = "00:00:00:00"
    @State var locationTimecodeString: String = "00:00:00:00"
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Incoming Timecode: " + (midiHelper.timecode?.stringValue ?? "--:--:--:--"))
                .font(.system(size: 18))
            
            CustomVideoPlayer(player: player, controlsStyle: .default) { status in
                playbackStatus = status
            } timeHandler: { time in
                if let tc = try? time.timecode(at: midiHelper.localFrameRate) {
                    let offset = startTimecode() + tc
                    locationTimecodeString = offset.stringValue
                }
            }
            .onAppear {
                loadVideo1()
                player.seek(to: locationTimecode(), start: startTimecode())
            }
            
            HStack {
                Text("Start:")
                EditableTimecode(
                    timecodeString: $startTimecodeString,
                    frameRate: midiHelper.localFrameRate
                ) { newValue in
                    locationTimecodeString = newValue
                    player.seek(to: locationTimecode(), start: startTimecode())
                }
                .frame(width: 150)
                
                Text("Location:")
                EditableTimecode(
                    timecodeString: $locationTimecodeString,
                    frameRate: midiHelper.localFrameRate
                ) { newValue in
                    locationTimecodeString = newValue
                    player.seek(to: locationTimecode(), start: startTimecode())
                }
                .frame(width: 150)
                .onChange(of: locationTimecodeString) { newValue in
                    guard playbackStatus == .paused else { return }
                    player.seek(to: locationTimecode(), start: startTimecode())
                }
            }
            .frame(height: 40)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
    
    private func loadVideo(videoURL: URL) {
        let movie = AVMovie(url: videoURL)
        let metadata = AVMovieMetadata(movie: movie)
        
        if let frameRate = metadata.frameRate {
            print("Derived video frame rate as \(frameRate.stringValueVerbose)")
            midiHelper.localFrameRate = frameRate
        }
        if let startTimecode = metadata.startTimecode {
            print("Video start timecode is \(startTimecode.stringValue)")
            startTimecodeString = startTimecode.stringValue
        }
        
        player = AVPlayer(playerItem: AVPlayerItem(asset: movie))
    }
    
    // TODO: to improve performance, this should be a stored property, not computed
    private func startTimecode() -> Timecode {
        (try? Timecode(startTimecodeString, at: midiHelper.localFrameRate))
            ?? .init(at: midiHelper.localFrameRate)
    }
    
    private func locationTimecode() -> Timecode {
        (try? Timecode(locationTimecodeString, at: midiHelper.localFrameRate))
            ?? .init(at: midiHelper.localFrameRate)
    }
}

// MARK: - Debug Stub

extension ContentView {
    /// TODO: This one has an issue with locating to 1 frame earlier than intended, need to figure
    /// out why.
    /// (Has QT timecode track start: 00:58:40:00 @ 23.976)
    private func loadVideo1() {
        let videoURL = URL(fileURLWithPath: "/Users/stef/Movies/MMN101-AVC-TC.mov")
        // startTimecodeString = "00:58:40:00" // should be read from video, so don't set here
        locationTimecodeString = "01:00:24:00"
        loadVideo(videoURL: videoURL)
    }
    
    /// (Syncs to timecode property.)
    /// (No QT timecode track.)
    private func loadVideo2() {
        let videoURL = URL(fileURLWithPath: "/Users/stef/Movies/MM3-AVC.mp4")
        startTimecodeString = "00:59:47:00"
        locationTimecodeString = "01:00:00:00"
        loadVideo(videoURL: videoURL)
    }
    
    /// (Syncs to timecode property.)
    /// (No QT timecode track.)
    private func loadVideo3() {
        let videoURL = URL(fileURLWithPath: "/Users/stef/Movies/LMA101.mp4")
        startTimecodeString = "00:59:50:00"
        locationTimecodeString = "01:00:00:00"
        loadVideo(videoURL: videoURL)
    }
}
