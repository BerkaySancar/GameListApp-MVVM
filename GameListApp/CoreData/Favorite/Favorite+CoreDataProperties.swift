//
//  Favorite+CoreDataProperties.swift
//  GameListApp
//
//  Created by Berkay Sancar on 22.08.2022.
//
//

import CoreData
import Foundation

extension Favorite: Any {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var id: Int64
}

extension Favorite: Identifiable {
}
