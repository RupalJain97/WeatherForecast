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

    func fetchWeather(for city: String) {
        let apiKey = "8cb5733e1cd54ac2a23cd20fc666945f"
        let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? city
        let urlString = "https://api.weatherbit.io/v2.0/current?city=\(cityEncoded)&key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        print("Fetching weather from URL: \(urlString)")

        // API Request
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching weather: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Response Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("No data received")
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
                    }
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
