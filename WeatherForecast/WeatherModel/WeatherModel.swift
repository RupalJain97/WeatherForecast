//
//  WeatherModel.swift
//  WeatherForecast
//
//  Created by Rupal Jain on 11/25/24.
//

import Foundation

struct WeatherResponse: Decodable {
    let data: [WeatherData]
}

struct WeatherForcastResponse: Decodable {
    let data: [WeatherForecastData]
}

struct WeatherForecastData: Decodable , Identifiable{
    var id = UUID()
    let temp: Double
    let datetime: String
    let weather: WeatherCondition
    
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd:HH" // Match the API format
        guard let date = dateFormatter.date(from: datetime) else { return datetime }
        
        dateFormatter.dateFormat = "d" // Desired output format
        return dateFormatter.string(from: date)
    }
}

//                        let wind_cdir_full: String
//                        let wind_cdir: String
//                        let clouds : Int

struct WeatherData: Decodable {
    let city_name: String
    let temp: Double
    let weather: WeatherCondition
    let rh: Int
    let wind_spd: Double
    let vis: Int
    let sunrise: String
    let sunset: String
    let country_code : String
    let state_code : String
    let precip: Int
    let ts: Int64
    let timezone: String
}

struct WeatherCondition: Decodable {
    let icon: String
    let description: String
    let code: Int
}
