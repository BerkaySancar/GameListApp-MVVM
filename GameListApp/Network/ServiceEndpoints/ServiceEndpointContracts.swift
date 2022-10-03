//
//  ServiceEndpointContracts.swift
//  GameListApp
//
//  Created by Berkay Sancar on 3.10.2022.
//

protocol ServiceEndpointProtocols {
    
    var baseURLString: String { get }
    var path: String { get }
    var apiKey: String { get }
}

extension ServiceEndpointProtocols {
    var url: String {
        return baseURLString + path
    }
}
