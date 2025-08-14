//
//  DetailLocationView.swift
//  LG
//
//  Created by QTS Coder on 4/8/25.
//

import SwiftUI
import MapKit
import PopupView
struct DetailLocationView: View {
    @Binding var path: [AppRoute]
    let event: LocationObj
    @EnvironmentObject var tabBarManager: TabBarManager
    @State private var showPopupEditLocation = false
    @State private var isBookmark = false
    @State private var titleLocation: String = ""
    @State private var showRemoveLocation = false
    @State private var contentShare = ""
    @State private var hasShowAlert = false
    @State private var showPopupRouteLocation = false
    @State private var showPopupShare = false
    
    @State private var annotationItems: [Place] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 21.0285, longitude: 105.8542),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    var body: some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .top){
               
                VStack(spacing: 0) {
                    Map(coordinateRegion: $region, annotationItems: annotationItems) { place in
                        MapAnnotation(coordinate: place.coordinate) {
                            Image("icMark")
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.6) .ignoresSafeArea()
                    Spacer()
                }
                Image("bgTop")
                              .resizable()
                              .scaledToFill()
                              .frame(height: 132) // Chiều cao phần overlay
                              .zIndex(1).ignoresSafeArea()
            }
         
            VStack {
                ZStack {
                    Text(self.formatDate(from: event.createdAt, format: "MMM dd, yyyy"))
                        .font(.appFontSemibold(20))
                        .foregroundColor(.white)
                    
                    HStack {
                        Button(action: {
                            path.removeLast()
                        }) {
                            ZStack {
                                Color.clear
                                    .frame(width: 50, height: 50) // vùng chạm lớn
                                Image("btnBack")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24) // icon nhỏ
                            }
                        }
                        Spacer()
                        Menu {
                            Button {
                                // Action
                                showPopupEditLocation = true
                            } label: {
                                HStack{
                                    Image("icEdit2")
                                    Text("Edit").font(.appFontMedium(15)).foregroundColor(.white)
                                }
                            }
                            
                            Button(role: .destructive) {
                                // Delete action
                                showRemoveLocation = true
                            } label: {
                                HStack{
                                    Image("icDel")
                                    Text("Delete").font(.appFontMedium(15)).foregroundColor(.white)
                                }
                            }
                        } label: {
                            ZStack {
                                Color.clear
                                    .frame(width: 50, height: 50) // vùng chạm lớn
                                Image("more-circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24) // icon nhỏ
                            }
                            
                        }
                    }
                }
                .frame(height: 44)
                
                Spacer()
                
                VStack(spacing: 20) {
                    HStack{
                        Text("Location Details")
                            .font(.appFontSemibold(20))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    
                    HStack(alignment: .center, spacing: 12) {
                        Image("ic_detailgps")
                            .frame(width: 40, height: 40, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(titleLocation)
                                .font(.appFontSemibold(17))
                                .foregroundColor(.white)
                            Text(event.address)
                                .font(.appFontRegular(13))
                                .foregroundColor(.white50)
                        }
                        Spacer()
                        Button(action: {
                            isBookmark = !isBookmark
                            _ = CoreDataManager.shared.updateBookmark(id: event.id, isBookmark: isBookmark)
                        }) {
                            ZStack {
                                Color.clear
                                    .frame(width: 50, height: 50)
                                Image(isBookmark ? "fav2" : "fav")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24) // icon nhỏ
                            }
                        }
                        
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Image("calendar_icon")
                                Text(self.formatDate(from: event.createdAt, format: "EEEE, MMM dd, yyyy"))
                                    .font(.appFontRegular(13))
                                    .foregroundColor(.white50)
                            }
                            HStack {
                                Text(self.formatDate(from: event.createdAt, format: "HH:mm:ss"))
                                    .font(.appFontMedium(15))
                                    .foregroundColor(.white)
                                Text(self.formatDate(from: event.createdAt, format: "(zzz)"))
                                    .font(.appFontRegular(13))
                                    .foregroundColor(.white50)
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.clear, lineWidth: 1)
                            .background(Color.white5).cornerRadius(12))
                    
                    HStack(spacing: 50) {
                        Button {
                            showPopupShare.toggle()
                        } label: {
                            shareIcon(title: "Share", systemImage: "share_cal")
                        }.frame(maxWidth: .infinity)
                        
                        Button {
                            ShareManager.shared.copyToClipboard(text: contentShare)
                            hasShowAlert.toggle()
                        } label: {
                            shareIcon(title: "Copy", systemImage: "copy_cal")
                        }.frame(maxWidth: .infinity)
                        
                        Button {
                            showPopupRouteLocation.toggle()
                        } label: {
                            shareIcon(title: "Navigate", systemImage: "naviga_cal")
                        }.frame(maxWidth: .infinity)
                        
                    }.padding(.top, 10).padding(.bottom, 40)
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
        
        .ignoresSafeArea(.keyboard)
        .popup(isPresented: $showPopupEditLocation) {
            EditLocationPopup(isPresented: $showPopupEditLocation, event: event, locationName: $titleLocation) { name in
                titleLocation = name
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
                        .fill(.ultraThinMaterial).opacity(0.8)
                           .ignoresSafeArea()
                })
        }
        .popup(isPresented: $showRemoveLocation) {
            AlertDeleteLocationView(isPresented: $showRemoveLocation) {
                _ = CoreDataManager.shared.deleteLocation(withID: event.id)
                path.removeLast()
            }
        }  customize: {
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
        .alertPurchasePopup(isPresented: $hasShowAlert, type: .success, message: "Copied!")
        .popup(isPresented: $showPopupShare) {
            ShareLocationPopup (isPresented:$showPopupShare, locationCore: event , onEmail: {
                
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
            
                .backgroundColor(.black.opacity(0.6))
        }
        
        .popup(isPresented: $showPopupRouteLocation) {
            RedirectLocationPopup(isPresented: $showPopupRouteLocation, locationCore: event) {
                
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
                        .fill(.ultraThinMaterial).opacity(0.8)
                           .ignoresSafeArea()
                })
        }
        .onAppear {
            _ = CoreDataManager.shared.updateLocationRecent(id: event.id)
            contentShare = ShareManager.shared.formatLocationInfo(address: event.address, date: Date(), latitude: event.lat, longitude: event.long)
            isBookmark = event.bookmark
            titleLocation = event.title
            let coordinate = CLLocationCoordinate2D(latitude: event.lat, longitude: event.long)
            annotationItems = [Place(coordinate: coordinate)]
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            withAnimation {
                tabBarManager.isTabBarHidden = true
            }
        }
        .onDisappear {
            withAnimation {
                tabBarManager.isTabBarHidden = false
            }
        }
        
        .navigationBarHidden(true)
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
        .padding(.horizontal)
    }
    //"EEEE, MMM dd, yyyy  HH:mm:ss (zzz)"
    func formatDate(from timestamp: Double, format: String) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current // hoặc set cụ thể nếu cần
        return formatter.string(from: date)
    }
}
