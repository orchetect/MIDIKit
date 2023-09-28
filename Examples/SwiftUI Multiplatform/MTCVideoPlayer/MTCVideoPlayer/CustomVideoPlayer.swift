//
//  CustomVideoPlayer.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import AVKit
import SwiftUI
import TimecodeKit

/// More flexible alternative to the native SwiftUI `VideoPlayer`.
struct CustomVideoPlayer: NSViewRepresentable {
    var player: AVPlayer
    var controlsStyle: AVPlayerViewControlsStyle
    var playbackHandler: ((_ status: AVPlayer.TimeControlStatus) -> Void)?
    var timeHandler: ((_ location: CMTime) -> Void)?
    
    init(
        player: AVPlayer,
        controlsStyle: AVPlayerViewControlsStyle = .default,
        playbackHandler: ((_ status: AVPlayer.TimeControlStatus) -> Void)? = nil,
        timeHandler: ((_ location: CMTime) -> Void)? = nil
    ) {
        self.player = player
        self.controlsStyle = controlsStyle
        self.playbackHandler = playbackHandler
        self.timeHandler = timeHandler
    }
    
    func makeNSView(context: Context) -> AVPlayerView {
        let view = AVPlayerView()
        view.controlsStyle = controlsStyle
        view.player = player
        return view
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        nsView.player = player
        context.coordinator.update(player: player)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(player: player, playbackHandler: playbackHandler, timeHandler: timeHandler)
    }
    
    class Coordinator: NSObject {
        private var player: AVPlayer
        private var playbackHandler: ((_ status: AVPlayer.TimeControlStatus) -> Void)?
        private var timeHandler: ((_ location: CMTime) -> Void)?
        
        private var playbackObserverToken: NSKeyValueObservation?
        private var timeObserverToken: Any?
        
        init(
            player: AVPlayer,
            playbackHandler: ((_ status: AVPlayer.TimeControlStatus) -> Void)?,
            timeHandler: ((_ location: CMTime) -> Void)?
        ) {
            self.player = player
            self.playbackHandler = playbackHandler
            self.timeHandler = timeHandler
            
            super.init()
            update(player: player)
        }
        
        func update(player: AVPlayer) {
            removeObservers()
            
            self.player = player
            
            // set up playback status observer
            if let playbackHandler {
                playbackObserverToken = player.observe(
                    \AVPlayer.timeControlStatus,
                    options: [.initial, .new]
                ) { /* [unowned self] */ player, value in
                    DispatchQueue.main.async {
                        playbackHandler(value.newValue ?? player.timeControlStatus)
                    }
                }
            }
            
            // set up time observer
            if let stateHandler = timeHandler {
                let interval = CMTime(value: 1, timescale: 30) // 30fps update frequency
                timeObserverToken = player.addPeriodicTimeObserver(
                    forInterval: interval,
                    queue: .main
                ) { /* [unowned self] */ time in
                    stateHandler(time)
                }
            }
        }
        
        private func removeObservers() {
            playbackObserverToken = nil // stops observer
            if let timeObserverToken {
                player.removeTimeObserver(timeObserverToken)
            }
        }
        
        deinit {
            removeObservers()
        }
    }
}
