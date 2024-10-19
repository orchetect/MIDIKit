//
//  DetailsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2024 Steffan Andrews • Licensed under MIT License
//

import MIDIKitIO
import SwiftUI

struct DetailsView<Content: View>: View {
    let object: AnyMIDIIOObject?
    
    let detailsContent: (
        _ object: AnyMIDIIOObject?,
        _ showAllBinding: Binding<Bool>
    ) -> Content
    
    @State private var showAll: Bool = false
    
    var body: some View {
        if let unwrappedObject = object {
            detailsContent(unwrappedObject, $showAll)
            
            Group {
                if showAll {
                    Button("Show Relevant Properties") {
                        showAll.toggle()
                    }
                } else {
                    Button("Show All") {
                        showAll.toggle()
                    }
                }
            }
            .padding(.all, 10)
            
        } else {
            EmptyDetailsView()
        }
    }
}
