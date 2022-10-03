//
//  HomeViewModel.swift
//  GameListApp
//
//  Created by Berkay Sancar on 17.08.2022.
//

import Foundation

final class HomeViewModel {
  
    var games: [Game] = [Game]()
    var gameService: GameServiceProtocol
    
    var dataRefreshed: (() -> Void)?
    var dataNotRefreshed: (() -> Void)?
    
// MARK: - Init
    init(_ service: GameServiceProtocol = GameService()) {
        self.gameService = service
    }
// MARK: - Get Data
    func getGameList() {
        
        gameService.fetchGames { [weak self] results in
            guard let self = self else { return }
            
            switch results {
            case .success(let games):
                DispatchQueue.main.async {
                    self.games = games ?? []
                    self.dataRefreshed?()
                }
           
            case .failure(let error):
                print(error)
                self.dataNotRefreshed?()
            }
        }
    }
// MARK: - Search Operation
    func search(_ text: String?) {
        if let text = text, !text.isEmpty {
            let searchData = self.games.filter { $0.name!.lowercased().contains(text.lowercased()) }
            self.games = searchData
            dataRefreshed?()
        } else {
            getGameList()
        }
    }
    
    func favoriteButtonTapped(senderTag: Int) {
        
        if let data = CoreDataFavoriteHelper.shared
            .fetchData()?
            .filter({ $0.name == games[senderTag].name }) {
            
            if data.isEmpty {
                CoreDataFavoriteHelper.shared.saveData(name: games[senderTag].name ?? "",
                                                       id: games[senderTag].id ?? 0)
            } else {
                if let index = CoreDataFavoriteHelper.shared
                    .fetchData()?
                    .firstIndex(where: { $0.name == games[senderTag].name }) {
                    CoreDataFavoriteHelper.shared.deleteData(index: index)
                }
            }
        }
    }
}
