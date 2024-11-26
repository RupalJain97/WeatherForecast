//
//  WeatherViewModel.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/25/24.
//

import Foundation

// ViewModel to handle API calls and data
class WeatherViewModel: ObservableObject {
    @Published var cityName: String = ""
    @Published var temperature: Double = 0.0
    @Published var condition: String = ""
    @Published var iconURL: URL? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    func getAPIKey() -> String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let apiKey = dict["APIKey"] as? String else {
            fatalError("Unable to find APIKey in Config.plist")
        }
        return apiKey
    }
    
    func fetchWeather(for city: String) {
        errorMessage = nil
        isLoading = true // Start loading
        let apiKey = getAPIKey()
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.weatherbit.io/v2.0/current?city=\(cityEncoded)&key=\(apiKey)"
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
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to fetch weather. Try again!"
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
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
                        self.cityName = weather.city_name
                        self.temperature = weather.temp
                        self.condition = weather.weather.description
                        self.iconURL = URL(string: "https://www.weatherbit.io/static/img/icons/\(weather.weather.icon).png")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to parse weather data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
}
