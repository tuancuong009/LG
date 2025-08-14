//
//  BookmarksView.swift
//  LG
//
//  Created by QTS Coder on 1/8/25.
//

import SwiftUI
import PopupView
struct BookmarksView: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @StateObject var vm = LocationViewModel()
    @State private var path: [AppRoute] = []
    @State private var selectedIndex: Int = 0
    @State private var selectedRemoveLocation: LocationObj?
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    Text("Bookmarks")
                        .font(.appFontSemibold(32))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    // Recents
                    if vm.bookmars.isEmpty && vm.recents.isEmpty{
                        if vm.bookmars.isEmpty {
                            VStack(spacing: 10) {
                                Image("no_bookmark")
                                Text("No Bookmarks")
                                    .font(.appFontSemibold(20))
                                    .foregroundColor(.white)
                                Text("No saved locations yet.")
                                    .font(.appFontRegular(15))
                                    .foregroundColor(.white50)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .frame(minHeight: UIScreen.main.bounds.height * 0.6) // hoặc cao hơn nếu cần
                        }
                        
                    }
                    else{
                        VStack(alignment: .leading, spacing: 10) {
                            HStack{
                                Text("Recents")
                                    .font(.appFontSemibold(20))
                                    .foregroundColor(.white)
                                Spacer()
                                HStack(spacing: 6) {
                                    ForEach(0..<vm.recents.count, id: \.self) { index in
                                        Circle()
                                            .fill(index == selectedIndex ? Color.white : Color.white.opacity(0.1))
                                            .frame(width: 8, height: 8)
                                    }
                                }
                                .padding(.horizontal, 10).padding(.vertical, 5)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.clear, lineWidth: 1)
                                        .background(Color.white15).cornerRadius(10))
                                
                            }.padding(.horizontal)
                            
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 0) {
                                    ForEach(0..<vm.recents.count, id: \.self) { i in
                                        
                                        RecentCardView(isSelected: i == 0, event: $vm.recents[i], onBookmark: {
                                            vm.loadBookMarks()
                                        }, onEdit: {
                                            vm.loadBookMarks()
                                        }, onDelete: {  event in
                                            selectedRemoveLocation = event
                                        }, onShowPint: {  event in
                                            path.append(.detailLocation(event))
                                        }).frame(width: UIScreen.main.bounds.width * 0.8)
                                        ItemPositionView(index: i)
                                    }
                                    Spacer(minLength: 30)
                                }
                                .padding(.horizontal)
                            }
                            .onPreferenceChange(ItemFramePreferenceKey.self) { values in
                                let centerX = UIScreen.main.bounds.midX
                                let closest = values.min(by: { abs($0.value - centerX) < abs($1.value - centerX) })
                                
                                if let index = closest?.key {
                                    selectedIndex = index
                                }
                            }
                        }
                        
                        // Saved Locations
                        if vm.bookmars.isEmpty{
                            Text("All Saved Locations")
                                .font(.appFontSemibold(20))
                                .foregroundColor(.white)
                                .padding(.horizontal).padding(.top, 20)
                            HStack{
                                Spacer()
                                VStack(alignment: .center, spacing: 10) {
                                    Image("no_bookmark")
                                    Text("No Bookmarks")
                                        .font(.appFontSemibold(20))
                                        .foregroundColor(.white)
                                    Text("No saved locations yet.")
                                        .font(.appFontRegular(15))
                                        .foregroundColor(.white50)
                                }
                                Spacer()
                            }
                            
                            
                        }
                        else{
                            Text("All Saved Locations")
                                .font(.appFontSemibold(20))
                                .foregroundColor(.white)
                                .padding(.horizontal).padding(.top, 20)
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(0..<vm.bookmars.count, id: \.self) { i in
                                    SavedLocationCardView(event: $vm.bookmars[i], onBookmark: {
                                        vm.loadRecents()
                                        vm.loadBookMarks()
                                    }, onEdit: {
                                        vm.loadRecents()
                                    }, onDelete: {  event in
                                        selectedRemoveLocation = event
                                    }, onShowPint: { event in
                                        path.append(.detailLocation(event))
                                    })
                                }
                            }.padding(.horizontal)
                        }
                        
                    }
                    
                }
                
            }
            .popup(item: $selectedRemoveLocation) { location in
                AlertDeleteLocationView(isPresented: Binding(get: { self.selectedRemoveLocation != nil }, set: { if !$0 { self.selectedRemoveLocation = nil } })) {
                    _ = CoreDataManager.shared.deleteLocation(withID: location.id)
                    vm.loadRecents()
                    vm.loadBookMarks()
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
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .detailLocation(let event):
                    DetailLocationView(path: $path, event: event)
                    
                case .otherPage:
                    EmptyView()
                }
            }
            .onAppear(perform: {
                vm.loadBookMarks()
                vm.loadRecents()
            })
            .ignoresSafeArea(.keyboard)
            .padding(.bottom, safeAreaInsets.bottom + 20)
            .backgroundImage("bgAll2")
            .navigationBarHidden(true)
        }
    }
}
