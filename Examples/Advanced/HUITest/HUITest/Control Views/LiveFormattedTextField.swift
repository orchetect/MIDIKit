//
//  LiveFormattedTextField.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2025 Steffan Andrews • Licensed under MIT License
//

import SwiftUI

/// Hacky workaround to make a live-formatted SwiftUI TextField possible.
struct LiveFormattedTextField: View {
    var titleKey: LocalizedStringKey?
    @Binding var value: String
    let formatter: Formatter
    
    @State private var liveText: String
    
    init(
        _ titleKey: LocalizedStringKey? = nil,
        value: Binding<String>,
        formatter: Formatter
    ) {
        self.titleKey = titleKey
        _value = value
        self.formatter = formatter
        _liveText = State(wrappedValue: value.wrappedValue)
    }
    
    var body: some View {
        TextField(titleKey ?? "", text: $liveText)
            .onChange(of: liveText) { oldValue, newValue in
                let formatted = formatter.string(for: newValue) ?? ""
                liveText = formatted
                value = formatted
            }
    }
}
