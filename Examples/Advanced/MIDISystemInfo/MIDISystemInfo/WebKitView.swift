//
//  WebKitView.swift
//  MIDIKit • https://github.com/orchetect/MIDIKit
//  © 2021-2022 Steffan Andrews • Licensed under MIT License
//

import SwiftUI
import WebKit

struct WebKitView: NSViewRepresentable {
    @Binding var dynamicHeight: CGFloat
    @Binding var webView: WKWebView
    var html: String = ""
	
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebKitView
		
        init(_ parent: WebKitView) {
            self.parent = parent
        }
		
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript(
                "document.documentElement.scrollHeight",
                completionHandler: { (height, error) in
                    DispatchQueue.main.async {
                        if let unwrappedHeight = height as? CGFloat {
                            self.parent.dynamicHeight = unwrappedHeight
                        }
                    }
                }
            )
        }
    }
	
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
	
    func setHTML(_ html: String) {
        webView.loadHTMLString(html, baseURL: nil)
    }
	
    func makeNSView(context: Context) -> WKWebView {
        // webView.enclosingScrollView.bounces = false
        webView.navigationDelegate = context.coordinator
        webView.loadHTMLString("", baseURL: nil)
        return webView
    }
	
    func updateNSView(_ nsView: NSViewType, context: Context) {
        setHTML(html)
    }
}
