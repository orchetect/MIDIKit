//
//  ItemIcon.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

struct ItemIcon<Content: View>: View {
    let item: AnyMIDIIOObject
    let `default`: Content
    
    var body: some View {
        Group {
            if let img = image {
                img
            } else {
                Text("🎹")
                    .minimumScaleFactor(0.7)
            }
        }
        .scaledToFit()
        .frame(width: 18, height: 18, alignment: .center)
    }
    
    #if os(macOS)
    private var image: Image? {
        guard let img = item.imageAsNSImage else { return nil }
        return Image(nsImage: img).resizable()
    }

    #elseif os(iOS)
    private var image: Image? {
        guard let img = item.imageAsUIImage else { return nil }
        return Image(uiImage: img).resizable()
    }
    #endif
}
