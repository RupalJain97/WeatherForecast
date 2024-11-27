//
//  WeatherView.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/26/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    var city: String
    
    var body: some View {
        ZStack {
            // Background changes based on weather condition
            LinearGradient(gradient: viewModel.weatherBackgroundGradient(),
                           startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                
                VStack{
                    // Top section with search bar
                    HStack {
                        TextField("Enter city name", text: $viewModel.cityName)
                            .foregroundColor(.white)
                            .padding(10)
                            .font(.system(size: 18, weight: .semibold, design: .serif))
                            .cornerRadius(10)
                            .overlay(
                                Rectangle()
                                    .frame(height: 1) // Height of the bottom border
                                    .foregroundColor(.white)
                                    .padding(.top, 20), // Position the border at the bottom
                                alignment: .bottom
                            )
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .background(Color.white.opacity(0.0))
                        
                        
                        Button(action: {
                            viewModel.fetchWeather(for: viewModel.cityName)
                        }) {
                            Image(systemName: "magnifyingglass.circle")
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .padding(.trailing, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    VStack{
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.white)
                                .font(.title2)
                                .scaledToFit()
                                .frame(width: 35, height: 30)
                                .padding(.top, 10)
                                .shadow(color: .black, radius: 2, x: 0, y: 2)
                            
                            
                            Text(viewModel.cityName)
                                .font(.system(size: 23, weight: .semibold))
                                .padding(.top)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(viewModel.datetime)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 0)
                }
                
                
                // Main Weather Information
                VStack {
                    
                    VStack{
                        HStack{
                            Image(systemName: "thermometer")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                            
                            Text("\(String(format: "%.1f", viewModel.temperature))°")
                                .font(.system(size: 38, weight: .bold))
                                .foregroundColor(.white)
                                .scaleEffect(viewModel.isLoading ? 1.5 : 1.0)
                                .animation(.easeInOut, value: viewModel.isLoading)
                            
                            Image(systemName: viewModel.condition == "Rain" ? "cloud.rain.fill" : "sun.max.fill")
                                .foregroundColor(viewModel.condition == "Rain" ? .gray : .yellow)
                                .font(.system(size: 20))
                            
                        }
                        .padding(.top, 20)
                        
                        Text(viewModel.weatherDescription)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    
                    HStack (spacing: 20) {
                        WeatherDetailView(icon: "sunrise", title: "\(viewModel.sunrise)")
                        WeatherDetailView(icon: "sunset", title: "\(viewModel.sunset)")
                        WeatherDetailView(icon: "wind", title: "\(viewModel.windSpeed)m/s")
                    }
                    .padding()
                }
                .padding()
                
                Spacer()
                
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .frame(height: 250)
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        .overlay(
                            VStack {
                                Text("Weather Forecast")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.top, 20)
                                
                                Spacer()
                                HStack(spacing: 25) {
                                    WeatherForecastView(day: "Apr 28", icon: "sun.max.fill", temp: "13.5°")
                                    WeatherForecastView(day: "Apr 29", icon: "cloud.fill", temp: "13.4°")
                                    WeatherForecastView(day: "Apr 30", icon: "cloud.sun.fill", temp: "13.5°")
                                }
                                .padding(.bottom, 40)
                            }
                        )
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            viewModel.fetchWeather(for: city)
        }
        
    }
}

struct WeatherDetailView: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack (spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
            
            Text(title)
                .font(.subheadline)
                .font(.system(size: 60, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
    }
}

struct WeatherForecastView: View {
    let day: String
    let icon: String
    let temp: String
    
    var body: some View {
        VStack (spacing: 2) {
            Image(systemName: icon)
                .font(.title)
                .padding(.bottom, 5)
                .foregroundColor(.gray)
            
            Text(day)
            //                .titleStyle()
                .font(.subheadline)
                .foregroundColor(.black)
                .scaledToFit()
                .padding(.bottom, 5)
            
            Text(temp)
            //                .subtitleStyle()
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    WeatherView(city: "Cupertino")
}
