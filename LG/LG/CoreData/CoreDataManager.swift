//
//  CoreDataManager.swift


import UIKit
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private var managedContext: NSManagedObjectContext?
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LG")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private init() {
        self.managedContext = self.persistentContainer.viewContext
    }
    
    //MARK: - Category
    
    @discardableResult
    func saveLocation(location: LocationObj) -> Bool {
        guard let managedContext = self.managedContext else {
            return false
        }
        
        
        let entity = NSEntityDescription.entity(forEntityName: "Location", in: managedContext)!
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        location.saveToLibraryCoreData(object: object)
        
        do {
            try managedContext.save()
            print("Save location success")
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func fetchAllLocations() -> [LocationObj] {
        var data: [LocationObj] = []
        
        guard let managedContext = self.managedContext else {
            return data
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        let sectionSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        //fetchRequest.predicate = NSPredicate(format: "categoryId == %d AND groupId == %@",categoryId, groupId)
        do {
            let results = try managedContext.fetch(fetchRequest)
            data = results.compactMap({ LocationObj.init(object: $0) })
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return data
    }
    
    func fetchAllLocations(forDateString dateString: String) -> [LocationObj] {
        var data: [LocationObj] = []

        guard let managedContext = self.managedContext else {
            return data
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        // Lọc theo chuỗi ngày định dạng "dd-MM-yyyy"
        fetchRequest.predicate = NSPredicate(format: "date_calendar == %@", dateString)
        
        // Sắp xếp nếu cần
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let results = try managedContext.fetch(fetchRequest)
            data = results.compactMap { LocationObj(object: $0) }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        return data
    }

    func fetchAllLocations(bookmarkedOnly: Bool = false) -> [LocationObj] {
        var data: [LocationObj] = []
        
        guard let managedContext = self.managedContext else {
            return data
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")
        
        // Sắp xếp theo thời gian
        let sectionSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sectionSortDescriptor]
        
        // Thêm điều kiện bookmark = true nếu cần
        if bookmarkedOnly {
            fetchRequest.predicate = NSPredicate(format: "bookmark == %@", NSNumber(value: true))
        }
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            data = results.compactMap { LocationObj(object: $0) }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return data
    }

    func fetchAllLocationRecents() -> [LocationObj] {
        var data: [LocationObj] = []

        guard let managedContext = self.managedContext else {
            return data
        }

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Location")

        let sectionSortDescriptor = NSSortDescriptor(key: "updateAt", ascending: false)
        fetchRequest.sortDescriptors = [sectionSortDescriptor]

        fetchRequest.fetchLimit = 3

        do {
            let results = try managedContext.fetch(fetchRequest)
            data = results.compactMap({ LocationObj(object: $0) })
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        return data
    }

    func deleteLocation(withID id: String) -> Bool {
        guard let managedContext = self.managedContext else {
            return false
        }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Location")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            if let objects = try managedContext.fetch(fetchRequest) as? [NSManagedObject], let objectToDelete = objects.first {
                managedContext.delete(objectToDelete)
                try managedContext.save()
                print("Deleted location with ID: \(id)")
                return true
            }
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
        return false
    }
    
    func updateLocationTitle(id: String, title: String ) -> Bool {
        guard let managedContext = self.managedContext else {
            return false
        }
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Location")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            if let objectToUpdate = objects.first {
                objectToUpdate.setValue(title, forKey: "title")
                try managedContext.save()
                return true
            }
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
        return false
    }
    func updateLocationRecent(id: String ) -> Bool {
        guard let managedContext = self.managedContext else {
            return false
        }
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Location")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            if let objectToUpdate = objects.first {
                objectToUpdate.setValue(Date().timeIntervalSince1970, forKey: "updateAt")
                try managedContext.save()
                return true
            }
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
        return false
    }
    func updateBookmark(id: String, isBookmark: Bool ) -> Bool {
        guard let managedContext = self.managedContext else {
            return false
        }
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Location")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            if let objectToUpdate = objects.first {
                objectToUpdate.setValue(isBookmark, forKey: "bookmark")
                try managedContext.save()
                return true
            }
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
        return false
    }
    
    func updateLocation(location: LocationObj ) -> Bool {
        print("ID--->",location.id, location.title)
        guard let managedContext = self.managedContext else {
            return false
        }
        
        let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "Location")
        fetchRequest.predicate = NSPredicate(format: "id == %@", location.id)
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            if let objectToUpdate = objects.first {
                objectToUpdate.setValue(location.title, forKey: "title")
                objectToUpdate.setValue(location.address, forKey: "address")
                objectToUpdate.setValue(location.image, forKey: "image")
                try managedContext.save()
                return true
            }
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
        }
        return false
    }
}
