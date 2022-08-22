//
//  CoreDataHelper.swift
//  GameListApp
//
//  Created by Berkay Sancar on 22.08.2022.
//

import Foundation
import UIKit

class CoreDataFavoriteHelper {
    
    static let shared = CoreDataFavoriteHelper()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchData() -> [Favorite]? {
        
        do {
            return try self.context.fetch(Favorite.fetchRequest())
        } catch {
            print("error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func saveData(name: String, id: Int) {
        
        let favorite = Favorite(context: context)
        favorite.name = name
        favorite.id = Int64(id)
        do {
            try self.context.save()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func deleteData(index: Int) {
        
        if let datas = fetchData() {
            context.delete(datas[index])
            do {
                try self.context.save()
            } catch {
                print("error: \(error.localizedDescription)")
            }
        }
    }
}
