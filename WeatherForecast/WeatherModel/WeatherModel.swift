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
}

struct WeatherCondition: Decodable {
    let description: String
}


//struct Weather: Codable {
//    let location: Location
//    let current: Current
//}
//
//struct Location: Codable {
//    let name: String
//    let region: String
//    let country: String
//}
//
//struct Current: Codable {
//    let temp_c: Double
//    let condition: Condition
//}
//
//struct Condition: Codable {
//    let text: String
//    let icon: String
//}
