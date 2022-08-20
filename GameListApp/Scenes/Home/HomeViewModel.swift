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
    var isLoading = false
    
    init(_ service: GameServiceProtocol = GameService()) {
        self.gameService = service
    }
 // MARK: - Get Data
    func getGameList() {
        gameService.fetchGames2 { response in
            self.games = response?.results ?? []
            self.dataRefreshed?()
        } failure: { error in
            print(error)
            self.dataNotRefreshed?()
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
}
