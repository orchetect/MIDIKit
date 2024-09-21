//
//  EmptyDetailsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKit
import SwiftUI

struct EmptyDetailsView: View {
    var body: some View {
        VStack {
            if #available(macOS 11.0, iOS 14.0, *) {
                Image(systemName: "pianokeys")
                    .resizable()
                    .foregroundColor(.secondary)
                    .frame(width: 200, height: 200)
                Spacer()
                    .frame(height: 50)
            }
            Text("Make a selection from the sidebar.")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
