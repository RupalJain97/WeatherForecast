//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/25/24.
//

import Foundation
import SwiftUI

// ViewModel to handle API calls and data
class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var temperature: Double = 0.0
    @Published var weatherDescription: String = ""
    @Published var sunrise: String = ""
        @Published var sunset: String = ""
    @Published var condition: String = ""
    @Published var iconURL: URL? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var background: String = "default"
    @Published var datetime: String = "default"
    
    // Additional Weather Data
    @Published var humidity: Int = 0
    @Published var windSpeed: Double = 0.0
    @Published var visibility: Double = 0.0
    
    @Published var animationName: String = "default"
    
    // Lottie Animation Mapping
    private let lottieAnimations: [String: String] = [
        "clear-day": "sunny",
        "clear-night": "night",
        "rain": "rainy",
        "snow": "snow",
        "sleet": "sleet",
        "wind": "windy",
        "fog": "foggy",
        "cloudy": "cloudy",
        "partly-cloudy-day": "partly_cloudy",
        "partly-cloudy-night": "partly_cloudy_night"
    ]
    
    func getAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let apiKey = dict["APIKey"] as? String else {
            fatalError("Unable to find APIKey in Config.plist")
        }
        return apiKey
    }
    
    // Determine background color based on weather condition
    func backgroundColor() -> Color {
        switch self.animationName {
        case "sunny":
            return Color.yellow
        case "rainy":
            return Color.blue.opacity(0.6)
        case "snow":
            return Color.white.opacity(0.8)
        case "cloudy", "partly_cloudy":
            return Color.gray.opacity(0.6)
        case "foggy":
            return Color.gray.opacity(0.3)
        case "windy":
            return Color.green.opacity(0.4)
        default:
            return Color.blue.opacity(0.3) // Default background
        }
    }
    
    func fetchWeather2(for city: String) {
        
        guard !city.isEmpty else {
            self.errorMessage = "City name cannot be empty."
            return
        }
        
        print("fetchWeather called for city: \(city)")
        
        errorMessage = nil
        isLoading = true // Start loading
        
        // Simulate loading
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
            
            //            print("Hardcoded weather data:" + String(describing: hardcodedData))
            
            DispatchQueue.main.async {
                self.cityName = "Cupertino"
                self.temperature = 10.6
                self.condition = "cloudy"
                self.iconURL = URL(string: "https://www.weatherbit.io/static/img/icons/c03n.png")
                self.humidity = 86
                self.windSpeed = 1.1
                self.visibility = 16.0
                self.animationName = self.mapConditionToAnimation("c03n")
                self.datetime = "November"
            }
            print("Animation Name: \(self.animationName)")
            
            
        }
        let apiKey = getAPIKey()
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.weatherbit.io/v2.0/current?city=\(cityEncoded)&key=\(apiKey)"
        
        print("URL String: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL. Please try again."
                self.isLoading = false // Stop loading
            }
            return
        }
        
        // API Request
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false // Stop loading
            }
            if let error = error {
                print("Error during API call: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch weather. Try again!"
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Error during HTTP Response: \(httpResponse.statusCode)")
                DispatchQueue.main.async {
                    self.errorMessage = "Server returned an error: \(httpResponse.statusCode)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from server."
                }
                return
            }
            
            print("Received Data: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")
            
            do {
                // Decode JSON response
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                if let weather = weatherResponse.data.first {
                    DispatchQueue.main.async {
                        self.cityName = weather.city_name  ?? "Unknown"
                        self.temperature = weather.temp ?? 0
                        self.condition = weather.weather.description ?? "N/A"
                        self.iconURL = URL(string: "https://www.weatherbit.io/static/img/icons/\(weather.weather.icon).png")
                        self.humidity = Int(weather.humidity)
                        self.windSpeed = weather.wind_spd
                        self.visibility = weather.vis
                        self.animationName = self.mapConditionToAnimation(weather.weather.icon)
//                        self.icon = weather.weather.icon ?? "default"
//                        self.background = self.mapConditionToBackground(self.icon)
                        
                    }
                    print("Animation Name: \(self.animationName)")
                }
            } catch {
                print("Error parsing data \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse weather data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func fetchWeather(for city: String) {
            // Hardcoded data for now
            DispatchQueue.main.async {
                self.cityName = "Cupertino"
                self.temperature = 23.0
                self.weatherDescription = "Clear Sky"
                self.sunrise = "06:30 AM"
                self.sunset = "05:45 PM"
                self.windSpeed = 3.0
                self.animationName = "sunny"
                self.datetime = "Wed, Apr 27, 3:38 PM"
            }
        }
    
    
    func weatherBackgroundGradient() -> Gradient {
            if weatherDescription.contains("Clear") {
                return Gradient(colors: [.cyan, .orange])
            } else if weatherDescription.contains("Cloudy") {
                return Gradient(colors: [.gray, .blue])
            } else {
                return Gradient(colors: [.black, .gray])
            }
        }
    
    private func mapConditionToIcon(_ icon: String) -> String {
        switch icon
                {
                case "t01d","t02d","t03d","t01n","t02n","t03n" : return "cloud.bolt.rain"
                case "t04d","t04n","t05d","t05n": return "cloud.bolt.drizzle.hail"
                case "d01d","d01n","d02d","d02n","d03d","d03n": return "cloud.drizzle"
                case "r01d", "r01n","r02d","r02n": return "cloud.rain"
                case "r03d","r03n": return "cloud.heavyrain"
                case "f01d","f01n","r04d","r04n","r05d","r05n","r06d","r06n": return "cloud.rain"
                case "s01d","s01n","s02d","s02n","s03d","s03n","s04d","s04n": return "cloud.snow"
                case "s05d","s05n": return "cloud.sleet"
                case "a01d","a01n","a02d","a02n","a03d","a03n","a04d","a04n","a05d","a05n","a06d","a06n": return "smoke"
                case "c01d","c01n": return "sun.max"
                case "c02d", "c02n","c03d","c03n": return "cloud.sun"
                case "c04d","c04n": return "smoke"
                default:
                    return "cloud"
                }
        
    }
    
    private func mapConditionToBackground(_ icon: String) -> String {
        switch icon {
        case  "t01d","t01n": return "Thunderstorm with light rain"
        case  "t02d","t02n": return "Thunderstorm with rain"
        case  "t03d","t03n": return "Thunderstorm with heavy rain"
//        case  "t04d","t04n": return "Thunderstorm with light drizzle"
        case  "t04d","t04n": return "Thunderstorm with drizzle"
            //            case  "t04d","t04n": return "Thunderstorm with heavy drizzle"
        case  "t05d","t05n": return "Thunderstorm with Hail"
        case  "d01d","d01n": return "Light Drizzle"
        case  "d02d","d02n": return "Drizzle"
        case  "d03d","d03n": return "Heavy Drizzle"
        case  "r01d","r01n": return "Light Rain"
        case  "r02d","r02n": return "Moderate Rain"
        case  "r03d","r03n": return "Heavy Rain"
        case  "f01d","f01n": return "Freezing rain"
        case  "r04d","r04n": return "Light shower rain"
        case  "r05d","r05n": return "Shower rain"
        case  "r06d","r06n": return "Heavy shower rain"
        case  "s01d","s01n": return "Light snow"
        case  "s02d","s02n": return "Snow"
        case  "s03d","s03n": return "Heavy Snow"
        case  "s04d","s04n": return "Mix snow/rain"
        case  "s05d","s05n": return "Sleet"
            //            case  "s05d","s05n": return "Heavy sleet"
        case  "s01d","s01n": return "Snow shower"
            //            case  "s02d","s02n": return "Heavy snow shower"
        case  "s06d","s06n": return "Flurries"
        case  "a01d","a01n": return "Mist"
        case  "a02d","a02n": return "Smoke"
        case  "a03d","a03n": return "Haze"
        case  "a04d","a04n": return "Sand/dust"
        case  "a05d","a05n": return "Fog"
        case  "a06d","a06n": return "Freezing Fog"
        case  "c01d","c01n": return "Clear sky"
        case  "c02d","c02n": return "Few clouds"
            //            case  "c02d","c02n": return "Scattered clouds"
        case  "c03d","c03n": return "Broken clouds"
        case  "c04d","c04n": return "Overcast clouds"
        case  "u00d","u00n": return "Unknown Precipitation"
        default:
            return "default"
        }
    }
    
    private func mapConditionToAnimation(_ icon: String) -> String {
        return lottieAnimations[icon] ?? "default"
    }
}
