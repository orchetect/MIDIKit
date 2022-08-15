//
//  ViewController.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2022 Steffan Andrews • Licensed under MIT License
//

import UIKit
import MIDIKit

class ViewController: UIViewController {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBAction
    func showBluetoothMIDISetup(_ sender: Any) {
        let sheetViewController = BTMIDICentralViewController(nibName: nil, bundle: nil)
    
        present(sheetViewController, animated: true, completion: nil)
    }
    
    @IBAction
    func sendTestMIDIEvent(_ sender: Any) {
        let conn = appDelegate?.midiManager.managedOutputConnections["Broadcaster"]
        try? conn?.send(event: .cc(.expression, value: .midi1(64), channel: 0))
    }
}
