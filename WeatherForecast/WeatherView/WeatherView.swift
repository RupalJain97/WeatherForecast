//
//  WeatherView.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/26/24.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel = WeatherViewModel()
    var city: String = "Cupertino"
    
    var body: some View {
        ZStack{
            if !viewModel.background.isEmpty {
                Image(viewModel.background)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipped()
                    .edgesIgnoringSafeArea(.all)
            } else {
                LinearGradient(
                    gradient: Gradient(colors: [.cyan, .orange]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }
            
            
            if !viewModel.backgroundicon.isEmpty {
                LottieView(name: viewModel.backgroundicon)
                    .ignoresSafeArea()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height )
                    .frame(alignment: .bottom)
            }
            
            VStack(spacing: 0) {
                
                ZStack{
                    VStack(spacing: 10){
                        // Top section with search bar
                        HStack {
                            TextField("Enter city name", text: $viewModel.cityName)
                                .foregroundColor(.black)
                                .padding(10)
                                .font(.system(size: 18, weight: .semibold, design: .serif))
                                .cornerRadius(10)
                                .overlay(
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.white)
                                        .padding(.top, 20),
                                    alignment: .bottom
                                )
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .background(Color.white.opacity(0.5))
                            
                            
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
                        
                        VStack(alignment: .leading, spacing: 8){
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .scaledToFit()
                                    .frame(width: 35, height: 30)
                                    .padding(.top, 10)
                                    .shadow(color: .black, radius: 2, x: 0, y: 2)
                                
                                
                                Text(viewModel.cityNameFull)
                                    .font(.system(size: 23, weight: .semibold))
                                    .padding(.top)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(viewModel.datetime)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 5)
                            
                        }
                        .padding(.leading, 20)
                        .padding(.top, 0)
                        
                    }
                    .padding(.top, 2)
                }
                .frame(height: 150, alignment: .top)
                .padding(.top, 50)
                
                // Middle Section
                ZStack {
                    
                    VStack (spacing: 16){
                        HStack(spacing: 16){
                            Image(systemName: viewModel.highlowicon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            //                                    .font(.system(size: 50))
                                .foregroundColor(viewModel.thermometerColor(for: viewModel.temperature))
                            
                            Text("\(viewModel.temperature)°")
                                .font(.system(size: 58, weight: .bold))
                                .foregroundColor(.white)
                                .scaleEffect(viewModel.isLoading ? 1.5 : 1.0)
                                .animation(.easeInOut, value: viewModel.isLoading)
                                .scaledToFit()
                            
                            
                            //                            Image(systemName: viewModel.weatherDescription == "Rain" ? "cloud.rain.fill" : "sun.max.fill")
                            //                                .foregroundColor(viewModel.condition == "Rain" ? .gray : .yellow)
                            //                                .font(.system(size: 20))
                            
                            AsyncImage(url: viewModel.iconURL) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 80, height: 80)
                            .font(.system(size: 70))
                            
                        }
                        .padding(.top, 20)
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width)
                        
                        Text(viewModel.weatherDescription)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        HStack (spacing: 25) {
                            WeatherDetailView(icon: "wind", title: "\(viewModel.windSpeed)mph")
                            WeatherDetailView(icon: "humidity.fill", title: "\(viewModel.humidity)%")
                            WeatherDetailView(icon: "eye.fill", title: "\(viewModel.visibility) mi")
                            WeatherDetailView(icon: "cloud.rain.fill", title: "\(viewModel.precipitation)''")
                        }
                        .padding(.top, 20)
                        
                        HStack (spacing: 25) {
                            WeatherDetailView(icon: "sunrise.fill", title: "\(viewModel.sunrise)")
                            WeatherDetailView(icon: "sunset.fill", title: "\(viewModel.sunset)")
                        }
                        .padding(.top, 20)
//                        .padding(.bottom, .infinity)
                    }
                    .scaledToFit()
                    
                }
                .frame(maxHeight: .infinity)
//                .frame(width: UIScreen.main.bounds.width)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white)
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        .overlay(
                            VStack {
                                Text("Weather Forecast")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .padding(.top, 20)
                                
                                Spacer()
                                HStack {
                                    WeatherForecastView(day: "Apr 28", icon: "sun.max.fill", temp: "13.5°")
                                    WeatherForecastView(day: "Apr 29", icon: "cloud.fill", temp: "13.4°")
                                    WeatherForecastView(day: "Apr 30", icon: "cloud.sun.fill", temp: "13.5°")
                                }
                                .padding(.bottom, 40)
                            }
                        )
                        .opacity(0.85)
                        .padding(0)
                }
                .frame(height: 210, alignment: .bottom)
                
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
        }
        .scaledToFit()
        .onAppear {
            viewModel.fetchWeather(for: city)
        }
        
    }
}

struct WeatherDetailView: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack (spacing: 5) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
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
        VStack (spacing: 5) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(.bottom, 5)
                .foregroundColor(.gray)
            
            Text(day)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .scaledToFit()
                .padding(.bottom, 5)
            
            Text(temp)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
        }
    }
}

#Preview {
    WeatherView(city: "Cupertino")
}
