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
            
            
            if viewModel.backgroundicon != "None" {
                VStack{
                    LottieView(name: viewModel.backgroundicon)
                        .ignoresSafeArea()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .top)
                        .offset(y: -120)
                        .opacity(0.7)
                }
                
            }
            
            
            VStack(spacing: 0) {
                
                //                Text search bar
                ZStack{
                    VStack(spacing: 10){
                        // Top section with search bar
                        HStack {
                            TextField("Enter city name", text: $viewModel.cityName)
                                .foregroundColor(Color.customWhite)
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
                            
                            //                        if let errorMessage = viewModel.errorMessage {
                            //                            Text(errorMessage)
                            //                                .foregroundColor(.red)
                            //                                .padding()
                            //                        }

                        }
                        .padding(.horizontal, 20)
//                        .alert(isPresented: Binding<Bool>(
//                                    get: { viewModel.errorMessage != nil },
//                                    set: { _ in viewModel.errorMessage = nil }
//                                )) {
//                                    Alert(
//                                        title: Text("Error"),
//                                        message: Text(viewModel.errorMessage ?? "An unknown error occurred."),
//                                        dismissButton: .default(Text("OK"))
//                                    )
//                                }
                                            
                        VStack(alignment: .leading, spacing: 8){
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(viewModel.isDarkMode ? .white : Color.customWhite)
                                    .font(.title2)
                                    .scaledToFit()
                                    .frame(width: 35, height: 30)
                                    .padding(.top, 10)
                                    .shadow(color: .black, radius: 2, x: 0, y: 2)
                                
                                
                                Text(viewModel.cityNameFull)
                                    .font(.system(size: 23, weight: .semibold))
                                    .padding(.top)
                                    .foregroundColor(viewModel.isDarkMode ? .white : Color.customWhite)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(viewModel.datetime)
                                .font(.subheadline)
                                .foregroundColor(viewModel.isDarkMode ? .white : Color.customWhite)
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
                                .foregroundColor(viewModel.thermometerColor(for: viewModel.highlowicon))
                            
                            Text("\(viewModel.temperature)°")
                                .font(.system(size: 58, weight: .bold))
                                .foregroundColor(viewModel.isDarkMode ? .white : Color.customWhite)
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
                            .foregroundColor(viewModel.isDarkMode ? .white : .black)
                        
                        HStack (spacing: 25) {
                            WeatherDetailView(icon: "wind", title: "\(viewModel.windSpeed)mph", color: viewModel.isDarkMode ? .white : Color.customWhite, colorText: viewModel.isDarkMode ? .white : Color.customWhite)
                            WeatherDetailView(icon: "humidity.fill", title: "\(viewModel.humidity)%", color: viewModel.isDarkMode ? .white : Color.customWhite, colorText: viewModel.isDarkMode ? .white : Color.customWhite)
                            WeatherDetailView(icon: "eye.fill", title: "\(viewModel.visibility) mi", color: viewModel.isDarkMode ? .white : Color.customWhite, colorText: viewModel.isDarkMode ? .white : Color.customWhite)
                            WeatherDetailView(icon: "cloud.rain.fill", title: "\(viewModel.precipitation)''", color: viewModel.isDarkMode ? .white : Color.customWhite, colorText: viewModel.isDarkMode ? .white : Color.customWhite)
                        }
                        .padding(.top, 20)
                        
                        HStack (spacing: 25) {
                            WeatherDetailView(icon: "sunrise.fill", title: "\(viewModel.sunrise)", color: viewModel.isDarkMode ? .white : Color.customSun, colorText: viewModel.isDarkMode ? .white : .black)
                            WeatherDetailView(icon: "sunset.fill", title: "\(viewModel.sunset)", color: viewModel.isDarkMode ? .white : Color.customSunset, colorText: viewModel.isDarkMode ? .white : .black)
                        }
                        .padding(.top, 20)
                        //                        .padding(.bottom, .infinity)
                    }
                    .scaledToFit()
                    
                }
                .frame(maxHeight: .infinity)
                
                //                Bottom Section
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
                                
//                                Spacer(minLength: 2)
                                HStack (spacing: 30) {
                                    
                                    ForEach(viewModel.forecast) { forecastWrapper in
                                        let nextforecast = forecastWrapper.forecast
                                        
                                        WeatherForecastView(
                                            day: viewModel.formatDateForecastWeather(nextforecast.datetime),
                                            icon: URL(string: "https://www.weatherbit.io/static/img/icons/\(nextforecast.weather.icon).png"),
                                            temp: "\(nextforecast.temp)°"
                                        )
                                        
                                    }
                                    
                                }
                                .padding(.bottom, 40)
                                .padding(.top, 10)
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
        .preferredColorScheme(viewModel.isDarkMode ? .light : .dark)
        .onAppear {
            viewModel.fetchWeather(for: city)
            viewModel.updateColorScheme()
            print("Theme: \(viewModel.isDarkMode)")
        }
        
    }
}

struct WeatherDetailView: View {
    let icon: String
    let title: String
    let color: Color
    let colorText: Color
    
    var body: some View {
        VStack (spacing: 5) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(colorText)
                .multilineTextAlignment(.center)
        }
    }
}

struct WeatherForecastView: View {
    let day: String
    let icon: URL?
    let temp: String
    
    var body: some View {
        VStack (spacing: 5) {
            AsyncImage(url: icon) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .scaledToFill()
            .frame(width: 40, height: 40)
            .padding(.bottom, 5)
            .foregroundColor(.gray)
            
            //            Image(systemName: icon)
            //                .resizable()
            //                .scaledToFit()
            //                .frame(width: 30, height: 30)
            //                .padding(.bottom, 5)
            //                .foregroundColor(.gray)
            
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
    WeatherView(city: "Delhi")
}
