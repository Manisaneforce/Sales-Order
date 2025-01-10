//
//  InvoiceView.swift
//  Sales Order
//
//  Created by Anbu j on 10/01/25.
//

import SwiftUI


struct PDFWebView: View {
    var pdfData: Data
    @State var PdfGetdata: Data = Data()
    @Binding var Navi_pdf_View:Bool
    @Binding var Main_View:Bool
    @State var Show_web_View:Bool = true
    @Binding var InvoiceNo:String
    @State var Doc_No:String = ""
    @State var currentTab:Int
    
    var body: some View {
        if Show_web_View{
        VStack{
            ZStack{
                Rectangle()
                    .foregroundColor(ColorData.shared.HeaderColor)
                    .frame(height: 80)
                HStack {
                    Image("backsmall")
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .padding(.top,50)
                        .frame(width: 50)
                        .onTapGesture {
                            From_To_Date.shared.SetDate = 1
                            Navi_pdf_View.toggle()
                            Main_View.toggle()
                        }
                    Text("Invoice List:\(InvoiceNo)")
                        .font(.system(size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top,50)
                    Spacer()
                }
                
            }
            .edgesIgnoringSafeArea(.top)
            .frame(maxWidth: .infinity)
            .padding(.top, -(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 ))
            
            ForEach(0..<getinvoice.count, id: \.self) { index in
                ZStack{
                    Rectangle()
                    // .foregroundColor(ColorData.shared.HeaderColor)
                        .foregroundColor(Color(red: 0.10, green: 0.59, blue: 0.81, opacity:0.1))
                        .frame(height: 80)
                        .cornerRadius(10)
                    VStack{
                        HStack{
                            VStack{
                                HStack{
//                                    Image("Myorder")
//                                        .scaledToFit()
//                                        .frame(width: 20,height: 20)
                                    Text("Doc No: \(getinvoice[index].DocNo)")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    Spacer()
                                        
                                } .padding(.vertical,5)
                                    
                                HStack{
//                                    Image("Myorder")
//                                        .scaledToFit()
//                                        .frame(width: 20,height: 20)
                                    Text("Doc Type: \(getinvoice[index].Doc_Typ)")
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        //.padding(.leading,-2)
                                    Spacer()
                                } .padding(.vertical,5)
                            }.padding(.horizontal,10)
                               
                            Spacer()
                            Image(systemName: "chevron.right")
                                .padding(.trailing,8)
                                .foregroundColor(ColorData.shared.HeaderColor)
                            
                        }
                    }
                }.onTapGesture {
                    Doc_No = getinvoice[index].DocNo
                    PdfGetdata = Data(base64Encoded: getinvoice[index].Xstring) ?? Data()
                    Show_web_View.toggle()
                    From_To_Date.shared.SetDate = 1
                    // Navi_pdf_View.toggle()
                   // Show_web_View.toggle()
                  //  Main_View.toggle()
                }
                
            } .padding(10)
            Spacer()
        }
        }else{
            getWebView(pdfData: PdfGetdata, Show_web_View: $Show_web_View, Doc_No: $Doc_No, currentTab: $currentTab)
        }
    }
}
