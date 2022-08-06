//
//  BluetoothMIDIView.swift
//  BluetoothMIDI
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

#if os(iOS)

import UIKit
import SwiftUI
import CoreAudioKit

struct BluetoothMIDIView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> BTMIDICentralViewController {
        BTMIDICentralViewController()
    }
    
    func updateUIViewController(
        _ uiViewController: BTMIDICentralViewController,
        context: Context
    ) { }
    
    typealias UIViewControllerType = BTMIDICentralViewController
}

class BTMIDICentralViewController: CABTMIDICentralViewController {
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
