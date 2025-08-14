import SwiftUI
import MapKit
import PopupView

struct HomeView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var path = NavigationPath()
    @StateObject private var viewModel = HomeViewModel()
    @StateObject var locationManagerPinService = LocationManager()
    @State private var showPopup = false
    @State private var showPopupSave = false
    @State private var showPopupSaveLocation = false
    @State private var showPopupRouteLocation = false
    @State private var showPopupShare = false
    @EnvironmentObject var tabBarManager: TabBarManager
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject private var weatherModel = WeatherViewModel()
    @State private var searchText = ""
    @State private var alertPurchase = false
    @State private var messageFail = "No results"
    @FocusState private var isFocused: Bool
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                MapView(mapView: $viewModel.mapView, onTapLocation: { coordinate in
                    print("User tapped at: \(coordinate.latitude), \(coordinate.longitude)")
                    LocationHelperHandler.shared.locationSave =  LocationHelperHandler.shared.locationTap
                    withAnimation {
                        tabBarManager.isTabBarHidden = true
                    }
                    showPopup.toggle()
                })
                .ignoresSafeArea()
                .onAppear {
                    if appVM.hasSeenOnboarding{
                        viewModel.onSuccessLocation = { location in
                            print("Got location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                            weatherModel.loadWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                        }
                        viewModel.checkPermissions()
                        viewModel.onTapLocation = { location in
                            LocationHelperHandler.shared.locationSave =  location
                            withAnimation {
                                tabBarManager.isTabBarHidden = true
                            }
                            showPopup.toggle()
                        }
                    }
                    
                    
                }
                .onChange(of: OnboardingsManagerHandler.shared.isShowing) { isOnbarding in
                    if isOnbarding {
                        // Quay lại HomeView
                        print("Returned to HomeView")
                        viewModel.onSuccessLocation = { location in
                            print("Got location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                            weatherModel.loadWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                        }
                        viewModel.onTapLocation = { location in
                            LocationHelperHandler.shared.locationSave =  location
                            withAnimation {
                                tabBarManager.isTabBarHidden = true
                            }
                            showPopup.toggle()
                        }
                        viewModel.checkPermissions()
                    }
                }
                VStack {
                    topBar.padding(.top, 0)
                    if let weather = weatherModel.weather {
                        weatherBar(weather)
                    }
                   
                    Spacer()
                    mapActionButtons
                    addButton
                }
                
                if showPopupSave {
                    Color.black.opacity(0.4).ignoresSafeArea()
                    AlertSaveLocationView {
                        withAnimation {
                            showPopupSave = false
                        }
                    } onYes: {
                        showPopupSave = false
                        showPopupSaveLocation = true
                    }
                    .transition(.scale)
                }
            }
            .animation(.easeInOut, value: showPopupSave)
            //POPUP
            .popup(isPresented: $showPopup) {
               
                BottomPopupView() {
                    showPopup.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        path.append("saveLocation")
                    }
                } onShare: {
                    showPopup.toggle()
                    showPopupShare = true
                } onSave: {
                    showPopup.toggle()
                    showPopupSave = true
                } onRoute: {
                    showPopup.toggle()
                    showPopupRouteLocation = true
                }
            }  customize: {
                $0
                    .type(.floater())
                    .position(.bottom)
                    .animation(.spring(duration: 0.3))
                    .closeOnTapOutside(true)
                    .closeOnTap(false)
                    .allowTapThroughBG(false)
                    .dismissCallback {
                        withAnimation {
                            tabBarManager.isTabBarHidden = false
                        }
                        viewModel.removeAllAnnotations()
                    }
                    .backgroundView({
                        Rectangle()
                            .fill(.ultraThinMaterial).opacity(0.9)
                               .ignoresSafeArea()
                    })
            }
            
            .popup(isPresented: $showPopupShare) {
                ShareLocationPopup (isPresented:$showPopupShare, locationCore: nil , onEmail: {
                    
                }, onMessage: {
                    
                }, onCopy: {
                    
                }, onShareviaWhatapp: {
                    
                }, onShareviaInstagram: {
                    
                }, onShareviaMessager: {
                    
                }, onShareKML: {
                    
                })
            }  customize: {
                $0
                    .type(.floater())
                    .position(.bottom)
                    .animation(.spring(duration: 0.3))
                    .closeOnTapOutside(true)
                    .closeOnTap(false)
                    .allowTapThroughBG(false)
                    .backgroundView({
                        Rectangle()
                            .fill(.ultraThinMaterial).opacity(0.9)
                               .ignoresSafeArea()
                    })
            }
            
            .popup(isPresented: $showPopupSaveLocation) {
                SaveLocationPopup(isPresented: $showPopupSaveLocation)
            }  customize: {
                $0
                    .type(.floater())
                    .position(.bottom)
                    .animation(.spring(duration: 0.3))
                    .closeOnTapOutside(true)
                    .closeOnTap(false)
                    .allowTapThroughBG(false)
                    .backgroundView({
                        Rectangle()
                            .fill(.ultraThinMaterial).opacity(0.9)
                               .ignoresSafeArea()
                    })
            }
            .popup(isPresented: $showPopupRouteLocation) {
                RedirectLocationPopup(isPresented: $showPopupRouteLocation, locationCore: nil) {
                    
                } onApple: {
                    
                } onWaze: {
                    
                }
                
            }  customize: {
                $0
                    .type(.floater())
                    .position(.bottom)
                    .animation(.spring(duration: 0.3))
                    .closeOnTapOutside(true)
                    .closeOnTap(false)
                    .allowTapThroughBG(false)
                    .backgroundView({
                        Rectangle()
                            .fill(.ultraThinMaterial).opacity(0.9)
                               .ignoresSafeArea()
                    })
            }
            .popup(isPresented: $alertPurchase) {
                AlertPurchaseView(type: .fail, message: messageFail)
            } customize: {
                $0
                    .type(.toast)
                    .position(.top)
                    .autohideIn(2)
                    .closeOnTapOutside(true)
                    .dragToDismiss(true)
                    .backgroundColor(.clear)
            }
            
            .ignoresSafeArea(.keyboard)
            .navigationDestination(for: String.self) { value in
                switch value {
                case "saveLocation":
                    SaveLocationView(path: $path)
                default:
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Components
    
    private var topBar: some View {
        HStack {
            HStack(spacing: 8) {
                Image("ic_search_map")
                TextField("Search here", text: $searchText)
                    .foregroundColor(.white)
                    .font(.appFontRegular(15))
                    .keyboardType(.alphabet)
                    .submitLabel(.search)
                    .focused($isFocused)
                    .onSubmit {
                        if !searchText.trimmed.isEmpty{
                            searchAddress(searchText.trimmed) { mapItems in
                                if mapItems.isEmpty{
                                    alertPurchase.toggle()
                                }
                                else{
                                    viewModel.pinAppToSearch(locationSearch: mapItems[0].placemark.location ?? CLLocation())
                                }
                            }
                        }
                        
                    }
                    .overlay(
                        HStack {
                            Spacer()
                            if isFocused && !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.white50)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                    )
               
            }
            .padding(.leading, 15)
            .padding(.vertical, 15)
            .background(Color.black.opacity(0.8))
            .cornerRadius(.infinity)
            .background(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(isFocused ? Color(hex: "9C23FF") : Color.clear)
            )
           // .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
    private func weatherBar(_ weather: WeatherResponse) -> some View {
        HStack {
            HStack(spacing: 8) {
                let icon = weather.current.weather.first?.icon ?? "01d"
                AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 24, height: 24)
                Text("\(Int(weather.current.temp))°")
                    .foregroundColor(.white)
                    .font(.appFontMedium(15))
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Color.black.opacity(0.8))
            .clipShape(Capsule())
            Spacer()
        }
        .padding(.leading)
        .padding(.top, 8)
    }
    
    private var mapActionButtons: some View {
        HStack {
            Spacer()
            VStack(spacing: 0) {
                Button {
                    // Map action
                    viewModel.toggleMapType()
                } label: {
                    Image("icMap")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                }
                
                Divider().background(Color.white.opacity(0.3))
                
                Button {
                    // Location action
                    viewModel.centerToUser()
                } label: {
                    Image("current_location")
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                }
            }
            .background(Color.black.opacity(0.9))
            .clipShape(Capsule())
            .frame(width: 50)
        }
        .padding(.horizontal, 20)
    }
    
    private var addButton: some View {
        HStack {
            Spacer()
            Button {
                LocationHelperHandler.shared.locationSave =  LocationHelperHandler.shared.locationCurrent
                withAnimation {
                    tabBarManager.isTabBarHidden = true
                }
                showPopup.toggle()
            } label: {
                Image("icAdd")
                    .padding(.horizontal, 15)
            }
        }
        .padding(.bottom, 60)
    }
    
    
    func searchAddress(_ query: String, completion: @escaping ([MKMapItem]) -> Void) {
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Search error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            if let items = response?.mapItems {
                completion(items)
            } else {
                completion([])
            }
        }
    }
    
}
