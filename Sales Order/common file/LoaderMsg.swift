//
//  LoaderMsg.swift
//  Sales Order
//
//  Created by San eforce on 25/08/23.
//

import SwiftUI

struct LoaderMsg: View {
    @State var show = false
    var body: some View {
        ZStack{
            Button(action:{
                self.show.toggle()
            }) {
                Text("Submite")
            }
            
            if self.show{
                GeometryReader{_ in
                    Loader().offset(x:110,y: 260)
                        .frame(alignment: .center)
                }.background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
        }
        
        
        
    }
}

struct LoaderMsg_Previews: PreviewProvider {
    static var previews: some View {
        LoaderMsg()
    }
}
struct Loader : View {
    @State var animate = false
    var body: some View{
        VStack{
          
            LottieUIView(filename: "order Submite").frame(width: 150,height: 150)
            Text("Order Submite...").padding(.top)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(15)
        .onAppear{
            self.animate.toggle()
        }
    }
}


