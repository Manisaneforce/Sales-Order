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
    @State private var showAlert = false
    @State private var ShowButton:Bool = false
    @State private var backBT:Bool = true
    var body: some View {
        NavigationView{
            VStack(spacing:0){
                ZStack{
                    Rectangle()
                    .foregroundColor(ColorData.shared.HeaderColor)
                    .frame(height: 80)
                    HStack {
                        if backBT{
                            Button(action: {
                                showAlert = true
                            })
                            {
                                Image("backsmall")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .padding(.top,50)
                                    .frame(width: 50)
                                
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Payment"),
                                    message: Text("Do you want to Back?"),
                                    primaryButton: .cancel(Text("No")),
                                    secondaryButton: .destructive(Text("Yes")) {
                                        if let window = UIApplication.shared.windows.first {
                                            window.rootViewController = UIHostingController(rootView: HomePage())
                                        }
                                    }
                                )
                            }
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
                WebView(htmlString: html, ShowButton: $ShowButton, backBT: $backBT)
//                if hostdata.shared.Host == "rad.salesjump.in"{
//                    ZStack{
//                        Rectangle()
//                            .foregroundColor(ColorData.shared.HeaderColor)
//                            .frame(height: 40)
//                            .cornerRadius(10)
//                        Text("Close")
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                            .font(.system(size: 16))
//                    }
//                    .padding(.horizontal,10)
//                    .onTapGesture {
//                        if let window = UIApplication.shared.windows.first {
//                            window.rootViewController = UIHostingController(rootView: ContentView())
//                        }
//                    }
//                }
            }
           
      
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
    @Binding var ShowButton:Bool
    @Binding var backBT:Bool
    @State private var bac:String = ""

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
        var Hostname:String = ""
        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print(webView.url?.host as Any)
            if let host = webView.url?.host {
                let myHostVariable = host
                print(myHostVariable)
                print(parent)
                Hostname = myHostVariable
                    hostname(data: myHostVariable)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                let script = "document.getElementById('myButton').click();"
                webView.evaluateJavaScript(script, completionHandler: nil)
            }
        }
    }
   
}

func hostname(data:String){
    hostdata.shared.Host = data
}
