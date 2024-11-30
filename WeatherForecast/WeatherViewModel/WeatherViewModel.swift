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
    @Published var cityName: String = "Cupertino"
    @Published var cityNameFull: String = "Cupertino, CA, US"
    @Published var temperature: Int = 0
    @Published var weatherDescription: String = ""
    @Published var sunrise: String = ""
    @Published var sunset: String = ""
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var background: String = "Background-sunny"
    @Published var backgroundicon: String = "None"
    @Published var datetime: String = ""
    @Published var humidity: Int = 0
    @Published var windSpeed: Int = 0
    @Published var visibility: Int = 0
    @Published var precipitation: Int = 0
    //                        @Published var animationName: String = "default"
    @Published var iconURL: URL? = nil
    @Published var forecast: [IdentifiableWeatherForecastData] = []
    @Published var highlowicon: String = "sun.max.fill"
    
    @Published var isDarkMode: Bool = false
    
    private var currentCityTimezone: String = "America/Los_Angeles" // Default timezone
        
    init() {
        updateIcon()
    }
    
    func updateIcon() {
        highlowicon = checkTime() == "night" ? "moon.stars.fill" : "sun.max.fill"
    }
    
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
    
    func checkTime() -> String {
        guard let timezone = TimeZone(identifier: currentCityTimezone) else {
            return "day" // Default to day if the timezone is invalid
        }
        
        var calendar = Calendar.current
        calendar.timeZone = timezone
        
        let currentHour = calendar.component(.hour, from: Date())
        
        if currentHour >= 20 || currentHour < 5 { // Between 8 PM and 5 AM
            return "night"
        } else {
            return "day"
        }

    }
    
    func updateBackgroundBasedOnTime() {
        if checkTime() == "night" {
            self.background = "Background-night"
        } else {
            self.background = "Background-sunny-wind"
        }
    }
    
    func formatUnixTimestamp(_ timestamp: Int64, timeZone: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "E, MMM d, h:mm a"
        return dateFormatter.string(from: date)
    }
    
    func convertTimeToUserTimezone(utcTime: String, timezoneIdentifier: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // Input is UTC
        
        guard let date = dateFormatter.date(from: utcTime) else {
            print("Invalid time format")
            return "Default"
        }
        
        // Convert to user's timezone
        if let userTimezone = TimeZone(identifier: timezoneIdentifier) {
            dateFormatter.timeZone = userTimezone
            dateFormatter.dateFormat = "h:mm a" // Desired output format
            return dateFormatter.string(from: date)
        } else {
            print("Invalid timezone identifier")
            return "Default"
        }
    }
    
    func formatDateForecastWeather(_ datetime: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd" // Match the API format
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM d" // Desired output format, e.g., "Apr 29"
        
        guard let date = inputFormatter.date(from: datetime) else {
            return "Default" // Fallback to the raw datetime if parsing fails
        }
        
        return outputFormatter.string(from: date)
    }
    
    func getAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let apiKey = dict["APIKey"] as? String else {
            fatalError("Unable to find APIKey in Config.plist")
        }
        return apiKey
    }
    
    func getWeatherIcon(_ temperature: Int) -> String {
        switch temperature {
        case ..<0: // Below 0°C (Freezing weather)
            return "snowflake.circle.fill"
        case 0..<5: // 0°C to 5°C (Very cold weather)
            return "thermometer.snowflake"
        case 5..<15: // 5°C to 15°C (Cool weather)
            return "thermometer.low"
        case 15..<25: // 15°C to 25°C (Mild/comfortable weather)
            return "thermometer.medium"
        case 25..<30: // 25°C to 30°C (Warm weather)
            return "thermometer.sun.fill"
        case 30...: // 30°C onwards (Hot weather)
            return "thermometer.high"
        default: // Above 35°C (Very hot weather)
            if checkTime() == "night" { // Between 7 PM and 5 AM
                return "moon.stars.fill"
            }
            return "sun.max.fill"
        }
    }
    
    func thermometerColor(for highlowicon: String) -> Color {
        switch highlowicon {
        case "snowflake.circle.fill":
            return .blue
        case "thermometer.snowflake":
            return .blue
        case "thermometer.low":
            return .customIcon
        case "thermometer.medium":
            return .customSun
        case "thermometer.high":
            return .customSun
        case "moon.stars.fill":
            return .white
        default:
            return .customSun
        }
    }
    
    func convertKmToMi(_ kilometers: Int) -> Int {
        let miles = Double(kilometers) * 0.621371
        return Int(round(miles))
    }
    
    func convertMmToIn(_ millimeters: Int) -> Int {
        let inches = Double(millimeters) * 0.0393701
        return Int(round(inches))
    }
    
    func convertMpsToMph(_ metersPerSecond: Double) -> Int {
        let mph = metersPerSecond * 2.23694
        return Int(round(mph * 10))
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
    
    func updateColorScheme() {
        if checkTime() == "night" {
            isDarkMode = true
        } else {
            isDarkMode = false
        }
    }
    
    func fetchWeather(for city: String) {
        
        guard !city.isEmpty else {
            self.errorMessage = "City name cannot be empty."
            return
        }
        
        //        print("fetchWeather called for city: \(city)")
        
        errorMessage = nil
        isLoading = true // Start loading
        
        let apiKey = getAPIKey()
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        
        // Current Weather URL
        let weatherUrl = "https://api.weatherbit.io/v2.0/current?city=\(cityEncoded)&key=\(apiKey)"
        
        // Forecast URL
        let forecastUrl = "https://api.weatherbit.io/v2.0/forecast/daily?city=\(cityEncoded)&days=4&key=\(apiKey)"
        
        
        //        print("URL String: \(weatherUrl)")
        
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
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 404 {
                    DispatchQueue.main.async {
                        self.errorMessage = "City not found. Please check the city name and try again."
                    }
                    return
                } else if httpResponse.statusCode != 200 {
                    print("Error during HTTP Response: \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        self.errorMessage = "Server returned an error: \(httpResponse.statusCode)"
                    }
                    return
                }
                
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from server."
                }
                return
            }
            
            DispatchQueue.main.async {
                self.background = self.checkTime() == "night" ? "Background-night" : "Background-sunny-wind" // Default animation if no data
                self.backgroundicon = "None"
            }
            
            //            print("Received Data: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")
            
            do {
                // Decode JSON response
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                
                //                print("Weather Response: \(weatherResponse)")
                if let weather = weatherResponse.data.first {
                    DispatchQueue.main.async {
                        self.cityName = weather.city_name
                        if weather.state_code.isNumber {
                            self.cityNameFull = (weather.city_name + ", " + weather.country_code)
                        }else{
                            self.cityNameFull = (weather.city_name + ", " + weather.state_code + ", " + weather.country_code)
                        }
                        
                        self.temperature = Int(round(weather.temp))
                        self.windSpeed = self.convertMpsToMph(weather.wind_spd)
                        self.humidity = weather.rh
                        self.visibility = self.convertKmToMi(weather.vis)
                        self.weatherDescription = weather.weather.description
                        self.background = self.mapConditionToBackground(weather.weather.icon)
                        self.backgroundicon = self.mapConditionToBackgroundIcon(weather.weather.icon)
                        self.highlowicon = self.getWeatherIcon(self.temperature)
                        self.sunset = self.convertTimeToUserTimezone(utcTime: weather.sunset, timezoneIdentifier: weather.timezone)
                        self.sunrise = self.convertTimeToUserTimezone(utcTime: weather.sunrise, timezoneIdentifier: weather.timezone)
                        self.precipitation = self.convertMmToIn(weather.precip)
                        self.datetime = self.formatUnixTimestamp(weather.ts, timeZone: weather.timezone)
                        
                        //                        self.animationName = self.mapConditionToIcon(weather.weather.icon)
                        self.iconURL = URL(string: "https://www.weatherbit.io/static/img/icons/\(weather.weather.icon).png")
                        
                        // Update global timezone
                        self.currentCityTimezone = weather.timezone
                        
                        // Update background and theme
                        self.updateBackgroundBasedOnTime()
                        self.updateColorScheme()
                        
                        print("""
                            Debugging WeatherViewModel:
                            Theme: \(self.isDarkMode)
                            - cityNameFull: \(self.cityNameFull)
                            - temperature: \(self.temperature)
                            - weatherDescription: \(self.weatherDescription)
                            - background: \(self.background)
                            - backgroundicon: \(self.backgroundicon)
                            """)
                        
//                        print("""
//                                                    Debugging WeatherViewModel:
//                                                    - cityName: \(self.cityName)
//                                                    - cityNameFull: \(self.cityNameFull)
//                                                    - temperature: \(self.temperature)
//                                                    - windSpeed: \(self.windSpeed)
//                                                    - humidity: \(self.humidity)
//                                                    - visibility: \(self.visibility)
//                                                    - weatherDescription: \(self.weatherDescription)
//                                                    - background: \(self.background)
//                                                    - backgroundicon: \(self.backgroundicon)
//                                                    - highlowicon: \(self.highlowicon)
//                                                    - sunset: \(self.sunset)
//                                                    - sunrise: \(self.sunrise)
//                                                    - precipitation: \(self.precipitation)
//                                                    - datetime: \(self.datetime)
//                                                    - iconURL: \(self.iconURL?.absoluteString ?? "nil")
//                                                    """)
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
            //            print("Forcast Data: \(String(data: data, encoding: .utf8) ?? "Invalid Data")")
            
            do {
                let forecastResponse = try JSONDecoder().decode(WeatherForcastResponse.self, from: data)
                //                print("Forcast Response Data: \(forecastResponse) ")
                
                DispatchQueue.main.async {
                    // Map each forecast item to include a dynamically generated `id`
                    self.forecast = forecastResponse.data
                        .dropFirst()
                        .map{ forecastData in
                            IdentifiableWeatherForecastData(id: UUID(), forecast: forecastData)
                        }
                    
                    //                    print("Final Forecast data: \(self.forecast)" )
                }
                
            } catch {
                print("Error parsing forecast data \(error.localizedDescription)")
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
            if checkTime() == "night" {
                return "Background-night"
            } else {
                return "Background-sunny-wind"
            }
            
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
        case "s05d","s05n","s06d","s06n","a05d","a05n","a06d","a06n": return "cloud.sleet"
        case "a01d","a01n","a02d","a02n","a03d","a03n","a04d","a04n": return "smoke"
        case "c01d": return "sun.max"
        case "c01n": return "moon.fill"
        case "c02d", "c02n","c03d","c03n": return "cloud.sun"
        case "c04d","c04n": return "smoke"
        default:
            return "cloud"
        }
        
    }
    
    
    private func mapConditionToBackgroundIcon(_ icon: String) -> String {
        switch icon
        {
        case "t01d","t02d","t03d","t01n","t02n","t03n" : return "Background-rain"
        case "t04d","t04n","t05d","t05n": return "Background-rain"
        case "d01d","d01n","d02d","d02n","d03d","d03n": return "Background-rain"
        case "r01d", "r01n","r02d","r02n": return "Background-rain"
        case "r03d","r03n": return "Background-clouds"
        case "f01d","f01n","r04d","r04n","r05d","r05n","r06d","r06n": return "Background-rain"
        case "s01d","s01n","s02d","s02n","s03d","s03n","s04d","s04n": return "Background-snow"
        case "s05d","s05n","s06d","s06n","a05d" : return "Background-snow"
        case "a01d","a01n","a02d","a02n","a03d","a03n","a04d","a04n","a05n","a06d","a06n": return "None"
        case "c02d", "c02n","c03d","c03n": return "Background-clouds"
        case "c04d","c04n": return "None"
        default:
            return "None"
        }
        
    }
    
    private func mapConditionToBackground(_ icon: String) -> String {
        switch icon
        {
            //            Normal
        case "c01n" : return "Background-night"
        case "c01d" : return "Background-sunny"
            
            //            Rain
        case "r01n","r02n", "r03n","r04n","r05n","r06n","d01n","d03n","d02n","f01n": return "Background-raining"
        case "r01d","r02d", "r03d","r04d", "r05d","r06d","d01d","d02d","d03d", "f01d" : return "Background-raining"
            
        case "c02d", "c03d": return "Background-light-cloud"
        case "c02n","c03n": return "Background-night-cloudy"
        case "a01d","a01n","a02d","a02n","a03d","a03n","a04d","a04n", "c04d","c04n": return "Background-sunny-wind"
            
            //          Snow
        case "s01n","s02n","s03n","s04n","s05n", "s06n","a05d","a06n" : return "Background-night-snow"
        case "s01d","s02d","s03d","s04d","s05d", "s06d","a05n","a06d" : return "Background-snow"
            
            
            //            Thunderstrom
        case "t01n","t02n","t03n","t04n","t05n": return "Background-thunderstrom"
        case "t01d","t02d","t03d","t04d","t05d"  : return "Background-thunderstrom"
            
            
        default:
            if checkTime() == "night" {
                return "Background-night"
            }
            return "Background-sunny-wind"
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
