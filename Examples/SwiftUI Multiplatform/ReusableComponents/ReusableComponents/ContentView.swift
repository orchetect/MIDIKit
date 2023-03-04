//
//  ContentView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import MIDIKitIO

struct ContentView: View {
    @EnvironmentObject private var midiHelper: MIDIHelper
    
    var body: some View {
        NavigationView {
            List {
                Section("Controls") {
                    NavigationLink("Endpoint List") {
                        details(index: 0)
#if os(iOS)
                            .navigationBarTitle("Endpoint List", displayMode: .inline)
                            .navigationBarBackButtonHidden(false)
#endif
                    }.tag(0)
                    
                    NavigationLink("Endpoint Picker") {
                        details(index: 1)
#if os(iOS)
                            .navigationBarTitle("Endpoint Picker", displayMode: .inline)
                            .navigationBarBackButtonHidden(false)
#endif
                    }.tag(1)
                }
            
#if os(iOS)
                Section("Info") {
                    EmptyDetailsView.textBody
                        .foregroundColor(.secondary)
                }
#endif
            }
            
            EmptyDetailsView()
        }
        .navigationTitle("Reusable Components")
//#if os(iOS)
//        .navigationViewStyle(.doubleColumn)
//#endif
    }
    
    private func details(index: Int) -> some View {
        VStack {
            switch index {
            case 0:
                ListsExampleView()
            case 1:
                PickersExampleView()
            default:
                EmptyDetailsView()
            }
            
            VStack(spacing: 10) {
                #if os(iOS)
                if UIDevice.current.userInterfaceIdiom == .phone {
                    VStack { virtualsButtons }
                } else {
                    HStack { virtualsButtons }
                }
                #else
                HStack { virtualsButtons }
                #endif
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.background)
        }
    }
    
    private var virtualsButtons: some View {
        Group {
            Button("Create Test Endpoints") {
                try? midiHelper.createVirtuals()
            }.disabled(midiHelper.virtualsExist)
            
            Button("Remove Test Endpoints") {
                try? midiHelper.destroyVirtuals()
            }.disabled(!midiHelper.virtualsExist)
        }
        .buttonStyle(.bordered)
    }
}

struct EmptyDetailsView: View {
    var body: some View {
        VStack(spacing: 10) {
            if #available(macOS 11.0, iOS 14.0, *) {
                Image(systemName: "pianokeys")
                    .resizable()
                    .foregroundColor(.secondary)
                    .frame(width: 200, height: 200)
                Spacer().frame(height: 50)
            }
            Self.textBody
        }
        .padding()
        .multilineTextAlignment(.center)
        .frame(maxWidth: 600)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    static var textBody: some View {
        Group {
            Text("Endpoint selections are saved persistently and restored after app relaunch.")
            Text("If the selected endpoint is removed from the system, it is displayed as missing in the UI.")
            Text("However it remains selected and will be restored when it reappears in the system.")
        }
        .lineLimit(10)
    }
}
