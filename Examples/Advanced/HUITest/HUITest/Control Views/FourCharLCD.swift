//
//  FourCharLCD.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct FourCharLCD: View {
    let text: String
    
    init(_ text: String) {
        self.text = String(text.prefix(4))
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .regular, design: .monospaced))
            .foregroundColor(.green)
            .background(Color.black)
            .frame(maxWidth: .infinity)
            .frame(height: 26)
            .cornerRadius(3.0, antialiased: true)
    }
}
