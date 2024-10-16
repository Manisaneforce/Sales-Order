//
//  Feedback.swift
//  Sales Order
//
//  Created by San eforce on 13/09/23.
//

import SwiftUI
import WebKit
import Network
//import Amplify
//import AWSS3
struct FedQust: Any {
    let MasId: Int
    var Qus: String
    let SubHed: String
    let Ans : [String]
}
struct Feedback: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var AddressTextInpute:String = ""
    @State private var isCheckedMarks: [Bool] = [false, false, false]
    @State private var scrollOffset: CGFloat = 0.0
    @State private var Para:[String]=["1. How satisfied are you with the ReliVet App?","2. Is there any issue you would like to report?","3. is there any Material Damage / Expired?"]
    @Binding var FeedbackSc:Bool
    @Binding var CurrentSc:Bool
    @State private var showToast = false
    @State private var ToastMes = "Please type somthing in comments..."
    @State private var FEDqust = [
        FedQust(MasId: 0, Qus: "1. How satisfied are you with the ReliVet App?", SubHed: "(Please click one)", Ans: ["Very Statsfied","Satisfied","Neutral","Dissatisfied"]),
        FedQust(MasId: 1, Qus: "2. How would you rate the overall quality of products?", SubHed: "(Please click one)", Ans: ["Excellent","Good","Neutral","Fair","Poor"]),
        FedQust(MasId: 2, Qus: "3. Would you recommend the ReliNet App to others?", SubHed: "(Please click one)", Ans: ["Yes","No"]),
        FedQust(MasId: 3, Qus: "4. Is there any ordered material damaged or expired?", SubHed: "(Please click one)", Ans: ["Yes","No"]),
        FedQust(MasId: 4, Qus: "5. How was your overall delivery experience?", SubHed: "(Please click one)", Ans: ["Excellent","Good","Neutral","Fair","Poor"])
    ]
    @State private var selectedAnswers: [String?] = []
    @State private var selectedAnswer: String? = nil
    @State private var isSelected = false
    @ObservedObject var monitor = Monitor()
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Rectangle()
                        .foregroundColor(ColorData.shared.HeaderColor)
                        .frame(height: 80)
                    if monitor.status == .connected {
                    HStack {
                        Button(action: {
                            FeedbackSc.toggle()
                            CurrentSc.toggle()
                        }) {
                            Image("backsmall")
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .padding(.top,50)
                                .frame(width: 50)
                        }
                        Text("FEEDBACK / COMPLAINT FORM")
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top,50)
                        Spacer()
                    }
                    }else{
                        Internet_Connection()
                    }
                }   .onReceive(monitor.$status) { newStatus in
                    if newStatus == .connected {
                     }
                  }
                .edgesIgnoringSafeArea(.top)
                .frame(maxWidth: .infinity)
                .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                .onAppear {
                            self.selectedAnswers = Array(repeating: nil, count: FEDqust.count)
                        }
                ScrollView(showsIndicators: false){

                    ForEach(0..<FEDqust.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            
                            Text(FEDqust[index].Qus)
                                .font(.headline)
                                .padding(.horizontal,10)
                            Text(FEDqust[index].SubHed)
                                .font(.subheadline)
                                .padding(.horizontal,10)
                            
                                ForEach(FEDqust[index].Ans, id: \.self) { ans in
                                     
                                    HStack {
                                    
                                        Image(systemName: selectedAnswers.indices.contains(index) && selectedAnswers[index] == ans ? "checkmark.square.fill" : "square")
                                                                        .foregroundColor(.blue)
                                                                        .onTapGesture {
                                                                            if selectedAnswers.indices.contains(index) {
                                                                                selectedAnswers[index] = selectedAnswers[index] == ans ? nil : ans
                                                                            }
                                                                        }
                                           Text(ans)
                                               .font(.system(size: 14))
                                               .fontWeight(.semibold)
                                           Spacer()
                                       }
                                       .padding(.horizontal, 10)
                                       .padding(.vertical, 5)
                                       .onTapGesture {
                                           print(index)
                                       }
                                }
                          
                        }
                        .onTapGesture {
                            print(index)
                        }
                    }
                    
