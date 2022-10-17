//
//  HomeViewModel.swift
//  GameListApp
//
//  Created by Berkay Sancar on 17.08.2022.
//

import Foundation

protocol HomeViewModelProtocol {
    
    var delegate: HomeViewDelegate? { get set }
    var gameService: GameServiceProtocol { get }
    
    var games: [Game] { get set }
    
    func getGameList()
    func search(_ text: String?)
    func favoriteButtonTapped(senderTag: Int)
    func viewDidLoad()
}

final class HomeViewModel: HomeViewModelProtocol {
    
    weak var delegate: HomeViewDelegate?
    var gameService: GameServiceProtocol
  
    var games: [Game] = [Game]()
    
// MARK: - Init
    init(_ service: GameServiceProtocol) {
        self.gameService = service
    }
// MARK: ViewDidLoad
    func viewDidLoad() {
        self.delegate?.viewLoaded()
    }
// MARK: - Get Data
    func getGameList() {
        self.delegate?.setLoading(isLoading: true)
        gameService.fetchGames { [weak self] results in
            guard let self else { return }
            self.delegate?.setLoading(isLoading: false)
            switch results {
            case .success(let games):
                DispatchQueue.main.async {
                    self.games = games ?? []
                    self.delegate?.dataRefreshed()
                }
           
            case .failure(let error):
                print(error)
                self.delegate?.dataError()
            }
        }
    }
// MARK: - Search Operation
    func search(_ text: String?) {
        if let text = text, !text.isEmpty {
            let searchData = self.games.filter { $0.name!.lowercased().contains(text.lowercased()) }
            self.games = searchData
            self.delegate?.dataRefreshed()
        } else {
            getGameList()
        }
    }
// MARK: - FavButtonTapped
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
