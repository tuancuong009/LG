//
//  SaveLocationView.swift
//  LG
//
//  Created by QTS Coder on 1/8/25.
//


import SwiftUI
import PopupView
struct SaveLocationView: View {
    @Binding var path: NavigationPath
    @State private var locationName = ""
    @State private var address = ""
    @State private var image: UIImage?
    @State private var showImagePicker = false
    @State private var isEditLocationName = false
    @FocusState private var isFocused: Bool
    @EnvironmentObject var tabBarManager: TabBarManager
    @State private var showPicker = false
    @State private var pickerSource: UIImagePickerController.SourceType = .photoLibrary
    @State private var showPopup = false
    @State private var showPopupSuccess = false
    @State private var popupDataFail =  AlertPopupData(
        iconName: "ic_fail",
        title: "Alert",
        message: "Please add location title and address title."
    )
    @State private var popupDataSuccess  = AlertPopupData(
        iconName: "ic_success",
        title: "Successful",
        message: "Location successfully saved"
    )
    @State private var location: LocationInfo? = nil
    @FocusState private var focusedField: Field?
    enum Field {
        case locationName
        case address
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Header
                ZStack {
                    Text("Save Location")
                        .font(.appFontSemibold(20))
                        .foregroundColor(.white)
                    
                    HStack {
                        Button(action: {
                            path.removeLast()
                        }) {
                            ZStack {
                                Color.clear
                                    .frame(width: 50, height: 50)
                                Image("btnBack")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                            }
                        }
                        Spacer()
                    }
                }
                .frame(height: 44)
                
                
                // Coordinates
                coordinateView
                
