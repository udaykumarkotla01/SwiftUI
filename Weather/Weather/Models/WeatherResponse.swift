//
//  WeatherResponse.swift
//  Weather
//
//  Created by Uday Kumar Kotla on 11/12/25.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherResponse = try? JSONDecoder().decode(WeatherResponse.self, from: jsonData)


// This is entire responscs that can come from API.

import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let location: Location
    let current: Current
}

// MARK: - Current
struct Current: Codable {
    let lastUpdatedEpoch: Int
    let lastUpdated: String
    let tempC: Double
    let tempF, isDay: Int
    let condition: Condition
    let windMph, windKph: Double
    let windDegree: Int
    let windDir: String
    let pressureMB: Int
    let pressureIn: Double
    let precipMm, precipIn, humidity, cloud: Int
    let feelslikeC, feelslikeF, windchillC, windchillF: Double
    let heatindexC, heatindexF, dewpointC, dewpointF: Double
    let visMiles: Int
    let uv: Double

    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMB = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case visMiles = "vis_miles"
        case uv
    }
}



// MARK: - Condition
struct Condition: Codable {
    let text, icon: String
    let code: Int
}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String
    let lat, lon: Double
    let tzID: String
    let localtimeEpoch: Int
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}


/**
 // Example response:
 {
     "location": {
         "name": "London",
         "region": "City of London, Greater London",
         "country": "United Kingdom",
         "lat": 51.5171,
         "lon": -0.1062,
         "tz_id": "Europe/London",
         "localtime_epoch": 1765381103,
         "localtime": "2025-12-10 15:38"
     },
     "current": {
         "last_updated_epoch": 1765380600,
         "last_updated": "2025-12-10 15:30",
         "temp_c": 12.2,
         "temp_f": 54.0,
         "is_day": 1,
         "condition": {
             "text": "Sunny",
             "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
             "code": 1000
         },
         "wind_mph": 11.4,
         "wind_kph": 18.4,
         "wind_degree": 249,
         "wind_dir": "WSW",
         "pressure_mb": 1017.0,
         "pressure_in": 30.03,
         "precip_mm": 0.0,
         "precip_in": 0.0,
         "humidity": 67,
         "cloud": 25,
         "feelslike_c": 10.3,
         "feelslike_f": 50.5,
         "windchill_c": 9.2,
         "windchill_f": 48.5,
         "heatindex_c": 11.3,
         "heatindex_f": 52.3,
         "dewpoint_c": 6.5,
         "dewpoint_f": 43.7,
         "vis_km": 10.0,
         "vis_miles": 6.0,
         "uv": 0.1,
         "gust_mph": 16.3,
         "gust_kph": 26.3,
         "short_rad": 160.58,
         "diff_rad": 50.58,
         "dni": 1252.34,
         "gti": 0.0
     }
 }
 
 */
