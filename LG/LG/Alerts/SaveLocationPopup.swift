//
//  SaveLocationPopup.swift
//  LG
//
//  Created by QTS Coder on 4/8/25.
//


import SwiftUI
import PopupView
struct SaveLocationPopup: View {
    @Binding var isPresented: Bool
    @State private var locationName: String = ""
    @State private var isEditLocationName = false
    @FocusState private var isLocationFocused: Bool
    @State private var location: LocationInfo? = nil
   
    var body: some View {
        VStack(spacing: 20) {
            // Title + Close
            HStack {
                Text("Save Location")
                    .font(.appFontSemibold(20))
                    .foregroundColor(.white)
                Spacer()
                Button {
                    withAnimation {
                        isPresented = false
                    }
                } label: {
                    Image("btnClose")
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Location name")
                    .foregroundColor(.white)
                    .font(.appFontMedium(17))
                TextField("Enter Location name", text: $locationName, onEditingChanged: { editing in
                    if editing {
                        isEditLocationName = true
                    } else {
                        isEditLocationName = false
                    }
                })
                .focused($isLocationFocused)
                .submitLabel(.done) // set return key
                .onSubmit {
                    isLocationFocused = false
                    // Handle submit action here if needed
                }
                .keyboardType(.alphabet)
                .autocapitalization(.words)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke( isEditLocationName ? Color.init(hex: "9C23FF") : Color.white15))
                .foregroundColor(.white)
                .font(.appFontMedium(15))
                .overlay(
                    HStack {
                        Spacer()
                        if isLocationFocused && !locationName.isEmpty {
                            Button(action: {
                                locationName = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white50)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
            }
            .padding(.horizontal, 0)

            // Save Button
            Button {
                // Save action
                saveLocationCoreData(locationName.trimmed)
            } label: {
                if locationName.trimmed.isEmpty{
                    Text("Save Location")
                        .foregroundColor(.white.opacity(0.3))
                        .font(.appFontSemibold(16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(locationName.isEmpty ? 0.05 : 0.15))
                        )
                }
                else{
                    Text("Save Location")
                        .font(.appFontSemibold(16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color(hex: "9C23FF"), Color(hex: "AA55FF")], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white100)
                        .cornerRadius(25)
                }
                
            }
            .disabled(locationName.trimmed.isEmpty)
            .padding(.bottom, 40)
            
        }
        
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                .backgroundImage("bgPopUp").cornerRadius(20)
        )
        .padding(.horizontal, 0)
        .padding(.bottom, -50)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isLocationFocused = true
            }
            self.location = LocationHelperHandler.shared.locationSave
            locationName = location?.name ?? ""
        }
        
    }
    
    private func saveLocationCoreData(_ title: String){
        guard let  location = location else{
            return
            
        }
        let locationObj = LocationModelHelper.shared.createObjectLocation(id: UUID().uuidString, title: title, address: location.address, image: nil, lat: location.latitude, long: location.longitude, height: LocationHelperHandler.shared.heightLocation, createdAt: Date().timeIntervalSince1970)
        _ = CoreDataManager.shared.saveLocation(location: locationObj)
        isPresented = false
        OnboardingsManagerHandler.shared.isSaveLocationSuccess = true
        
    }
}
