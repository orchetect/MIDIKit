//
//  BTMIDIPeripheralViewController.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

#if os(iOS)

import UIKit
import CoreAudioKit

class BTMIDIPeripheralViewController: CABTMIDILocalPeripheralViewController {
    var uiViewController: UIViewController?
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneAction)
        )
    }
    
    @objc
    public func doneAction() {
        uiViewController?.dismiss(animated: true, completion: nil)
    }
}

#endif
