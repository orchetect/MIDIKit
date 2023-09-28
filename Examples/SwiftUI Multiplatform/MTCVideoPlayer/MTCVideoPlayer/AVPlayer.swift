//
//  AVPlayer.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import AVKit
import Foundation
import SwiftUI
import TimecodeKit

extension AVPlayer {
    // TODO: Could be refactored to TimecodeKit?
    /// Seek to a timecode location.
    func seek(to location: Timecode, start: Timecode) {
        let offset: Timecode
        if location >= start {
            offset = location - start
        } else {
            offset = start
        }
        
        seek(to: offset.cmTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    // TODO: Could be refactored to TimecodeKit?
    /// Seek to a timecode location.
    /// If the video asset does not contain a timecode track, zero timecode start is assumed.
    func seek(to location: Timecode) {
        let start = (try? currentItem?.asset.startTimecode()) ?? Timecode(at: location.frameRate)
        seek(to: location, start: start)
    }
}
