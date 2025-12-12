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
    
    func fetchWeatherData(city: String) async{
        isLoading = true
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(city)&aqi=no"
        guard let url = URL(string: urlString) else {
            errorMsg = "Failed to fetch data from URL"
            isLoading = false
            return
        }
        
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
        
        
    }
    
}
