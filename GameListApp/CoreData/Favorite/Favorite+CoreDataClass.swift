//
//  Favorite+CoreDataProperties.swift
//  GameListApp
//
//  Created by Berkay Sancar on 22.08.2022.
//
//

import CoreData
import Foundation

@objc(Favorite)
public class Favorite: NSManagedObject, Identifiable, Any {
    
    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }
}
