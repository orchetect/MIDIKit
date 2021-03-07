//
//  Audio.swift
//  MIDIKitSyncTestHarness
//
//  Created by Steffan Andrews on 2021-01-06.
//

import Foundation
import AudioKit
import OTCore

let globalAudioEngine = AudioEngine()

private let synthClick = Synth(
    masterVolume: 1.0,
    pitchBend: 12,
    vibratoDepth: 0.0,
    filterCutoff: 1.0,
    filterStrength: 2.0,
    filterResonance: 0.0,
    attackDuration: 0.0,
    decayDuration: 0.0,
    sustainLevel: 1.0,
    releaseDuration: 0.0,
    filterEnable: false,
    filterAttackDuration: 0.0,
    filterDecayDuration: 0.0,
    filterSustainLevel: 1.0,
    filterReleaseDuration: 0.0
)

func setupAudioEngine() {
	
    // audio engine
    AudioKit.Settings.bufferLength = .veryShort
    globalAudioEngine.output = Mixer(synthClick)

    _ = Settings()

    if (try? globalAudioEngine.start()) == nil {
        Log.error("Audio engine could not be started.")
    }
	
}

func playClick() {
	
    synthClick.play(noteNumber: 60, velocity: 127)

    DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.milliseconds(50)) {
        synthClick.stop(noteNumber: 60)
    }
	
}
