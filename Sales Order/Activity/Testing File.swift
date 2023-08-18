import SwiftUI

struct Testing_File: View {
    @State private var showToast = false
    @State private var timer: Timer?
    @State private var remainingTime = 0
    private let toastMessage = "Timer completed!"

    var body: some View {
       
        Button(action: {
          
            
        }) {
            ZStack(alignment: .top) {
                Rectangle()
                    .foregroundColor(Color.blue)
                    .frame(height: 70)
               
                    
                    HStack {
                        
                        Image(systemName: "cart.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .frame(width: 60,height: 40)
                        
                        Text("Item: 1")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Qty : 10")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Spacer()
                        
                        
                    }
                HStack{

                    Text("\(Image(systemName: "indianrupeesign"))10000")
                        .font(.system(size: 17))
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .offset(x:30)
                    
                    Spacer()
                    
                    Text("SUBMIT")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                        .offset(x:-10)
                    
                    
                }
                   .offset(y:40)
              
            }
            //.cornerRadius(5)
            .edgesIgnoringSafeArea(.bottom)
            .frame(maxWidth: .infinity)
            .padding(.bottom, -(UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0 ))
        }
        
       
        
        
        
    }
}

struct Testing_File_Previews: PreviewProvider {
    static var previews: some View {
        Testing_File()
    }
}


