# Send and Receive on iOS While Your App is Backgrounded

Keeping your iOS app alive while it is in the background to allow MIDI messages to be sent and received.

## Background

By default, iOS places apps into a suspended state when they are backgrounded (user either switches to a different app, goes back to the home screen, or powers the screen off).

In this state, sending and receiving MIDI events is also suspended.

Various workarounds are possible to keep a backgrounded app awake in order to process MIDI events.

This guide describes one such workaround.

## Workaround

One suitable workaround is to generate null audio as background activity.

1. Add the _Background Modes -> Audio, Airplay, and Picture in Picture_ app entitlement.

![Background Modes](background-modes-audio.png)

2. Add a background audio manager class:

   ```swift
   import AVFoundation
   
   public final class BackgroundAudioManager {
       private var audioPlayer: AVPlayer
   
       public init() {
           let playerItem = AVPlayerItem(url: URL(fileURLWithPath: ""))
           audioPlayer = AVPlayer(playerItem: playerItem)
           
           do {
               try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .mixWithOthers)
           } catch {
               print("Error initializing background audio player: \(error)")
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

3. Add an instance of the class. Start background audio when your app transitions to the background and stop it when in the foreground.

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
