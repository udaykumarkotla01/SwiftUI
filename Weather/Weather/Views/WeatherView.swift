//
//  WeatherView.swift
//  Weather
//
//  Created by Uday Kumar Kotla on 12/12/25.
//

import SwiftUI

struct WeatherView: View {
    @State private var vm = WeatherViewModel()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    TextField("Enter City Name", text: $vm.city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button{
                        Task{
                            do{
                                vm.weather =  try await vm.fetchWeatherData(city: vm.city)
                            } catch{
                                vm.errorMsg = error.localizedDescription
                            }
                        }
                    }label:
                    {
                        Label("Get Weather", systemImage: "cloud.sun.fill")
                    }.buttonStyle(.borderedProminent)
                    
                    if(vm.isLoading){
                        ProgressView()
                    }
                    else if let weather = vm.weather{
                        WeatherCard(weather: weather)
                    }else if let error = vm.errorMsg{
                        Text(error).foregroundStyle(.red)
                    }
                    Spacer()
                }.navigationTitle("Weather")
                    .padding()
            }
        }
    }
}

#Preview {
    WeatherView()
}
