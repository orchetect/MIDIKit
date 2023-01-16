//
//  Audio.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import Foundation
import AudioKit
import DunneAudioKit // provides Synth()
import OTCore

let globalAudioEngine = AudioEngine()

private let synthClickA = Synth(
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

private let synthClickB = Synth(
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
    globalAudioEngine.output = Mixer(synthClickA, synthClickB)
    
    _ = Settings()
    
    if (try? globalAudioEngine.start()) == nil {
        logger.error("Audio engine could not be started.")
    }
}

func playClickA() {
    let note: UInt8 = 60
    
    synthClickA.play(noteNumber: note, velocity: 127)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
        synthClickA.stop(noteNumber: note)
    }
}

func playClickB() {
    let note: UInt8 = 67
    
    synthClickB.play(noteNumber: note, velocity: 127)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) {
        synthClickB.stop(noteNumber: note)
    }
}
