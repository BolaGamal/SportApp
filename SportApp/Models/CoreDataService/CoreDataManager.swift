//
//  CoreDataManager.swift
//  SportApp
//
//  Created by Pola on 2/28/22.
//  Copyright © 2022 Pola. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager{
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SportApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
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
    
    
    func fetchData()->[NSManagedObject]{
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest         = NSFetchRequest<NSManagedObject>(entityName: "TheLeague")
        let arr = try! managedObjectContext.fetch(fetchRequest)
        print(arr.count)
        return arr
    }
    
    
    func saveData(leauges: Countrys){
        let managedObjectContext = persistentContainer.viewContext
        let entity       = NSEntityDescription.entity(forEntityName: "TheLeague", in: managedObjectContext)!
        let league       = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        
        league.setValue(leauges.strLeague, forKey: "leagueName")
        league.setValue(leauges.idLeague, forKey: "leagueId")
        league.setValue(leauges.strCountry, forKey: "strCountry")
        league.setValue(leauges.strSport, forKey: "strSport")
        league.setValue(leauges.strBadge, forKey: "strBadge")
        
        print("new LeaugesEntity saved")
        do{
            try managedObjectContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteData(_ strLeagueId : String) {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TheLeague")
        fetchRequest.includesPropertyValues = false
        do {
            let items = try managedObjectContext.fetch(fetchRequest)
            for item in items{
                managedObjectContext.delete(item)
            }
            print("LeaugesEntity deleted")
            // Save Changes
            try managedObjectContext.save()
            
        } catch let error as NSError {
            print("Could not delete. \(error), \(error.userInfo)")
        }
    }
    
//    func clearAllData() {
//        let managedObjectContext = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TheLeague")
//        fetchRequest.includesPropertyValues = false
//        do {
//            let items = try managedObjectContext.fetch(fetchRequest)
//
//            for item in items{
//                managedObjectContext.delete(item)
//            }
//
//            print("Clear All Data")
//            // Save Changes
//            try managedObjectContext.save()
//
//        } catch let error as NSError {
//            print("Could Clear All Data. \(error), \(error.userInfo)")
//        }
//    }
}
