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

struct IdentifiableWeatherForecastData: Identifiable {
    let id: UUID
    let forecast: WeatherForecastData
}


struct WeatherForcastResponse: Decodable {
    let city_name: String
    let country_code: String
    let data: [WeatherForecastData]
    let state_code: String
    let timezone: String
}


struct WeatherForecastData: Decodable {
    //        let app_max_temp: Double?
    //        let app_min_temp: Double?
    //        let clouds: Int?
    //        let clouds_hi: Int?
    //        let clouds_low: Int?
    //        let clouds_mid: Int?
    let datetime: String
    //        let dewpt: Double?
    //        let high_temp: Double
    //        let low_temp: Double
    //        let max_temp: Double
    //        let min_temp: Double
    //        let moon_phase: Double?
    //        let moon_phase_lunation: Double?
    //        let moonrise_ts: Int64?
    //        let moonset_ts: Int64?
    //        let ozone: Int?
    //        let pop: Int?
    //        let precip: Double
    //        let pres: Double
    //        let rh: Int
    //        let slp: Double?
    //        let snow: Double
    //        let snow_depth: Double
    //        let sunrise_ts: Int64
    //        let sunset_ts: Int64
    let temp: Double
    //        let ts: Int64
    //        let uv: Double
    //        let valid_date: String
    //        let vis: Double
    let weather: WeatherCondition
    //        let wind_cdir: String
    //        let wind_cdir_full: String
    //        let wind_dir: Int
    //        let wind_gust_spd: Double?
    //        let wind_spd: Double
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
