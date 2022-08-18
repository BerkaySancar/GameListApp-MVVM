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
    
    init(_ service: GameServiceProtocol = GameService()) {
        self.gameService = service
    }
 
    func getGameList() {
        gameService.fetchGames2 { response in
            self.games = response?.results ?? []
            self.dataRefreshed?()
        } failure: { error in
            print("\(error)")
            self.dataNotRefreshed?()
        }
    }
}
