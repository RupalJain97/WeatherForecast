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
    @Published var condition: String = ""
    @Published var iconURL: URL? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
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
    
    func fetchWeather(for city: String) {
        
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
            
            // Hardcoded API data
            let _hardcodedData = """
                {
                    "count":1,
                    "data":[{
                        "app_temp":10.6,
                        "aqi":8,
                        "city_name":"Cupertino",
                        "clouds":85,
                        "country_code":"US",
                        "datetime":"2024-11-27:02",
                        "dewpt":7.9,
                        "dhi":0,
                        "dni":0,
                        "elev_angle":-13.47,
                        "ghi":0,
                        "gust":2.1,
                        "h_angle":-90,
                        "lat":37.323,
                        "lon":-122.03218,
                        "ob_time":"2024-11-27 02:31",
                        "pod":"n",
                        "precip":0,
                        "pres":1012,
                        "rh":86,
                        "slp":1022,
                        "snow":0,
                        "solar_rad":0,
                        "sources":["rtma","E3923","radar","satellite"],
                        "state_code":"CA",
                        "station":"E3923",
                        "sunrise":"15:00",
                        "sunset":"00:51",
                        "temp":10.6,
                        "timezone":"America/Los_Angeles",
                        "ts":1732674711,
                        "uv":0,
                        "vis":16,
                        "weather":{
                            "icon":"c03n",
                            "description":"Broken clouds",
                            "code":803
                        },
                        "wind_cdir":"NW",
                        "wind_cdir_full":"northwest",
                        "wind_dir":316,
                        "wind_spd":1.1
                    }]
                }
                """
            
            
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
            }
            print("Animation Name: \(self.animationName)")
            
            
        }
        //        let apiKey = getAPIKey()
        //        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        //        let urlString = "https://api.weatherbit.io/v2.0/current?city=\(cityEncoded)&key=\(apiKey)"
        //
        //        print("URL String: \(urlString)")
        //
        //        guard let url = URL(string: urlString) else {
        //            DispatchQueue.main.async {
        //                self.errorMessage = "Invalid URL. Please try again."
        //                self.isLoading = false // Stop loading
        //            }
        //            return
        //        }
        //
        //        // API Request
        //        URLSession.shared.dataTask(with: url) { data, response, error in
        //            DispatchQueue.main.async {
        //                self.isLoading = false // Stop loading
        //            }
        //            if let error = error {
        //                print("Error during API call: \(error.localizedDescription)")
        //                DispatchQueue.main.async {
        //                    self.errorMessage = "Failed to fetch weather. Try again!"
        //                }
        //                return
        //            }
        //
        //            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
        //                print("Error during HTTP Response: \(httpResponse.statusCode)")
        //                DispatchQueue.main.async {
        //                    self.errorMessage = "Server returned an error: \(httpResponse.statusCode)"
        //                }
        //                return
        //            }
        //
        //            guard let data = data else {
        //                DispatchQueue.main.async {
        //                    self.errorMessage = "No data received from server."
        //                }
        //                return
        //            }
        //
        //            print("Received Data: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")
        //
        //            do {
        //                // Decode JSON response
        //                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
        //                if let weather = weatherResponse.data.first {
        //                    DispatchQueue.main.async {
        //                        self.cityName = weather.city_name
        //                        self.temperature = weather.temp
        //                        self.condition = weather.weather.description
        //                        self.iconURL = URL(string: "https://www.weatherbit.io/static/img/icons/\(weather.weather.icon).png")
        //                        self.humidity = Int(weather.humidity)
        //                        self.windSpeed = weather.wind_spd
        //                        self.visibility = weather.vis
        //                        self.animationName = self.mapConditionToAnimation(weather.weather.icon)
        //                    }
        //                    print("Animation Name: \(self.animationName)")
        //                }
        //            } catch {
        //                print("Error parsing data \(error.localizedDescription)")
        //                DispatchQueue.main.async {
        //                    self.errorMessage = "Failed to parse weather data: \(error.localizedDescription)"
        //                }
        //            }
        //        }.resume()
    }
    
    private func mapConditionToAnimation(_ icon: String) -> String {
        return lottieAnimations[icon] ?? "default"
    }
}
