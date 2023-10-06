//
//  Jiomoney.swift
//  Sales Order
//
//  Created by San eforce on 07/09/23.
//

import SwiftUI

import WebKit

struct Jiomoney: View {
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView{
            VStack(spacing:0){
                ZStack{
                    Rectangle()
                    .foregroundColor(ColorData.shared.HeaderColor)
                    .frame(height: 80)
                    HStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        {
                            Image("backsmall")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .padding(.top,50)
                                .frame(width: 50)
                            
                        }
                        Text("Payment Gateway")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top,50)
                            //.padding(.leading,50)
                        Spacer()
                    }
                    
                }
                .edgesIgnoringSafeArea(.top)
                .frame(maxWidth: .infinity)
                .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                WebView(htmlString: html)
            }
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
            print(webView.url as Any)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let script = "document.getElementById('myButton').click();"
                webView.evaluateJavaScript(script, completionHandler: nil)
            }
        }
    }
}