                // Upload Image
                Button {
                    showImagePicker = true
                } label: {
                    ZStack {
                        
                        
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white15, lineWidth: 1)
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
                                .foregroundColor(Color.white.opacity(0.3))
                                .frame(height: 180)
                            VStack(spacing: 5) {
                                Image("ic_add_image")
                                Text("Upload Image")
                                    .foregroundColor(.white)
                                    .font(.appFontMedium(13))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Location name
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location name")
                            .foregroundColor(.white)
                            .font(.appFontMedium(17))
                        TextField("Enter Location name", text: $locationName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(isFocused ? Color(hex: "9C23FF") : Color.white15)
                            )
                            .foregroundColor(.white)
                            .font(.appFontMedium(15))
                            .submitLabel(.next)
                            .focused($isFocused)
                            .onSubmit {
                                focusedField = .address
                            }
                            .overlay(
                                HStack {
                                    Spacer()
                                    if isFocused && !locationName.isEmpty {
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
                    
                    // Address
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Location address")
                            .foregroundColor(.white)
                            .font(.appFontMedium(17))
                        TextEditor(text: $address)
                            .padding(8)
                            .frame(minHeight: 60, maxHeight: 120)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(focusedField == .address ? Color(hex: "9C23FF") : Color.white15)
                                    .background(Color.clear.cornerRadius(10))
                            )
                            .scrollContentBackground(.hidden)
                            .foregroundColor(.white)
                            .font(.appFontMedium(15))
                            .focused($focusedField, equals: .address)
                            .submitLabel(.done)
                            .onSubmit {
                                focusedField = nil
                            }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                
                Spacer()
                
                // Save button
                Button(action: {
                    withAnimation {
                        if locationName.isEmpty || address.isEmpty{
                            showPopup = true
                        }
                        else{
                            saveLocation()
                        }
                    }
                }) {
                    Text("Save Location")
                        .font(.appFontSemibold(16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(colors: [Color(hex: "9C23FF"), Color(hex: "AA55FF")], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white100)
                        .cornerRadius(25)
                        .padding(.horizontal)
                }
                
                .padding(.bottom, 30)
            }
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                if focusedField == .locationName {
                    Button("Next") {
                        focusedField = .address
                    }
                } else if focusedField == .address {
                    Button("Done") {
                        focusedField = nil
                    }
                }
            }
        }
        .backgroundImage("bgAll2")
        .popup(isPresented: $showImagePicker) {
            UploadImagePopup() {
                showImagePicker = false
                pickerSource = .photoLibrary
                showPicker = true
            } onCameraTap: {
                showImagePicker = false
                pickerSource = .camera
                showPicker = true
            } onDissmiss:{
                showImagePicker = false
            }
            
            
        } customize: {
            $0
                .type(.floater())
                .position(.bottom)
                .animation(.spring(duration: 0.3))
                .closeOnTapOutside(true)
                .closeOnTap(false)
                .allowTapThroughBG(false)
                .backgroundView({
                    Rectangle()
                        .fill(.ultraThinMaterial).opacity(0.8)
                           .ignoresSafeArea()
                })
        }
        .popup(isPresented: $showPopup) {
            AlertPopupView(data: popupDataFail) {
                showPopup = false
                
            }
            
        } customize: {
            $0
                .type(.floater())
                .position(.center)
                .animation(.spring(duration: 0.3))
                .closeOnTapOutside(true)
                .closeOnTap(false)
                .allowTapThroughBG(false)
                .backgroundView({
                    Rectangle()
                        .fill(.ultraThinMaterial).opacity(0.8)
                           .ignoresSafeArea()
                })
        }
        .popup(isPresented: $showPopupSuccess) {
            AlertPopupView(data: popupDataSuccess) {
                showPopupSuccess = false
                path.removeLast()
            }
            
        } customize: {
            $0
                .type(.floater())
                .position(.center)
                .animation(.spring(duration: 0.3))
                .closeOnTapOutside(true)
                .closeOnTap(false)
                .allowTapThroughBG(false)
                .backgroundView({
                    Rectangle()
                        .fill(.ultraThinMaterial).opacity(0.8)
                           .ignoresSafeArea()
                })
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(sourceType: pickerSource) { selectedImage in
                self.image = selectedImage
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            withAnimation {
                tabBarManager.isTabBarHidden = true
            }
            self.location = LocationHelperHandler.shared.locationSave
            locationName = location?.name ?? ""
            address = location?.address ?? ""
            focusedField = .locationName
        }
        .onDisappear {
            withAnimation {
                tabBarManager.isTabBarHidden = false
            }
        }
    }
    
    func infoBox(icon: String,  title: String, value: String) -> some View {
        VStack(spacing: 10) {
            Image(icon)
            Text(title)
                .font(.appFontRegular(12))
                .foregroundColor(.white40)
            Text(value)
                .font(.appFontMedium(13))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
    
    private var coordinateView: some View {
        let latitude = location?.latitude ?? 0.0
        let formattedLatitude = String(format: "%.4f", latitude)
        
        let longitude = location?.longitude ?? 0.0
        let formattedLongitude = String(format: "%.4f", longitude)
        
        let height = LocationHelperHandler.shared.heightLocation
        let formattedHeight = String(format: "%.2f", height)
        
        return HStack(spacing: 20) {
            infoBox(icon: "ic_lat2", title: "Latitude", value: formattedLatitude)
            Image("icLine")
            infoBox(icon: "ic_long2", title: "Longitude", value: formattedLongitude)
            Image("icLine")
            infoBox(icon: "ic_height2", title: "Height", value: formattedHeight)
        }
        .padding()
    }
    
    private func saveLocation(){
        guard let location = location else{
            return
        }
        var fileName:String?
        if let image = image{
            fileName =  "\(Int(Date().timeIntervalSince1970)).jpg"
            let _ = SaveLocalPhotoHelper.shared.saveImageToDocuments(image: image, fileName: fileName!)
        }
        let locationObj = LocationModelHelper.shared.createObjectLocation(id: UUID().uuidString, title: locationName.trimmed, address: address.trimmed, image: fileName, lat: location.latitude, long: location.longitude, height: LocationHelperHandler.shared.heightLocation, createdAt: Date().timeIntervalSince1970)
        _ = CoreDataManager.shared.saveLocation(location: locationObj)
       
        showPopupSuccess = true
    }
}
