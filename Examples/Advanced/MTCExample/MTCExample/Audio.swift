//
//  Audio.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

@preconcurrency import AudioKit
@preconcurrency import DunneAudioKit
import Foundation

final public class AudioHelper: Sendable {
    /// Shared singleton instance.
    public static let shared = AudioHelper()
    
    private let audioEngine = AudioEngine()
    
    private let synthClickA = Synth(
        masterVolume: 1.0,
        pitchBend: 12,
        vibratoDepth: 0.0,
        filterCutoff: 1.0,
        filterStrength: 2.0,
        filterResonance: 0.0,
        attackDuration: 0.005,
        decayDuration: 0.0,
        sustainLevel: 1.0,
        releaseDuration: 0.01,
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
        attackDuration: 0.005,
        decayDuration: 0.0,
        sustainLevel: 1.0,
        releaseDuration: 0.01,
        filterEnable: false,
        filterAttackDuration: 0.0,
        filterDecayDuration: 0.0,
        filterSustainLevel: 1.0,
        filterReleaseDuration: 0.0
    )
    
    private init() { }
}

extension AudioHelper {
    public func start() {
        // audio engine
        AudioKit.Settings.bufferLength = .veryShort
        audioEngine.output = Mixer(synthClickA, synthClickB)
        
        _ = AudioKit.Settings()
        
        if (try? audioEngine.start()) == nil {
            logger.error("Audio engine could not be started.")
        }
    }
    
    @concurrent public func playClickA() async {
        let note: UInt8 = 60
        
        synthClickA.play(noteNumber: note, velocity: 127)
        try? await Task.sleep(for: .milliseconds(50))
        synthClickA.stop(noteNumber: note)
    }
    
    @concurrent public func playClickB() async {
        let note: UInt8 = 67
        
        synthClickB.play(noteNumber: note, velocity: 127)
        try? await Task.sleep(for: .milliseconds(50))
        synthClickB.stop(noteNumber: note)
    }
}
