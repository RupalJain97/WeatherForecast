//
//  ContentView.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var city: String = ""
    @ObservedObject var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "cloud.sun.rain")
                .imageScale(.large)
                .foregroundStyle(.tint)
            
            Text("Weather App")
                .font(.largeTitle)
                .padding()
            
            TextField("Enter city name", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                viewModel.fetchWeather(for: city)
            }) {
                Text("Get Weather")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            // Loading Indicator
            if viewModel.isLoading {
                ProgressView("Fetching Weather...")
                    .padding()
            }
            
            if !viewModel.cityName.isEmpty {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }else{
                    AsyncImage(url: viewModel.iconURL) { image in
                        image.resizable().scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50, height: 50)
                    .padding()
                    
                    Text("City: \(viewModel.cityName)")
                        .font(.headline)
                        .padding()
                    Text("Temperature: \(String(format: "%.1f", viewModel.temperature))°C")
                        .padding()
                    Text("Condition: \(viewModel.condition)")
                        .padding()
                }
                
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
