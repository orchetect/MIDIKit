//
//  FourCharLCD.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

struct FourCharLCD: View {
    let text: String
    
    init(_ text: String) {
        self.text = text
    }
    
    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .regular, design: .monospaced))
            .foregroundColor(.green)
            .frame(maxWidth: .infinity)
            .frame(height: 26)
            .background(Color.black)
            .cornerRadius(3.0, antialiased: true)
    }
}
