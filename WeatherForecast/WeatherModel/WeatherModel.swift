//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/25/24.
//

struct WeatherResponse: Decodable {
    let data: [WeatherData]
}

struct WeatherForcastResponse: Decodable {
    let data: [WeatherForecast]
}

struct WeatherForecast: Decodable {
    let temp: Double
    let datetime: String
    let weather: WeatherCondition
}

struct WeatherData: Decodable {
    let city_name: String
    let temp: Double
    let weather: WeatherCondition
    let humidity: Double
    let wind_spd: Double
    let wind_cdir_full: String
    let wind_cdir: String
    let vis: Double
    let sunrise: String
    let timezone : String
    let clouds : Int
}

struct WeatherCondition: Decodable {
    let icon: String
    let description: String
}
