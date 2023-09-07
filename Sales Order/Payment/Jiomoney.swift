//
//  Jiomoney.swift
//  Sales Order
//
//  Created by San eforce on 07/09/23.
//

import SwiftUI

import WebKit

struct Jiomoney: View {
    
    
    
    var body: some View {
        NavigationView{
            WebView(htmlString: html)
        }
        .navigationBarHidden(true)
           
    }
}

struct Jiomoney_Previews: PreviewProvider {
    static var previews: some View {
        Jiomoney()
    }
}

struct WebView: UIViewRepresentable {
    let htmlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Inject JavaScript code after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let script = "document.getElementById('myButton').click();"
                webView.evaluateJavaScript(script, completionHandler: nil)
            }
        }
    }
}
