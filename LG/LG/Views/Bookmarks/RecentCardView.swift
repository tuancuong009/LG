import SwiftUI
import MapKit
import PopupView

struct RecentCardView: View {
    var isSelected: Bool
    @Binding var event: LocationObj
    @State private var showPopupEditLocation = false
    @State private var titleLocation: String = ""
    @State private var annotationItems: [Place] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 21.0285, longitude: 105.8542),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var onBookmark: (() -> Void)?
    var onEdit:  (() -> Void)?
    var onDelete:  ((LocationObj) -> Void)?
    var onShowPint: ((LocationObj) -> Void)?

    var body: some View {
        VStack(spacing: 8) {
            mapSection
            infoSection
        }
        .padding(5)
        .background(Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onAppear(perform: setupMap)
        .popup(isPresented: $showPopupEditLocation) {
            EditLocationPopup(
                isPresented: $showPopupEditLocation,
                event: event,
                locationName: $titleLocation
            ) { name in
                event.title = name
                titleLocation = name
                onEdit?()
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

    }

    // MARK: - Map Section
    private var mapSection: some View {
        ZStack(alignment: .topTrailing) {
            Map(coordinateRegion: $region, annotationItems: annotationItems) { place in
                MapAnnotation(coordinate: place.coordinate) {
                    // Image("icMark")
                }
            }
            .cornerRadius(16)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 140)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(AnyShapeStyle(gradientBorder), lineWidth: 1)
                )
            
            menuButton
            
            coordinateOverlay
        }
    }

    // MARK: - Info Section
    private var infoSection: some View {
        HStack(alignment: .center) {
            Image("ic_detailgps")
            
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

            Button {
                event.bookmark.toggle()
                _ = CoreDataManager.shared.updateBookmark(id: event.id, isBookmark: event.bookmark)
                onBookmark?()
            } label: {
                ZStack {
                    Color.clear.frame(width: 50, height: 50)
                    Image(event.bookmark ? "fav2" : "fav")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
            }
        }
    }

    // MARK: - Menu Button
    private var menuButton: some View {
        Menu {
            Button { onShowPint?(event) } label: {
                menuItem(icon: "showpoint", title: "Show Point")
            }
            Button { showPopupEditLocation.toggle() } label: {
                menuItem(icon: "icEdit2", title: "Edit")
            }
            Button(role: .destructive) {
                onDelete?(event)
            } label: {
                menuItem(icon: "icDel", title: "Delete")
            }
        } label: {
            Image("more-circle")
                .frame(width: 40, height: 40)
                .padding(.trailing, 10)
        }
    }

    private func menuItem(icon: String, title: String) -> some View {
        HStack {
            Image(icon)
            Text(title)
                .font(.appFontMedium(15))
                .foregroundColor(.white)
        }
    }

    // MARK: - Coordinate Overlay
    private var coordinateOverlay: some View {
        ZStack(alignment: .bottom){
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    coordinateItem(icon: "ic_lat", value: event.lat)
                    Spacer()
                    coordinateItem(icon: "ic_long", value: event.long)
                }
                .padding([.bottom, .horizontal], 10)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            Image("bottomRecent")
                          .resizable()
                          .scaledToFill()
                          .frame(height: 38).ignoresSafeArea()
            
            
        }
        
    }

    private func coordinateItem(icon: String, value: Double) -> some View {
        HStack(spacing: 10) {
            Image(icon).frame(width: 20, height: 20)
            Text(String(format: "%.4f", value))
                .font(.appFontRegular(12))
                .foregroundColor(.white)
        }
    }

    // MARK: - Setup
    private func setupMap() {
        titleLocation = event.title
        let coordinate = CLLocationCoordinate2D(latitude: event.lat, longitude: event.long)
        annotationItems = [Place(coordinate: coordinate)]
        region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    }

 

    // MARK: - Gradient
    private var gradientBorder: AngularGradient {
        AngularGradient(gradient: Gradient(stops: [
            .init(color: Color(hex: "#60AA61"), location: 0.15),
            .init(color: Color(hex: "#3BC8F3"), location: 0.26),
            .init(color: Color(hex: "#245BFF"), location: 0.38),
            .init(color: Color(hex: "#932BC8"), location: 0.46),
            .init(color: Color(hex: "#FC4CB1"), location: 0.65),
            .init(color: Color(hex: "#F76F89"), location: 0.86),
        ]), center: .center)
    }
}
