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
    let data: [WeatherForecastData]
}

struct WeatherForecastData: Decodable {
    let temp: Double
    let datetime: String
    let weather: WeatherCondition
}

//                        let wind_cdir_full: String
//                        let wind_cdir: String
//                        let clouds : Int

struct WeatherData: Decodable {
    let city_name: String
    let temp: Double
    let weather: WeatherCondition
    let rh: Double
    let wind_spd: Double
    let vis: Double
    let sunrise: String
    let sunset: String
    let country_code : String
    let state_code : String
    let precip: Double
    let ts: Int64
}

struct WeatherCondition: Decodable {
    let icon: String
    let description: String
    let code: Int
}
