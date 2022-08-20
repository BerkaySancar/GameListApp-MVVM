//
//  GameService.swift
//  GameListApp
//
//  Created by Berkay Sancar on 17.08.2022.
//

import Alamofire

protocol GameServiceProtocol {
    func fetchGames2(success: @escaping (BaseResponse?) -> Void, failure: @escaping ((AFError) -> Void))
}

final class GameService: GameServiceProtocol {
    
    func fetchGames2(success: @escaping (BaseResponse?) -> Void, failure: @escaping ((AFError) -> Void)) {
        
        let url = "\(Constants.BASE_URL)?key=\(Constants.API_KEY)"
        
        NetworkManager.shared.sendRequest(type: BaseResponse.self,
                                          url: url,
                                          method: .get) { response in
            
            switch response {
            case .success(let games):
                success(games)

            case .failure(let error):
                failure(error)
            }
        }
    }
}