//
//                    ForEach(0..<3, id: \.self) { index in
//                        ZStack{
//
//                            GeometryReader { proxy in
//                                            Color.clear
//                                                .preference(
//                                                    key: ViewOffsetKey.self,
//                                                    value: proxy.frame(in: .global).minY
//                                                )
//
//                                        }
//                                    .onPreferenceChange(ViewOffsetKey.self) { value in
//                                        self.scrollOffset = value
//                                        print(scrollOffset)
//
//                                    }
//
//                        VStack{
//                            VStack{
//                                HStack{
//                                    Text(Para[index])
//                                        .font(.system(size: 14))
//                                        .fontWeight(.semibold)
//                                    Spacer()
//                                }
//                                .padding(.leading,10)
//
//                                HStack{
//                                    HStack{
//                                        Image(systemName: isCheckedMarks[index] ? "checkmark.square.fill" : "square")
//                                            .foregroundColor(isCheckedMarks[index] ? .blue : .blue)
//                                            .onTapGesture {
//                                                isCheckedMarks[index].toggle()
//                                            }
//                                        Text("Yes")
//                                            .font(.system(size: 14))
//                                            .fontWeight(.semibold)
//                                    }
//                                    HStack{
//                                        Image(systemName: isCheckedMarks[index] ? "square" : "checkmark.square.fill")
//                                            .foregroundColor(isCheckedMarks[index] ? .blue : .blue)
//                                            .onTapGesture {
//                                                isCheckedMarks[index].toggle()
//                                            }
//                                        Text("No")
//                                            .font(.system(size: 14))
//                                            .fontWeight(.semibold)
//                                    }
//                                    Spacer()
//                                }
//                                .padding(10)
//                            }
//                        }
//                    }
//                }
                
                HStack{
                    Text("6. For any other information/ to share Your feedback here")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                    Spacer()
                }
                .padding(.leading,10)
                .padding(.trailing,10)
                
                
                    TextEditor(text: $AddressTextInpute)
                        .padding(10)
                        .frame(height:140)
                        .overlay(
                            Text("Tell something...")
                                .foregroundColor(Color.gray)
                                .padding(.horizontal, 4)
                                .opacity(AddressTextInpute.isEmpty ? 1 : 0)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(ColorData.shared.HeaderColor, lineWidth: 1)
                                .padding(10)
                        )
              

                
                Button(action: {
                    // Add your submit action here
                    if (AddressTextInpute == ""){
                        showToast = true
                      
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    
                        showToast = false
                    }
                    }
                    else{
                        ShowToastMes.shared.tost = "Feedback Submit"
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = UIHostingController(rootView: HomePage())
                        }
                    }
                }) {
                    ZStack{
                        Rectangle()
                            .foregroundColor(ColorData.shared.HeaderColor)
                            .frame(height:40)
                            .cornerRadius(10)
                        VStack{
                            Text("SUBMIT")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .font(.system(size: 15))
                        }
                       
                    }
                    
                    .padding(10)
                }
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .onAppear {
                    UIScrollView.appearance().bounces = false
                }
              
                
                Spacer()
            }
           
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .toast(isPresented: $showToast, message: ToastMes)
    }
}
struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat

    static var defaultValue: CGFloat = 0

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct ReachOut:View{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var FeedbackSc:Bool = false
    @State private var CurrentSc:Bool = true
    @State private var ReachOutView:Bool = false
    @State private var AppBarTit:String = ""
    @State private var Url:String = ""
    @ObservedObject var monitor = Monitor()
    var body: some View{
        if CurrentSc{
        NavigationView{
            ZStack{
                VStack{
                    ZStack{
                        Rectangle()
                            .foregroundColor(ColorData.shared.HeaderColor)
                            .frame(height: 80)
                        if monitor.status == .connected {
                        HStack {
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Image("backsmall")
                                    .renderingMode(.template)
                                    .foregroundColor(.white)
                                    .padding(.top,50)
                                    .frame(width: 50)
                            }
                            Text("Reach Out")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.top,50)
                            Spacer()
                        }
                        }else{
                            Internet_Connection()
                        }
                    }  .onReceive(monitor.$status) { newStatus in
                        if newStatus == .connected {
                         }
                      }
                    .edgesIgnoringSafeArea(.top)
                    .frame(maxWidth: .infinity)
                    .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
                    VStack {
                        //                    Rectangle()
                        //                        .foregroundColor(.clear)
                        //                        .frame(height: 0.3)
                        //                        .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                        //                        .padding(8)
                        Button(action: {
                            AppBarTit = "About Us"
                            Url = APIClient.shared.BaseURL+"/server/rad/about.pdf"
                            CurrentSc.toggle()
                            ReachOutView.toggle()
                        })
                        {
                            HStack {
                                Image("Group7")
                                    .frame(width: 32, height: 32)
                                Text("About us")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding(.leading,8)
                                Spacer()
                                Image("back")
                            }
                        }
                        .padding(.leading,10)
                        .padding(.trailing,20)
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 0.3)
                            .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                            .padding(8)
                        Button(action:{
                            FeedbackSc.toggle()
                            CurrentSc.toggle()
                        })
                        {
                            HStack {
                                Image("Group 8")
                                    .frame(width: 32, height: 32)
                                Text("Feedback")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding(.leading,8)
                                Spacer()
                                Image("back")
                            }
                        }
                        .padding(.leading,10)
                        .padding(.trailing,20)
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 0.3)
                            .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                            .padding(8)
                        Button(action:{
                            AppBarTit = "Privacy Policy"
                            Url = APIClient.shared.BaseURL+"/server/rad/privacy.pdf"
                            CurrentSc.toggle()
                            ReachOutView.toggle()
                        }) {
                            HStack {
                                Image("Group 9")
                                    .frame(width: 32, height: 32)
                                Text("Privacy Policy")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding(.leading,8)
                                Spacer()
                                Image("back")
                            }
                        }
                        .padding(.leading,10)
                        .padding(.trailing,20)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 0.3)
                            .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                            .padding(8)
                        Button(action: {
                            AppBarTit = "Refund Policy"
                            Url = APIClient.shared.BaseURL+"/server/rad/refund.pdf"
                            CurrentSc.toggle()
                            ReachOutView.toggle()
                        })
                        {
                            HStack {
                                Image("Group 10")
                                    .frame(width: 32, height: 32)
                                Text("Refund Policy")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding(.leading,8)
                                Spacer()
                                Image("back")
                                
                            }
                        }
                        .padding(.leading,10)
                        .padding(.trailing,20)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 0.3)
                            .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                            .padding(8)
                        Button(action: {
                            AppBarTit = "Contact Us"
                            Url = APIClient.shared.BaseURL+"/server/rad/Contact%20Us.pdf"
                            CurrentSc.toggle()
                            ReachOutView.toggle()
                        })
                        {
                            HStack {
                                Image("Group 8")
                                    .frame(width: 32, height: 32)
                                Text("Contact Us")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)
                                    .fontWeight(.bold)
                                    .padding(.leading,8)
                                
                                Spacer()
                                Image("back")
                                
                            }
                        }
                        .padding(.leading,10)
                        .padding(.trailing,20)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 0.3)
                            .background(Color(red: 0.18, green: 0.19, blue: 0.2))
                            .padding(8)
                    }
                    Spacer()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
    }
        if FeedbackSc{
            Feedback(FeedbackSc: $FeedbackSc, CurrentSc: $CurrentSc)
        }
        if ReachOutView{
            Sales_Order.ReachOutView(ReachOutView: $ReachOutView, CurrentSc: $CurrentSc,AppBarTit: $AppBarTit,Url: $Url)
        }
    }
}

