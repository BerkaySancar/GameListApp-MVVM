//
//  FavoritesViewModel.swift
//  GameListApp
//
//  Created by Berkay Sancar on 20.08.2022.
//

import Foundation

final class FavoritesViewModel {
    
    var favGames: [Favorite] = [Favorite]()
    var coreDataHelper: CoreDataFavoriteHelper
    
    var dataRefreshed: (() -> Void)?
    
 // MARK: - Init
    init(_ helper: CoreDataFavoriteHelper = CoreDataFavoriteHelper()) {
        self.coreDataHelper = helper
    }
// MARK: - Fetch Data
    func fetchFavGames() {
        favGames = coreDataHelper.fetchData() ?? []
        self.dataRefreshed?()
    }
// MARK: - Delete Data
    func deleteFavGames(index: Int) {
        coreDataHelper.deleteData(index: index)
        self.dataRefreshed?()
    }
}
