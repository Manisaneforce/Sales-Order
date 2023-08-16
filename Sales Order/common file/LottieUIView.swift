//
//  LottieUIView.swift
//  Sales Order
//
//  Created by San eforce on 14/08/23.
//

import SwiftUI
import Lottie

struct LottieUIView: UIViewRepresentable {
    typealias UIViewType = UIView
    var filename: String
    func makeUIView(context: UIViewRepresentableContext<LottieUIView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
                                     animationView.heightAnchor.constraint(equalTo: view.heightAnchor)])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieUIView>) {
        
    }

}


   
