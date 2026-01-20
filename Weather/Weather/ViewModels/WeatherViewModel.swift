//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Uday Kumar Kotla on 12/12/25.
//

import Foundation

@Observable
class WeatherViewModel{
    var city : String = ""
    var weather : WeatherResponse?
    var isLoading = false
    var errorMsg : String?
    @ObservationIgnored private let apiKey = API_Key
    
    func fetchWeatherData(city: String) async throws -> WeatherResponse{
        weather = nil
        errorMsg = nil
        isLoading = true
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(city)&aqi=no"
        guard let url = URL(string: urlString) else {
            isLoading = false
            throw WeatherError.invalidURL
        }
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else{
            isLoading = false
            throw WeatherError.unknown
        }
        guard httpResponse.statusCode == 200 else{
            isLoading = false
            throw WeatherError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        //Decode Model
        
        do{
            isLoading = false
            return try JSONDecoder().decode(WeatherResponse.self, from: data)
        } catch{
            isLoading = false
            throw WeatherError.decodingFailed
        }
    }
    
}

//Error Hnadling

enum WeatherError: LocalizedError{
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingFailed
    case unknown
    
    var errorDescription: String?
    {
        switch self {
        case .invalidURL:
            return "Invalid Error"
        case .requestFailed(statusCode: let statusCode):
            return "Request Failed with status code: \(statusCode)"
        case .decodingFailed:
            return "Decoding Failed"
        case .unknown:
            return "Undknown Error"
        }
    }
}





/**
REF: Alternative to fetchn api
 
URLSession.shared.dataTask(with: url) { (data, response, error) in
    if let error = error {
        self.errorMsg = "Error fetching data: \(error.localizedDescription)"
        self.isLoading = false
        return
    }
    guard let data else{
        self.errorMsg = "Error fetching data"
        self.isLoading = false
        return
    }
    do{
        let res = try JSONDecoder().decode(WeatherResponse.self, from: data)
        self.weather = res
        self.isLoading = false
    }catch{
        self.errorMsg = "Error parsing data: \(error.localizedDescription)"
        self.isLoading = false
    }
    
}.resume()

*/
