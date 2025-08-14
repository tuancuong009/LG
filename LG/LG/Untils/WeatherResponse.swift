//
//  WeatherResponse.swift
//  Loc Changer
//
//  Created by Trung Ng on 8/5/25.
//


import Foundation
import CoreLocation

struct WeatherResponse: Codable {
    let current: CurrentWeather
    let timezone: String
}

struct CurrentWeather: Codable {
    let temp: Double
    let feels_like: Double
    let humidity: Int
    let pressure: Int
    let wind_speed: Double
    let wind_deg: Double
    let uvi: Double
    let dew_point: Double
    let visibility: Int
    let sunrise: TimeInterval
    let sunset: TimeInterval
    let dt: TimeInterval
    let weather: [WeatherCondition]
}

struct WeatherCondition: Codable {
    let description: String
    let icon: String
}
class WeatherService {
    let apiKey = CONFIG.WEATHER_API

    func fetchWeather(lat: Double, lon: Double, completion: @escaping (WeatherResponse?) -> Void) {
        let urlStr = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=minutely,hourly,daily,alerts&appid=\(apiKey)"
        print(urlStr)
        guard let url = URL(string: urlStr) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(decoded)
                    }
                } catch {
                    print("Decode error: \(error)")
                    completion(nil)
                }
            } else {
                print("Network error: \(error?.localizedDescription ?? "Unknown")")
                completion(nil)
            }
        }.resume()
    }
}

