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
        detailService.fetchDetail(id: id) { [weak self] results in
            guard let self = self else { return }
            
            switch results {
            case .success(let detail):
                self.detailName = detail?.name ?? ""
                self.detailDescription = detail?.description ?? ""
                self.detailBackgroundImage = detail?.background_image ?? ""
                self.detailWebsite = detail?.website ?? ""
                self.dataRefreshed?()
                
            case .failure(let error):
                print(error)
                self.dataNotRefreshed?()
            }
        }
    }
}
