//
//  ContentView.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/25/24.
//

import SwiftUI
import Lottie

struct ContentView: View {
    @State private var city: String = ""
    @ObservedObject var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            viewModel.backgroundColor()
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                LottieView(name: "Animation - 1732614429229") // Pass the Lottie animation name
                    .frame(width: 100, height: 100)
                //                .padding()
                
                // Display Lottie Animation for Weather Condition
                //            if !viewModel.animationName.isEmpty {
                //                LottieView(name: "Animation - 1732614429229") // Pass the Lottie animation name
                //                    .frame(width: 200, height: 200)
                //                    .padding()
                //            } else {
                //                // Placeholder if animation is not available
                //                Image(systemName: "cloud.sun.rain")
                //                    .imageScale(.large)
                //                    .foregroundStyle(.tint)
                //                    .frame(width: 200, height: 200)
                //            }
                
                Text("Weather App")
                    .font(.largeTitle)
                    .padding()
                
                TextField("Enter city name", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    print("City entered: \(city)")
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
                    VStack {
                        LottieView(name: "Animation - 1732614175447")
                            .frame(width: 20, height: 20)
                        Text("Fetching Weather...")
                            .font(.headline)
                            .padding()
                    }
                    //                ProgressView("Fetching Weather...")
                    //                    .padding()
                }
                
                if !viewModel.cityName.isEmpty {
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }else{
                        viewModel.backgroundColor()
                            .edgesIgnoringSafeArea(.all)
                        VStack {
                            AsyncImage(url: viewModel.iconURL) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .padding()
                            
                            VStack {
                                Text("City: \(viewModel.cityName)")
                                    .font(.headline)
                                //                                .padding()
                                Text("Temperature: \(String(format: "%.1f", viewModel.temperature))°C")
                                //                                .padding()
                                Text("Condition: \(viewModel.condition)")
                                //                                .padding()
                                Text("Humidity: \(viewModel.humidity)%")
                                //                                .padding()
                                Text("Wind Speed: \(String(format: "%.1f", viewModel.windSpeed)) m/s")
                                //                                .padding()
                                Text("Visibility: \(String(format: "%.1f", viewModel.visibility)) km")
                                //                                .padding()
                            }
                            .padding()
                            .onAppear {
                                print("Displaying Weather Data for City: \(viewModel.cityName)")
                            }
                        }
                    }
                }
            }
            .padding()
        }
        
    }
}

#Preview {
    ContentView()
}
