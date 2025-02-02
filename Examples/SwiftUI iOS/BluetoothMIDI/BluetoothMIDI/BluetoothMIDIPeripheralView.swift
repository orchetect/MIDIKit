//
//  BluetoothMIDIPeripheralView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

#if os(iOS)

import CoreAudioKit
import SwiftUI
import UIKit

struct BluetoothMIDIPeripheralView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BTMIDIPeripheralViewController {
        BTMIDIPeripheralViewController()
    }
    
    func updateUIViewController(
        _ uiViewController: BTMIDIPeripheralViewController,
        context: Context
    ) { }
    
    typealias UIViewControllerType = BTMIDIPeripheralViewController
}

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
