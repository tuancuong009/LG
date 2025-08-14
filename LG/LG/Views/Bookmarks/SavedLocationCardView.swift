//
//  SavedLocationCardView.swift
//  LG
//
//  Created by QTS Coder on 5/8/25.
//
import SwiftUI
import MapKit
import PopupView
struct SavedLocationCardView: View {
    @Binding var event: LocationObj
    @State private var annotationItems: [Place] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 21.0285, longitude: 105.8542),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var showPopupEditLocation = false
    @State private var titleLocation: String = ""
    var onBookmark: (() -> Void)? = nil
    var onEdit: (() -> Void)? = nil
    var onDelete:  ((LocationObj) -> Void)?
    var onShowPint: ((LocationObj) -> Void)? = nil
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Map(coordinateRegion: $region, annotationItems: annotationItems) { place in
                    MapAnnotation(coordinate: place.coordinate) {
                        //Image("icMark")
                    }
                }.cornerRadius(16)
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 120)
                    .overlay(
                        // Gradient Border nếu selected
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white10, lineWidth: 1)
                    )
                
                Menu {
                    Button {
                        onShowPint?(event)
                    } label: {
                        HStack{
                            Image("showpoint")
                            Text("Show Point").font(.appFontMedium(15)).foregroundColor(.white)
                        }
                    }
                    Button {
                        showPopupEditLocation.toggle()
                    } label: {
                        HStack{
                            Image("icEdit2")
                            Text("Edit").font(.appFontMedium(15)).foregroundColor(.white)
                        }
                    }
                    
                    Button(role: .destructive) {
                        onDelete?(event)
                    } label: {
                        HStack{
                            Image("icDel")
                            Text("Delete").font(.appFontMedium(15)).foregroundColor(.white)
                        }
                    }
                } label: {
                    Image("more-circle").frame(width: 40, height: 40, alignment: .trailing).padding(.trailing, 10)
                }
                
            }
            
            HStack(alignment: .center) {
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(event.title)
                        .font(.appFontSemibold(17))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(event.address)
                        .font(.appFontRegular(13))
                        .foregroundColor(.white50)
                        .lineLimit(1)
                }
                Spacer()
                
                Button(action: {
                    event.bookmark.toggle()
                    _ = CoreDataManager.shared.updateBookmark(id: event.id, isBookmark: event.bookmark)
                    onBookmark?()
                }) {
                    ZStack {
                        Color.clear
                            .frame(width: 50, height: 50)
                        Image(event.bookmark ? "fav2" : "fav")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24) // icon nhỏ
                    }
                }
            }
        }
        .onAppear {
            titleLocation = event.title
            let coordinate = CLLocationCoordinate2D(latitude: event.lat, longitude: event.long)
            annotationItems = [Place(coordinate: coordinate)]
            region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
        .padding(.vertical, 5)
        .background(Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .popup(isPresented: $showPopupEditLocation) {
            EditLocationPopup(isPresented: $showPopupEditLocation, event: event, locationName: $titleLocation) { name in
                event.title = name
                titleLocation = name
                onEdit?()
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
    }
}
