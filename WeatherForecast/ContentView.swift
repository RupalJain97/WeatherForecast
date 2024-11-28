//
//  ContentView.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/25/24.
//

import SwiftUI
import Lottie

struct ContentView: View {
    @State private var showMainWeatherView = false
    
    var body: some View {
        ZStack {
            if showMainWeatherView {
                WeatherView(city: "Cupertino") // Main weather view with default city "Cupertino"
            } else {
                SplashView()
                    .onAppear {
                        // Delay before showing the main weather screen
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                showMainWeatherView = true
                            }
                        }
                    }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
