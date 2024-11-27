//
//  LottieView.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/25/24.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        // Lottie Animation View
        let animationView = LottieAnimationView(name: name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        // Add animation view to the UIView
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates required for static animations
    }
}
