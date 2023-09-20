# Send and Receive on iOS While Your App is Backgrounded

Keeping your iOS app alive while it is in the background to allow MIDI messages to be sent and received.

## Context

By default, iOS places apps into a suspended state when they are backgrounded (user either switches to a different app, goes back to the home screen, or powers the screen off).

In this state, sending and receiving MIDI events is also suspended.

In order to have a good chance of passing App Store review, an entitlement needs to be added for a reason and not purely as a workaround.

## Producing Audio While in Background

If the application generates audio in response to receiving MIDI, you may add a background mode to allow audio playback which will keep the app (and the MIDI runloop) alive.

However be aware that an audio stream must be playing to keep the app alive. The Apple docs state:

> As long as [the app] is playing audio or video content or recording audio content, the app continues to run in the background. However, if recording or playback stops, the system suspends the app.

1. Add the _Background Modes -> Audio, Airplay, and Picture in Picture_ app entitlement.

![Background Modes](background-modes-audio.png)

2. Use AVFoundation to set up the app's audio session.

   ```swift
   try AVAudioSession.sharedInstance()
       .setCategory(.playback, mode: .default, options: .mixWithOthers)
   ```

3. Set the session as active either once at app startup, or dynamically make it active when the app is backgrounded (and inactive when the app is foregrounded).

4. An example implementation where a silent audio stream is played while the app is backgrounded, allowing for additional audio to play at any time as well:

   ```swift
   import AVFoundation
   
   public final class BackgroundAudioManager {
       private var audioPlayer: AVPlayer
   
       public init() {
           let playerItem = AVPlayerItem(url: URL(fileURLWithPath: "")) // empty audio
           audioPlayer = AVPlayer(playerItem: playerItem)
   
           do {
               try AVAudioSession.sharedInstance()
                   .setCategory(.playback, mode: .default, options: .mixWithOthers)
           } catch {
               print("Error setting up background audio session: \(error)")
           }
       }
   
       private func setActive(_ state: Bool) {
           do {
               try AVAudioSession.sharedInstance().setActive(state)
           } catch {
               print("Error setting background audio state: \(error)")
           }
       }
   
       public func start() {
           setActive(true)
           audioPlayer.play()
       }
   
       public func stop() {
           audioPlayer.pause()
           setActive(false)
       }
   }
   ```

   Start background audio when your app transitions to the background and stop it when in the foreground.

   #### SwiftUI

   ```swift
   @main
   struct MyApp: App {
       @Environment(\.scenePhase) private var scenePhase
       private let backgroundAudioManager = BackgroundAudioManager()
       
       var body: some Scene {
           WindowGroup {
               ContentView() // your main view
                   .onChange(of: scenePhase) { phase in
                       switch phase {
                       case .active: // App is in the foreground
                           backgroundAudioManager.stop()
                       case .inactive: // App is transitioning between fore and back
                           break
                       case .background: // App is in the background
                           backgroundAudioManager.start()
                       @unknown default: // Handle any future unknown cases
                           break
                       }
                   }
           }
       }
   }
   ```

   #### UIKit Using Scenes

   ```swift
   class SceneDelegate: UIResponder, UIWindowSceneDelegate {
       private let backgroundAudioManager = BackgroundAudioManager()
   
       func sceneDidBecomeActive(_ scene: UIScene) {
           backgroundAudioManager.stop()
       }
   
       func sceneWillResignActive(_ scene: UIScene) {
           backgroundAudioManager.start()
       }
   }
   ```

   #### UIKit Without Scenes

   ```swift
   @main
   class AppDelegate: UIResponder, UIApplicationDelegate {
       private let backgroundAudioManager = BackgroundAudioManager()
       
       func applicationDidBecomeActive(_ application: UIApplication) {
           backgroundAudioManager.stop()
       }
       
       func applicationWillResignActive(_ application: UIApplication) {
           backgroundAudioManager.start()
       }
   }
   ```
