//
//  FavoritesViewModel.swift
//  GameListApp
//
//  Created by Berkay Sancar on 20.08.2022.
//

import Foundation

protocol FavoritesViewModelProtocol {
    
    var delegate: FavoritesViewDelegate? { get set }
    var coreDataHelper: CoreDataFavoriteHelper { get }
    var favGames: [Favorite] { get set }
    
    func fetchFavGames()
    func unFavButtonTapped(index: Int)
    func viewDidLoad()
    func viewWillAppear()
}

final class FavoritesViewModel: FavoritesViewModelProtocol {
    
    weak var delegate: FavoritesViewDelegate?
    
    var favGames: [Favorite] = [Favorite]()
    var coreDataHelper: CoreDataFavoriteHelper
    
 // MARK: - Init
    init(_ helper: CoreDataFavoriteHelper) {
        self.coreDataHelper = helper
    }
// MARK: - Fetch Data
    func fetchFavGames() {
        self.favGames = coreDataHelper.fetchData() ?? []
        self.delegate?.dataRefreshed()
    }
// MARK: - Delete Data
    func unFavButtonTapped(index: Int) {
        coreDataHelper.deleteData(index: index)
        self.delegate?.dataRefreshed()
        fetchFavGames()
    }
// MARK: - ViewDidLoad
    func viewDidLoad() {
        delegate?.viewLoaded()
    }
// MARK: - ViewWillAppear
    func viewWillAppear() {
        delegate?.fetchData()
    }
}
