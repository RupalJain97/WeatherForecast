//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/25/24.
//

struct WeatherResponse: Decodable {
    let data: [WeatherData]
}

struct WeatherData: Decodable {
    let city_name: String
    let temp: Double
    let weather: WeatherCondition
    let humidity: Double
    let wind_spd: Double
    let vis: Double
}

struct WeatherCondition: Decodable {
    let icon: String
    let description: String
}
