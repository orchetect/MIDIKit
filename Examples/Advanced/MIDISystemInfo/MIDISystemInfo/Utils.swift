//
//  Utils.swift
//  MIDISystemInfo
//
//  Created by Steffan Andrews on 2023-01-29.
//

import SwiftUI

extension Text {
    @available(macOS 12.0, *)
    @_disfavoredOverload
    init<S: StringProtocol>(markdown content: S) {
        self.init(content.toMarkdown())
    }
}

extension StringProtocol {
    @available(macOS 12.0, *)
    func toMarkdown() -> AttributedString {
        (try? AttributedString(markdown: String(self))) ?? AttributedString(self)
    }
}
