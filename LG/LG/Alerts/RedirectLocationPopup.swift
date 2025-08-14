//
//  RedirectLocationPopup.swift
//  LG
//
//  Created by QTS Coder on 4/8/25.
//

import SwiftUI
import MapKit
struct RedirectLocationPopup: View {
    @Binding var isPresented: Bool
    let locationCore: LocationObj?
    @State private var hasShowAlert = false
    @State private var messageFail = ""
    @State private var location: LocationInfo? = nil
    @State private var curentLocation: LocationInfo? = nil
    var onGoogle: () -> Void
    var onApple: () -> Void
    var onWaze: () -> Void
    var body: some View {
        
        VStack(spacing: 20) {
            HStack {
                
                Text("Draw Route")
                    .font(.appFontSemibold(20))
                    .foregroundColor(.white)
                Spacer()
                Button(action: {
                    isPresented = false
                }) {
                    Image("btnClose")
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            VStack(spacing: 16){
                HStack(spacing: 16) {
                    UploadOptionButton(
                        title: "Google Maps",
                        iconName: "icGoogle",
                        background: Color.white.opacity(0.05)) {
                            guard let location = self.location else{
                                return
                            }
                            guard let curent = self.curentLocation else{
                                return
                            }
                            MapNavigator.openGoogleMaps(from: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), to: CLLocationCoordinate2D(latitude: curent.latitude, longitude: curent.longitude)) { success in
                                if !success{
                                    messageFail = "Google Maps can not open. Please setup it."
                                    hasShowAlert = true
                                }
                            }
                        }
                   
                    UploadOptionButton(
                        title: "Apple Maps",
                        iconName: "icApple",
                        background: Color.white.opacity(0.05)) {
                            guard let location = self.location else{
                                return
                            }
                            guard let curent = self.curentLocation else{
                                return
                            }
                            MapNavigator.openAppleMaps(from: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), to: CLLocationCoordinate2D(latitude: curent.latitude, longitude: curent.longitude)) { success in
                                if !success{
                                    messageFail = "Apple Maps can not open. Please setup it."
                                    hasShowAlert = true
                                }
                            }
                        }
                }.padding(.horizontal)
                
                HStack(spacing: 16) {
                    UploadOptionButton(
                        title: "Waze",
                        iconName: "icWaze",
                        background: Color.white.opacity(0.05)) {
                            guard let location = self.location else{
                                return
                            }
                            guard let curent = self.curentLocation else{
                                return
                            }
                            MapNavigator.openWaze(from: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude), to: CLLocationCoordinate2D(latitude: curent.latitude, longitude: curent.longitude)) { success in
                                if !success{
                                    messageFail = "Waze can not open. Please setup it."
                                    hasShowAlert = true
                                }
                            }
                        }
                    Color.clear.frame(height: 90)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            if let locationCore = locationCore{
                self.location = LocationInfo(name: locationCore.title, latitude: locationCore.lat, longitude: locationCore.long, address: locationCore.address, city: "")
               
            }
            else{
                
                self.location = LocationHelperHandler.shared.locationSave
            }
            self.curentLocation = LocationHelperHandler.shared.locationCurrent
        }
        .alertPurchasePopup(isPresented: $hasShowAlert, type: .fail, message: messageFail)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white10, lineWidth: 1)
                .backgroundImage("bgPopUp"))
        .cornerRadius(20)
        .padding(.horizontal, 0)
        .padding(.bottom, -50)
    }
    
}
