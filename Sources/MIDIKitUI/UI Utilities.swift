//
//  UI Utilities.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO

#if canImport(AppKit) && os(macOS)

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
        draw(in: toRect, from: fromRect, operation: .copy, fraction: 1)
        img.unlockFocus()
        
        return img
    }
}

#endif

#if canImport(UIKit) && !os(tvOS) && !os(watchOS)

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

#if canImport(SwiftUI) && !os(tvOS) && !os(watchOS)

import SwiftUI

extension MIDIEndpoint {
    @available(macOS 10.15, iOS 13.0, *)
    func image(resizedTo size: CGSize) -> MIDIIOObjectProperty.Value<Image> {
        #if canImport(AppKit) && os(macOS)
        imageAsNSImage.convertValue {
            let nsImg = $0.resized(to: size)
            return Image(nsImage: nsImg)
        }
        #elseif canImport(UIKit)
        imageAsUIImage.convertValue {
            let nsImg = $0.resized(to: size)
            return Image(uiImage: nsImg)
        }
        #else
        .error(.notSupported("Not yet supported on this platform."))
        #endif
    }
}

#endif
