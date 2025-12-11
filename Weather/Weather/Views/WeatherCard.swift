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

#Preview {
    let weatherResponse = WeatherResponse(
        location: Location(
            name: "London",
            region: "City of London, Greater London",
            country: "United Kingdom",
            lat: 51.5171,
            lon: -0.1062,
            tzID: "Europe/London",
            localtimeEpoch: 1765381103,
            localtime: "2025-12-10 15:38"
        ),
        current: Current(
            lastUpdatedEpoch: 1765380600,
            lastUpdated: "2025-12-10 15:30",
            tempC: 12.2,
            tempF: 54,
            isDay: 1,
            condition: Condition(
                text: "Sunny",
                icon: "//encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjWWdL6XnwqCRfcX4Bc5pARRskGhoKfheIrA&s",
                code: 1000
            ),
            windMph: 11.4,
            windKph: 18.4,
            windDegree: 249,
            windDir: "WSW",
            pressureMB: 1017,
            pressureIn: 30.03,
            precipMm: 0,
            precipIn: 0,
            humidity: 67,
            cloud: 25,
            feelslikeC: 10.3,
            feelslikeF: 50.5,
            windchillC: 9.2,
            windchillF: 48.5,
            heatindexC: 11.3,
            heatindexF: 52.3,
            dewpointC: 6.5,
            dewpointF: 43.7,
            visMiles: 6,
            uv: 0.1
        )
    )

    WeatherCard(weather: weatherResponse)
}
