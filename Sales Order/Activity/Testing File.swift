import SwiftUI

struct Testing_File: View {
    @State private var showToast = false
    @State private var timer: Timer?
    @State private var remainingTime = 0
    private let toastMessage = "Timer completed!"

    var body: some View {
        VStack {
            Text("OTP didn't recevied? Resend the OTP in \(remainingTime) seconds")
                .font(.headline)
                
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)

            Button(action: {
                // Start the timer
                remainingTime = 60 // Set the countdown time
                timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    if remainingTime > 0 {
                        remainingTime -= 1
                    } else {
                        showToast = true
                        timer?.invalidate()
                        timer = nil
                    }
                }
            }) {
                Text("Resend OTP")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .frame(height: 30)
            }
            .frame(height: 30)
            .toast(isPresented: $showToast, message: toastMessage)

           
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
        }
    }
}

struct Testing_File_Previews: PreviewProvider {
    static var previews: some View {
        Testing_File()
    }
}
