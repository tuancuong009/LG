//
//  Location.swift


import Foundation
import UIKit
import CoreData
struct LocationObj: Identifiable, Codable, Hashable{
    var address: String
    var title: String
    var createdAt: Double
    var image: String?
    var id: String
    var long: Double
    var lat: Double
    var height: Double
    var bookmark: Bool
    var date_calendar: String
    var updateAt: Double
    enum CodingKeys: String, CodingKey {
        case address
        case title
        case createdAt
        case image
        case id
        case long
        case lat
        case height
        case bookmark
        case date_calendar
        case updateAt
    }
}
extension LocationObj {
    
    init(object: NSManagedObject) {
        self.id = object.string(forKey: "id") ?? ""
        self.address = object.string(forKey: "address") ?? ""
        self.createdAt = object.double(forKey: "createdAt") ?? 0.0
        self.image = object.string(forKey: "image")
        self.title = object.string(forKey: "title") ?? ""
        self.long = object.double(forKey: "long") ?? 0.0
        self.lat = object.double(forKey: "lat") ?? 0.0
        self.height = object.double(forKey: "height") ?? 0.0
        self.bookmark = object.bool(forKey: "bookmark") ?? false
        self.date_calendar = object.string(forKey: "date_calendar") ?? ""
        self.updateAt = object.double(forKey: "updateAt") ?? 0.0
    }
    
    
    
    func saveToLibraryCoreData(object: NSManagedObject) {
        object.setValue(address, forKey: "address")
        object.setValue(title, forKey: "title")
        object.setValue(createdAt, forKey: "createdAt")
        object.setValue(image, forKey: "image")
        object.setValue(long, forKey: "long")
        object.setValue(id, forKey: "id")
        object.setValue(lat, forKey: "lat")
        object.setValue(height, forKey: "height")
        object.setValue(bookmark, forKey: "bookmark")
        object.setValue(date_calendar, forKey: "date_calendar")
        object.setValue(updateAt, forKey: "updateAt")
    }
}

class LocationModelHelper{
    static let shared = LocationModelHelper()
    func createObjectLocation(id: String, title: String, address: String, image: String?, lat: Double, long: Double, height: Double, createdAt: Double)-> LocationObj{
        let location = LocationObj(address: address, title: title, createdAt: createdAt, image: image, id: id, long: long, lat: lat, height: height, bookmark: false, date_calendar: self.formatDate(from: createdAt), updateAt: createdAt)
        return location
    }
    func formatDate(from timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter.string(from: date)
    }
}
