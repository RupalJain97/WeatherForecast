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
            
            if !viewModel.cityName.isEmpty {
                Text("City: \(viewModel.cityName)")
                    .padding()
                Text("Temperature: \(viewModel.temperature)°C")
                    .padding()
                Text("Condition: \(viewModel.condition)")
                    .padding()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
