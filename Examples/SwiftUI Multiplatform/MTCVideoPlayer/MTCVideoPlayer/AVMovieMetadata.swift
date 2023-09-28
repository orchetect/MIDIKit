//
//  AVMovieMetadata.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import AVKit
import Foundation
import TimecodeKit

public struct AVMovieMetadata {
    public let frameRate: TimecodeFrameRate?
    public let startTimecode: Timecode?
    
    public init(movie: AVMovie) {
        frameRate = try? movie.timecodeFrameRate()
        startTimecode = try? movie.startTimecode()
    }
}
