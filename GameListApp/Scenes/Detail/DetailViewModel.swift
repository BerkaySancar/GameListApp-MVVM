//
//  DetailViewModel.swift
//  GameListApp
//
//  Created by Berkay Sancar on 24.08.2022.
//

import Foundation

final class DetailViewModel {
   
    var detailName: String?
    var detailDescription: String?
    var detailBackgroundImage: String?
    var detailWebsite: String?
    var detailService: GameServiceProtocol
    
    var dataRefreshed: (() -> Void)?
    var dataNotRefreshed: (() -> Void)?
    
// MARK: - Init
    init(_ service: GameServiceProtocol = GameService()) {
        self.detailService = service
    }
    
// MARK: - Get Data
    func getDetail(with id: Int) {
        detailService.fetchDetail(id: id) { response in
            self.detailName = response?.name ?? ""
            self.detailDescription = response?.description ?? ""
            self.detailBackgroundImage = response?.background_image ?? ""
            self.detailWebsite = response?.website ?? ""
            self.dataRefreshed?()
        } failure: { error in
            print(error)
            self.dataNotRefreshed?()
        }
    }
}
