//
//  GameService.swift
//  GameListApp
//
//  Created by Berkay Sancar on 17.08.2022.
//

import Alamofire

protocol GameServiceProtocol {
    func fetchGames(completion: @escaping (Result<[Game]?, AFError>) -> Void)
    func fetchDetail(id: Int, completion: @escaping (Result<Detail?, AFError>) -> Void)
}

final class GameService: GameServiceProtocol {
  
    func fetchGames(completion: @escaping (Result<[Game]?, AFError>) -> Void) {
        
        let url = "\(GameListEndpoints.getList.url)\(GameListEndpoints.getList.apiKey)"
        
        NetworkManager.shared.sendRequest(type: BaseResponse.self,
                                          url: url,
                                          method: .get) { response in
            
            switch response {
            case .success(let games):
                completion(.success(games.results))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchDetail(id: Int, completion: @escaping (Result<Detail?, AFError>) -> Void) {
        
        let url = "\(GameListEndpoints.getDetail.url)\(id)?\(GameListEndpoints.getDetail.apiKey)"
        
        NetworkManager.shared.sendRequest(type: Detail.self,
                                          url: url,
                                          method: .get) { response in
            
            switch response {
            case .success(let detail):
                completion(.success(detail))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
