//
//  WeatherCard.swift
//  Weather
//
//  Created by Uday Kumar Kotla on 12/12/25.
//

import SwiftUI

struct WeatherCard: View {
    let weather : WeatherResponse
    var urlString : String {
        "https:\(weather.current.condition.icon)"
    }
    var body: some View {
        VStack{
            AsyncImage(url: URL(string: urlString)) { Image in
                Image.resizable().scaledToFit().frame(width: 100, height: 100)
                Text("\(weather.location.localtime)").font(.caption).bold().foregroundStyle(.opacity(0.7))
            } placeholder: {
                ProgressView()
            }
            Text("\(weather.location.name) , \(weather.location.country)")
                .font(.title2).bold()
            Text("\(weather.current.tempC , specifier : "%.1f")°C") .font(.largeTitle).bold()
            Text("\(weather.current.condition.text)").font(.headline).foregroundStyle(.white.opacity(0.9))
        
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(LinearGradient(colors: [.blue,.teal], startPoint: .leading, endPoint: .trailing))
        .clipShape(.rect(cornerRadius: 20))
        .shadow(radius: 10)
    }
}

//#Preview {
//    WeatherCard(weather: weatherResponse)
//}
