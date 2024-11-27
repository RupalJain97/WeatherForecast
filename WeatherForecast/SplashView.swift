//
//  SplashView.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/26/24.
//

import SwiftUI
import Lottie

struct SplashView: View {
    @State private var isActive = false

    var body: some View {
        
        if isActive {
            WeatherView(city: "Cupertino") // Transition to main weather view
        } else {
            ZStack{
                LinearGradient(
                    gradient: Gradient(colors: [.orange, .cyan]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                            )
                            .ignoresSafeArea()
                
                VStack {
                    LottieView(name: "Animation - 1732614429229")
                        .frame(width: 200, height: 200)
                        .padding()
                    
                    Text("Weather App")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()
                }
                .onAppear {
                    // Delay for 2.5 seconds before transitioning
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        isActive = true
                    }
                }
            }
            
        }
    }
}

#Preview {
    SplashView()
}
