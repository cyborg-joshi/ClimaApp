//
//  WeatherData.swift
//  Clima
//
//  Created by KANISHK on 22/01/24.


import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let id : Int
}
