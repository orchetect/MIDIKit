//
//  DetailsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import WebKit
import OTCore
import MIDIKit

struct EmptyDetailsView: View {
    var body: some View {
        Text("Make a selection.")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DetailsView<Renderer: DetailsRenderer>: View {
    let object: AnyMIDIIOObject?
    let renderer: Renderer.Type
    
    @State private var showAll: Bool = false
    
    var body: some View {
        if let unwrappedObject = object {
            renderer.init(object: unwrappedObject, showAll: $showAll)
            
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

protocol DetailsRenderer where Self: View {
    associatedtype Content: View
    
    var object: AnyMIDIIOObject { get }
    var body: Content { get }
    
    init(object: AnyMIDIIOObject, showAll: Binding<Bool>)
}

struct HTMLDetailsView: View, DetailsRenderer {
    public var object: AnyMIDIIOObject
    @Binding public var showAll: Bool
    
    @State private var webViewHeight: CGFloat = .zero
    @State private var webView: WKWebView = .init()
    
    var body: some View {
        WebKitView(
            dynamicHeight: $webViewHeight,
            webView: $webView,
            html: generateHTML(object)
        )
    }
    
    func generateHTML(_ object: AnyMIDIIOObject) -> String {
        let flatProperties = object.propertyStringValues(relevantOnly: !showAll)
        
        let htmlStart = """
            <HTML>
            <HEAD>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
                <style>
                body {
                    font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI",
                        "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans",
                        "Droid Sans", "Helvetica Neue", sans-serif;
                    font-weight: regular;
                    font-size: 15px;
                    background: #FFFFFF;
                    color: #000000;
                }
                @media (prefers-color-scheme: dark) {
                    body {
                    background: #262423;
                    color: #FFFFFF;
                    }
                }
                table {
                    table-layout: fixed;
                    width: 100%;
                    font-size: 14px;
                }
                th.props {
                    width: 250px;
                }
                th.values {
                    overflow-wrap: break-word;
                    word-wrap: break-word;
                    word-break: break-word;
                    -ms-word-break: break-all;
                }
                th {
                    font-weight: bold, semibold;
                }
                th, td {
                    text-align: left;
                    padding: 3px;
                }
                </style>
            </HEAD>
            <BODY>
            """
        
        let htmlEnd = #"</BODY></HTML>"#
        
        var htmlBody = """
            <h2>\(object.name)</h2>
            <br>
            <table>
                <thead>
                    <tr>
                        <th class="props">Property</th>
                        <th class="values">Value</th>
                    </tr>
                </thead>
            """
        
        for (key, value) in flatProperties {
            htmlBody += """
                  <tr>
                    <td>\(key)</td>
                    <td>\(value)</td>
                  </tr>
                """
        }
        
        htmlBody += """
            </table>
            """
        
        let htmlString = "\(htmlStart)\(htmlBody)\(htmlEnd)"
        
        return htmlString
    }
}

@available(macOS 12.0, *)
struct MarkdownDetailsView: View, DetailsRenderer {
    public var object: AnyMIDIIOObject
    @Binding public var showAll: Bool
    
    @State private var properties: [Property] = []
    @State private var selection: Set<Property.ID> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // SwiftUI Text doesn't render markdown headings as different sizes. dumb.
            //Text(markdown: "# \(object.name)")
            
            Table(properties, selection: $selection) {
                TableColumn("Property", value: \.key).width(min: 50, ideal: 120, max: 250)
                TableColumn("Value", value: \.value)
            }
            .tableStyle(.inset(alternatesRowBackgrounds: true))
            .onCopyCommand {
                selectedItemsProviders()
            }
            .onAppear {
                refreshProperties()
            }
            .onChange(of: showAll) { _ in
                refreshProperties()
            }
        }
    }
    
    func selectedItemsProviders() -> [NSItemProvider] {
        let str: String
        
        switch selection.count {
        case 0:
            return []
            
        case 1: // single
            // just return value
            str = properties
                .first { $0.id == selection.first! }?
                .value ?? ""
            
        default: // multiple
            // return key/value pairs, one per line
            str = properties
                .filter { selection.contains($0.key) }
                .map { "\($0.key): \($0.value)" }
                .joined(separator: "\n")
        }
        
        let provider: NSItemProvider = .init(object: str as NSString)
        return [provider]
    }
    
    func refreshProperties() {
        properties = object.propertyStringValues(relevantOnly: !showAll)
            .map { Property(key: $0.key, value: $0.value) }
    }
    
    struct Property: Identifiable {
        let key: String
        let value: String
        
        var id: String { key }
    }
}
