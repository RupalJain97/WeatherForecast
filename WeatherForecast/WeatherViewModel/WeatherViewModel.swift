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
    @Published var cityName: String = "San Jose"
    @Published var cityNameFull: String = "San Jose, CA, US"
    @Published var temperature: Double = 0.0
    @Published var weatherDescription: String = ""
    @Published var sunrise: String = ""
    @Published var sunset: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var background: String = "Animation-night"
    @Published var datetime: String = "default"
    @Published var humidity: Int = 0
    @Published var windSpeed: Double = 0.0
    @Published var visibility: Double = 0.0
    @Published var precipitation: Double = 0.0
    //                        @Published var animationName: String = "default"
    @Published var iconURL: URL? = nil
    @Published var forecast: [WeatherForecastData] = []
    
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
    
    func updateBackgroundBasedOnTime() {
        let currentHour = Calendar.current.component(.hour, from: Date())
        
        // Set background animation based on the time of day
        if currentHour >= 19 || currentHour < 5 { // Between 7 PM and 5 AM
            self.background = "Animation-night"
        } else {
            self.background = "Animation-sunny"
        }
    }
    
    func formatUnixTimestamp(_ timestamp: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM d, h:mm a"
        return dateFormatter.string(from: date)
    }
    
    func getAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let apiKey = dict["APIKey"] as? String else {
            fatalError("Unable to find APIKey in Config.plist")
        }
        return apiKey
    }
    
    // Determine background color based on weather condition
    //    func backgroundColor() -> Color {
    //        switch self.animationName {
    //        case "sunny":
    //            return Color.yellow
    //        case "rainy":
    //            return Color.blue.opacity(0.6)
    //        case "snow":
    //            return Color.white.opacity(0.8)
    //        case "cloudy", "partly_cloudy":
    //            return Color.gray.opacity(0.6)
    //        case "foggy":
    //            return Color.gray.opacity(0.3)
    //        case "windy":
    //            return Color.green.opacity(0.4)
    //        default:
    //            return Color.blue.opacity(0.3) // Default background
    //        }
    //    }
    
    func fetchWeather(for city: String) {
        
        guard !city.isEmpty else {
            self.errorMessage = "City name cannot be empty."
            return
        }
        
        print("fetchWeather called for city: \(city)")
        
        errorMessage = nil
        isLoading = true // Start loading
        
        let apiKey = getAPIKey()
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        
        // Current Weather URL
        let weatherUrl = "https://api.weatherbit.io/v2.0/current?city=\(cityEncoded)&key=\(apiKey)"
        
        // Forecast URL
        let forecastUrl = "https://api.weatherbit.io/v2.0/forecast/daily?city=\(cityEncoded)&days=4&key=\(apiKey)"
        
        
        print("URL String: \(weatherUrl)")
        
        guard let url = URL(string: weatherUrl) else {
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
            
            DispatchQueue.main.async {
                self.background = "clear_day" // Default animation if no data
            }
            
            //            print("Received Data: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")
            
            do {
                // Decode JSON response
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                
                print("Weather Response: \(weatherResponse)")
                if let weather = weatherResponse.data.first {
                    DispatchQueue.main.async {
                        
                        self.cityName = weather.city_name
                        self.cityNameFull = (weather.city_name + ", " + weather.state_code + ", " + weather.country_code)
                        self.temperature = weather.temp
                        self.windSpeed = weather.wind_spd
                        self.humidity = Int(weather.rh)
                        self.visibility = weather.vis
                        self.weatherDescription = weather.weather.description
                        self.background = self.mapConditionToBackground(weather.weather.icon)
                        self.sunset = weather.sunset
                        self.sunrise = weather.sunrise
                        self.precipitation = weather.precip
                        self.datetime = self.formatUnixTimestamp(weather.ts)
                        
                        //                        self.animationName = self.mapConditionToIcon(weather.weather.icon)
                        self.iconURL = URL(string: "https://www.weatherbit.io/static/img/icons/\(weather.weather.icon).png")
                        
                    }
                }
            } catch {
                print("Error parsing data \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse weather data: \(error.localizedDescription)"
                }
            }
        }.resume()
        
        // Fetch Forecast
        guard let forecastURL = URL(string: forecastUrl) else { return }
        URLSession.shared.dataTask(with: forecastURL) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch forecast: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received."
                }
                return
            }
            
            do {
                let forecastResponse = try JSONDecoder().decode(WeatherForcastResponse.self, from: data)
                DispatchQueue.main.async {
                    self.forecast = Array(forecastResponse.data.dropFirst()) // Exclude today
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error parsing forecast: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    // Dynamic mapping for weather backgrounds
    private func mapConditionToBackground2(_ condition: String) -> String {
        switch condition.lowercased() {
        case "clear sky":
            return "Background-sunny"
        case "few clouds", "scattered clouds", "broken clouds":
            return "Background-cloudy"
        case "rain", "shower rain":
            return "Background-rainy"
        case "snow":
            return "Background-snowy"
        case "thunderstorm":
            return "Background-thunderstorm"
        case "mist", "fog":
            return "Background-foggy"
        default:
            return "Background-default"
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
        //        TODO
        switch icon
        {
            
        case "t01n","t02n","t03n", "r01n","r02n", "r03n"
            ,"f01n","r04n","r05n","r06n": return "Animation-night-rain"
        case "c01n" : return "Animation-night"
            //            Night
        case "s01n","s02n","s03n","s04n","s05n" : return "Animation-snow"
            //            Day
        case "s01d","s02d","s03d","s04d","s05d" : return "Animation-snow2"
        case "c01d" : return "Animation-sunny"
        case "t04d","t04n","t05d","t05n", "d01d","d01n","d02d","d02n","d03d","d03n", "f01d","r04d", "r05d","r06d" : return "Animation-thunderstrom"
            
            //        To be added
        case "t01d","t02d","t03d","r01d","r02d", "r03d" : return "Animation-sunny-rain"
        case "a01d","a01n","a02d","a02n","a03d","a03n","a04d","a04n","a05d","a05n","a06d","a06n": return "smoke"
        case "c02d", "c02n","c03d","c03n": return "cloud.sun"
        case "c04d","c04n": return "smoke"
            
        default:
            return "cloud"
        }
        
    }
    
    private func mapCodeToCondition(_ icon: String) -> String {
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
            //        case  "s01d","s01n": return "Snow shower"
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