struct ReachOutView:View{
    @Binding var ReachOutView:Bool
    @Binding var CurrentSc:Bool
    @Binding var AppBarTit:String
    @Binding var Url:String
    @ObservedObject var monitor = Monitor()
    var body: some View{
        NavigationView{
        VStack{
            ZStack{
                Rectangle()
                    .foregroundColor(ColorData.shared.HeaderColor)
                    .frame(height: 80)
                if monitor.status == .connected {
                HStack {
                    Button(action: {
                        ReachOutView.toggle()
                        CurrentSc.toggle()
                    })
                    {
                        Image("backsmall")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .padding(.top,50)
                            .frame(width: 50)
                        
                    }
                    Text(AppBarTit)
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top,50)
                    Spacer()
                }
                }else{
                    Internet_Connection()
                }
                
            }  .onReceive(monitor.$status) { newStatus in
                if newStatus == .connected {
                 }
              }
            .edgesIgnoringSafeArea(.top)
            .frame(maxWidth: .infinity)
            .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
            
            WebViews(urlString: Url)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
    }
}
struct WebViews: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update the view if needed
    }
}




struct TextEditorWithPlaceholder: View {
       @Binding var text: String
       
       var body: some View {
           ZStack(alignment: .leading) {
               if text.isEmpty {
                  VStack {
                       Text("Write something...")
                           .padding(.top, 10)
                           .padding(.leading, 6)
                           .opacity(0.6)
                       Spacer()
                   }
               }
               
               VStack {
                   TextEditor(text: $text)
                       .frame(minHeight: 150, maxHeight: 300)
                       .opacity(text.isEmpty ? 0.85 : 1)
                   Spacer()
               }
           }
       }
   }
