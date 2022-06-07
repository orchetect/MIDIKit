//
//  BTMIDICentralViewController.swift
//  BluetoothMIDI
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if os(iOS)

import UIKit
import CoreAudioKit

class BTMIDICentralViewController: CABTMIDICentralViewController {
    var uiViewController: UIViewController?
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneAction)
        )
    }
    
    @objc public func doneAction() {
        uiViewController?.dismiss(animated: true, completion: nil)
    }
}

#endif
