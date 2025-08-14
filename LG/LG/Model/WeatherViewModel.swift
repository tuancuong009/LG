//
//  WeatherViewModel.swift
//  LG
//
//  Created by QTS Coder on 7/8/25.
//
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherResponse?
    
    let service = WeatherService()
    
    func loadWeather(lat: Double, lon: Double) {
        service.fetchWeather(lat: lat, lon: lon) { [weak self] response in
            self?.weather = response
        }
    }
}
