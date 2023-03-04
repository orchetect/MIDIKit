//
//  UI Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO

#if canImport(AppKit)

import AppKit

extension NSImage {
    @_disfavoredOverload
    func resized(to newSize: CGSize) -> NSImage {
        let img = NSImage(size: newSize)
        
        img.lockFocus()
        let ctx = NSGraphicsContext.current
        ctx?.imageInterpolation = .high
        let fromRect = CGRect(origin: .zero, size: size)
        let toRect = CGRect(origin: .zero, size: newSize)
        self.draw(in: toRect, from: fromRect, operation: .copy, fraction: 1)
        img.unlockFocus()
        
        return img
    }
}

#endif

#if canImport(UIKit)

import UIKit

extension UIImage {
    @_disfavoredOverload
    func resized(to newSize: CGSize) -> UIImage {
        let image = UIGraphicsImageRenderer(size: newSize).image { _ in
            draw(in: CGRect(origin: .zero, size: newSize))
        }
        
        return image.withRenderingMode(renderingMode)
    }
}

#endif

#if canImport(SwiftUI)

import SwiftUI

extension MIDIEndpoint {
    @available(macOS 10.15, iOS 13.0, *)
    func image(resizedTo size: CGSize) -> Image? {
        #if canImport(AppKit)
        guard let nsImg = imageAsNSImage?.resized(to: size) else { return nil }
        return Image(nsImage: nsImg)
        #elseif canImport(UIKit)
        guard let uiImg = imageAsUIImage?.resized(to: size) else { return nil }
        return Image(uiImage: uiImg)
        #else
        nil
        #endif
    }
}

#endif
