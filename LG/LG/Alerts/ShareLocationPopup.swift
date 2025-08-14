//
//  ShareLocationPopup.swift
//  LG
//
//  Created by QTS Coder on 4/8/25.
//


import SwiftUI

struct ShareLocationPopup: View {
    @Binding var isPresented: Bool
    let locationCore: LocationObj?
    var onEmail: (() -> Void)? = nil
    var onMessage: (() -> Void)? = nil
    var onCopy: (() -> Void)? = nil
    var onShareviaWhatapp: (() -> Void)? = nil
    var onShareviaInstagram: (() -> Void)? = nil
    var onShareviaMessager: (() -> Void)? = nil
    var onShareKML: (() -> Void)? = nil
    @State private var location: LocationInfo? = nil
    
    @State private var contentShare = ""
    @State private var hasShowAlert = false
    @State private var image: UIImage?
    
    var body: some View {
            ZStack {
                VStack {
                    Spacer()

                    VStack(spacing: 20) {
                        HStack {
                            Text("Share Location")
                                .font(.appFontSemibold(20))
                                .foregroundColor(.white)
                            Spacer()
                            Button(action: {
                                isPresented = false
                            }) {
                                ZStack {
                                    Color.clear
                                        .frame(width: 50, height: 50) // vùng chạm lớn
                                    Image("btnClose")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24) // icon nhỏ
                                }
                            }
                        }.padding(.bottom, 10)
                        
                        HStack(spacing: 12) {
                            Image("ic_detailgps")
                                .frame(width: 40, height: 40, alignment: .leading)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(location?.name ?? "-")
                                    .font(.appFontSemibold(17))
                                    .foregroundColor(.white)
                                Text(location?.address ?? "-")
                                    .font(.appFontRegular(13))
                                    .foregroundColor(.white50)
                            }.frame(maxWidth: .infinity)
                            Spacer()
                            //Image("icHeart")
                           
                        }

                        HStack(spacing: 50) {
                            Button {
                                if let windowScene = UIApplication.shared
                                    .connectedScenes
                                    .compactMap({ $0 as? UIWindowScene })
                                    .first,
                                   let window = windowScene.windows.first, let vc = window.rootViewController {
                                    ShareManager.shared.shareViaMessage(text: contentShare, image: image, from: vc)
                                }
                                isPresented = false
                                
                            } label: {
                                shareIcon(title: "Message", systemImage: "icMessage")
                            }.frame(maxWidth: .infinity)

                            Button {
                                if let windowScene = UIApplication.shared
                                    .connectedScenes
                                    .compactMap({ $0 as? UIWindowScene })
                                    .first,
                                   let window = windowScene.windows.first, let vc = window.rootViewController {
                                    ShareManager.shared.shareViaEmail(subject: "", body: contentShare, image: image, from: vc)
                                }
                                isPresented = false
                            } label: {
                                shareIcon(title: "E-mail", systemImage: "icEmail")
                            }.frame(maxWidth: .infinity)
                            
                            Button {
                                ShareManager.shared.copyToClipboard(text: contentShare)
                                hasShowAlert.toggle()
                            } label: {
                                shareIcon(title: "Copy", systemImage: "icCopy")
                            }.frame(maxWidth: .infinity)
                            
                        }.padding(.top, 10).padding(.bottom, 10)

                       
                        VStack(spacing: 20) {
                           
                            Button {
                                if let windowScene = UIApplication.shared
                                    .connectedScenes
                                    .compactMap({ $0 as? UIWindowScene })
                                    .first,
                                   let window = windowScene.windows.first, let vc = window.rootViewController {
                                    if let url = ShareManager.shared.createKMLFile(content: contentShare){
                                        if let image = image{
                                            ShareManager.shared.share(.textAndImage(text: contentShare, image: image), from: vc)
                                        }
                                        else{
                                            ShareManager.shared.share(.text(contentShare), from: vc)
                                        }
                                       
                                    }
                                   
                                }
                                isPresented = false
                            } label: {
                                shareRow(title: "Share", icon: "ic_sharesheet")
                            }
                            
                            Button {
                                ShareManager.shared.shareViaWhatsApp(text: contentShare)
                            } label: {
                                shareRow(title: "Share via Whatsapp", icon: "icWhatapp")
                            }
                            
                            Button {
                                if let windowScene = UIApplication.shared
                                    .connectedScenes
                                    .compactMap({ $0 as? UIWindowScene })
                                    .first,
                                   let window = windowScene.windows.first, let vc = window.rootViewController {
                                    if let url = ShareManager.shared.createKMLFile(content: contentShare){
                                        ShareManager.shared.share(.file(url), from: vc)
                                    }
                                   
                                }
                                isPresented = false
                                
                            } label: {
                                shareRow(title: "Share KML", icon: "icMapKml")
                            }
                        }
                        .padding(.leading, 10)
                        .padding(.bottom, 40)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                            .backgroundImage("bgPopUp").cornerRadius(20)
                    )
                    .padding(.bottom, -50)
                }
            }
            .onAppear {
                if let locationCore = locationCore{
                    self.location = LocationInfo(name: locationCore.title, latitude: locationCore.lat, longitude: locationCore.long, address: locationCore.address, city: "")
                    guard let location = location else{
                        return
                    }
                    contentShare = ShareManager.shared.formatLocationInfo(address: location.address, date: Date(), latitude: location.latitude, longitude: location.longitude)
                    if locationCore.image != nil{
                        image = SaveLocalPhotoHelper.shared.loadImageFromDocuments(fileName: locationCore.image!)
                    }
                }
                else{
                    self.location = LocationHelperHandler.shared.locationSave
                    guard let location = location else{
                        return
                    }
                    contentShare = ShareManager.shared.formatLocationInfo(address: location.address, date: Date(), latitude: location.latitude, longitude: location.longitude)
                }
            }
            
            .alertPurchasePopup(isPresented: $hasShowAlert, type: .success, message: "Copied!")
        }

    func shareIcon(title: String, systemImage: String) -> some View {
        VStack(spacing: 8) {
            Image(systemImage)
            Text(title)
                .font(.appFontMedium(13))
                .foregroundColor(.white60)
        }
    }

    func shareRow(title: String, icon: String) -> some View {
        HStack {
            Image(icon)
            Text(title)
                .font(.appFontMedium(15))
                .foregroundColor(.white)
            Spacer()
            Image("icDetail")
        }
    }
}
