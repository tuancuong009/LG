//
//  WeatherView.swift
//  LG
//
//  Created by QTS Coder on 1/8/25.
//

import SwiftUI

struct WeatherView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject private var viewModel = WeatherViewModel()
    @State private var location: LocationInfo? = nil
    var body: some View {
        NavigationStack{
            ZStack {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        headerSection
                        if location == nil{
                            VStack(spacing: 10) {
                                Image("ic_fail")
                                Text("Permission denied")
                                    .font(.appFontSemibold(20))
                                    .foregroundColor(.white)

                                Text("Please enable Location Services in Settings > Privacy > Location Services.")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.white50)
                                    .font(.appFontRegular(15))
                                VStack{
                                    Button(action: {
                                        if let url = URL(string: UIApplication.openSettingsURLString) {
                                            UIApplication.shared.open(url)
                                        }
                                    }) {
                                        Text("Settings")
                                            .font(.appFontSemibold(16))
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(LinearGradient(colors: [Color(hex: "9C23FF"), Color(hex: "AA55FF")], startPoint: .leading, endPoint: .trailing))
                                            .foregroundColor(.white100)
                                            .cornerRadius(25)
                                    }
                                }
                               .padding(.top, 20)
                            } .padding(.horizontal, 20)
                        }
                        else{
                            if let weather = viewModel.weather {
                                weatherIconSection(weather)
                                weatherMiniInfoSection(weather)
                                feelsLikeSection(weather)
                                currentConditionsSection(weather)
                            } else {
                                ProgressView().padding()
                            }
                        }
                        
                    }.padding(.bottom, safeAreaInsets.bottom + 40)
                }
            }
            
            .backgroundImage("bgAll2")
            .navigationBarHidden(true)
            .onAppear {
                self.location = LocationHelperHandler.shared.locationCurrent
                guard let location = location else{
                    return
                }
                viewModel.loadWeather(lat: location.latitude, lon: location.longitude)
            }
        }
        
    }
    
    private var headerSection: some View {
        HStack {
            Text("Weather")
                .font(.appFontSemibold(32))
                .foregroundColor(.white)
            Spacer()
            VStack(alignment: .trailing) {
                Text(self.location?.city ?? "")
                    .font(.appFontMedium(17))
                    .foregroundColor(.white)
                if let dt = viewModel.weather?.current.dt {
                    Text(formatDate(dt))
                        .font(.appFontRegular(13))
                        .foregroundColor(.white50)
                }
            }
        }
        .padding(.horizontal)
    }

    private func weatherIconSection(_ weather: WeatherResponse) -> some View {
        VStack(spacing: 0) {
            let icon = weather.current.weather.first?.icon ?? "01d"
            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                image.resizable().scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 100, height: 100)

            Text("\(Int(weather.current.temp))°")
                .font(.appFontSemibold(41))
                .foregroundColor(.white)

            Text(weather.current.weather.first?.description.capitalized ?? "")
                .font(.appFontMedium(15))
                .foregroundColor(.white)
        }
    }

    
    private func weatherMiniInfoSection(_ weather: WeatherResponse) -> some View {
        HStack(spacing: 12) {
            WeatherMiniInfo(icon: "w_ms", value: String(format: "%.1fm/s %@", weather.current.wind_speed, windDirection(weather.current.wind_deg)))
                .frame(maxWidth: .infinity)
            WeatherMiniInfo(icon: "w_percent", value: "\(weather.current.humidity)%")
                .frame(maxWidth: .infinity)
            WeatherMiniInfo(icon: "w_km", value: String(format: "%.1fkm", Double(weather.current.visibility)/1000))
                .frame(maxWidth: .infinity)
        }
    }
    private func feelsLikeSection(_ weather: WeatherResponse) -> some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Feels like")
                        .font(.appFontRegular(15))
                        .foregroundColor(.white50)
                    Spacer()
                    Image("w_feels")
                }
                Text("\(Int(weather.current.feels_like))°")
                    .foregroundColor(.white)
                    .font(.appFontSemibold(20))
                Spacer()
                Text(weather.current.weather.first?.description.capitalized ?? "")
                    .foregroundColor(.white50)
                    .font(.appFontMedium(13))
            }
            .padding()
            .frame(maxHeight: .infinity)
            .background(Color.white.opacity(0.05))
            .cornerRadius(12)

            VStack {
                WeatherBox(title: "Sunrise", value: formatTime(weather.current.sunrise), subtitle: "", icon: "w_sunrise")
                WeatherBox(title: "Sunset", value: formatTime(weather.current.sunset), subtitle: "", icon: "w_sunset")
            }
        }
        .padding(.horizontal)
    }
    private func currentConditionsSection(_ weather: WeatherResponse) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Current Conditions")
                .font(.appFontSemibold(20))
                .foregroundColor(.white)
                .padding(.horizontal)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                WeatherCard(icon: "w_uv", title: "UV", value: "\(weather.current.uvi)", color: .yellow, imageLine: "line_uv")
                WeatherCard(icon: "w_wind", title: "Wind", value: String(format: "%.1fm/s", weather.current.wind_speed), color: .blue, imageLine: "line_wind")
                WeatherCard(icon: "w_humidity", title: "Humidity", value: "\(weather.current.humidity)%", color: .purple, imageLine: "line_humidity")
                WeatherCard(icon: "w_dew", title: "Dew Point", value: "\(Int(weather.current.dew_point))°C", color: .cyan, imageLine: "line_dew")
                WeatherCard(icon: "w_pressure", title: "Pressure", value: "\(weather.current.pressure)hPa", color: .orange, imageLine: "line_pressure")
                WeatherCard(icon: "w_visible", title: "Visibility", value: String(format: "%.1fkm", Double(weather.current.visibility)/1000), color: .pink, imageLine: "line_visible")
            }
            .padding(.horizontal)
        }
    }
    private func formatDate(_ time: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, hh:mma"
        return formatter.string(from: date)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: time)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func windDirection(_ deg: Double) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((deg + 22.5) / 45.0) % 8
        return directions[index]
    }

}
