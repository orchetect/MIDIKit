//
//  EditableTimecode.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import TimecodeKit
import TimecodeKitUI

struct EditableTimecode: View {
    @Binding var timecodeString: String
    @State var frameRate: TimecodeFrameRate
    var onSubmit: (String) -> Void
    
    @State private var editingString: String = ""
    @State private var isEditing: Bool = false
    @FocusState private var isFocused: Bool
    @State private var formatter: Timecode.TextFormatter = .init()
    @State private var lastString: String = ""
    
    var body: some View {
        if isEditing {
            TextField("", value: $editingString, formatter: formatter)
                .focused($isFocused)
                .onSubmit {
                    let tc = formTimecode(from: editingString)
                    isEditing = false
                    onSubmit(tc == nil ? lastString : editingString)
                }
                .onAppear {
                    updateFormatter()
                }
                .onChange(of: frameRate) { _ in
                    updateFormatter()
                }
        } else {
            HStack {
                Spacer().frame(width: 4)
                VStack(alignment: .leading) {
                    if let validTimecode = formTimecode(from: timecodeString) {
                        validTimecode.stringValueValidatedText()
                    } else {
                        Text(timecodeString)
                            .foregroundColor(.red)
                    }
                }
                Spacer()
            }
            .onTapGesture {
                lastString = timecodeString
                editingString = timecodeString
                isEditing = true
                isFocused = true
            }
        }
    }
    
    private func updateFormatter() {
        formatter = Timecode.TextFormatter(
            frameRate: frameRate,
            limit: .max24Hours,
            stringFormat: .default(),
            subFramesBase: nil,
            showsValidation: true,
            validationAttributes: nil
        )
    }
    
    private func formTimecode(from string: String) -> Timecode? {
        try? Timecode(string, at: frameRate)
    }
}
