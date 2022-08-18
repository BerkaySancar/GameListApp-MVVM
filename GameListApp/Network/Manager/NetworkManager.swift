//
//  NetworkManager.swift
//  GameListApp
//
//  Created by Berkay Sancar on 17.08.2022.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
}

extension NetworkManager {
    
    func sendRequest<T: Codable>(type: T.Type,
                                 url: String,
                                 method: HTTPMethod,
                                 completion: @escaping ((Result<T, AFError>) -> Void)) {
        
        AF.request(url,
                   method: method,
                   encoding: JSONEncoding.default)
        .validate()
        .responseDecodable(of: T.self) { response in
            
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
