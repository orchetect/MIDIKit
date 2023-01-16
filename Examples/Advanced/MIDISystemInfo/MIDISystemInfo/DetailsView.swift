//
//  DetailsView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2023 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import WebKit
import MIDIKit

struct EmptyDetailsView: View {
    /// coaxes WebKit to start up when EmptyDetailsView first shows in the main view,
    /// making the next WebKitView view that loads to load faster
    private let dummyWKView = WKWebView()
    
    var body: some View {
        Text("Make a selection.")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DetailsView: View {
    var object: AnyMIDIIOObject?
    
    @State private var webViewHeight: CGFloat = .zero
    
    @State private var webView: WKWebView = .init()
    
    @State private var showAll: Bool = false
    
    func generateHTML(_ endpoint: AnyMIDIIOObject) -> String {
        let flatProperties = endpoint.propertiesAsStrings(onlyIncludeRelevant: !showAll)
        
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
            <h2>\(endpoint.name)</h2>
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
    
    var body: some View {
        if let unwrappedObject = object {
            WebKitView(
                dynamicHeight: $webViewHeight,
                webView: $webView,
                html: generateHTML(unwrappedObject)
            )
            
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
