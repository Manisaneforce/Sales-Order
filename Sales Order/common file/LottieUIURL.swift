//
//  LottieUIURL.swift
//  Sales Order
//
//  Created by San eforce on 14/08/23.
//

import SwiftUI
import Lottie

struct LottieUIURL: View {
    var body: some View {
        URLView(url: URL(string: "https://lottie.host/0914af97-4515-445b-9fd6-e8d9b6153dac/IhEkINiBpc.json")!)
    }
}

struct LottieUIURL_Previews: PreviewProvider {
    static var previews: some View {
        LottieUIURL()
    }
}

struct URLView: UIViewRepresentable {
    var url : URL
    func makeUIView(context: UIViewRepresentableContext<URLView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        Animation.loadedFrom(url: url,closure: {
            animation in
            animationView.animation = animation
            animationView.play()
        }, animationCache: LRUAnimationCache.sharedCache)
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
         
        NSLayoutConstraint.activate([animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
                                     animationView.widthAnchor.constraint(equalTo: view.widthAnchor)])
        
        return view
    }
    
    

    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
 


}
