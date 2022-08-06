//
//  ViewController.swift
//  BluetoothMIDI
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import UIKit

class ViewController: UIViewController {
    @IBAction
    func showBluetoothMIDISetup(_ sender: Any) {
        let sheetViewController = BTMIDICentralViewController(nibName: nil, bundle: nil)
        
        present(sheetViewController, animated: true, completion: nil)
    }
}
