//
//  ViewController.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import UIKit

class ViewController: UIViewController {
    var appDelegate: AppDelegate? {
        UIApplication.shared.delegate as? AppDelegate
    }
    
    var outputConnection: MIDIOutputConnection? {
        appDelegate?.midiHelper.outputConnection
    }
    
    @IBAction
    func showBluetoothMIDIRemoteSetup(_ sender: Any) {
        let sheetViewController = BTMIDICentralViewController(nibName: nil, bundle: nil)
        present(sheetViewController, animated: true, completion: nil)
    }
    
    @IBAction
    func showBluetoothMIDILocalSetup(_ sender: Any) {
        let sheetViewController = BTMIDIPeripheralViewController(nibName: nil, bundle: nil)
        present(sheetViewController, animated: true, completion: nil)
    }
    
    @IBAction
    func sendTestMIDIEvent(_ sender: Any) {
        try? outputConnection?.send(event: .cc(.expression, value: .midi1(64), channel: 0))
    }
}
