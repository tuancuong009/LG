//
//  LocationViewModel.swift
//  LG
//
//  Created by QTS Coder on 7/8/25.
//


import Foundation
import CoreData

class LocationViewModel: ObservableObject {
    @Published var items: [LocationObj] = []
    @Published var itemAlls: [LocationObj] = []
    @Published var bookmars: [LocationObj] = []
    @Published var recents: [LocationObj] = []
    func load(for dateString: String) {
        self.items = CoreDataManager.shared.fetchAllLocations(forDateString: dateString)
    }
    
    func loadAll() {
        self.itemAlls = CoreDataManager.shared.fetchAllLocations()
    }
    
    func loadBookMarks() {
        self.bookmars = CoreDataManager.shared.fetchAllLocations(bookmarkedOnly: true)
    }
    
    func loadRecents() {
        self.recents = CoreDataManager.shared.fetchAllLocationRecents()
    }
}
