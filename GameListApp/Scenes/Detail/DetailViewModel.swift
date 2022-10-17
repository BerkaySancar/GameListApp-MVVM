//
//  DetailViewModel.swift
//  GameListApp
//
//  Created by Berkay Sancar on 24.08.2022.
//

import Foundation

protocol DetailViewModelProtocol {
    
    var delegate: DetailViewDelegate? { get set }
    
    var detailName: String? { get set }
    var detailDescription: String? { get set }
    var detailBackgroundImage: String? { get set }
    var detailWebsite: String? { get set }
    
    var detailService: GameServiceProtocol { get }
    
    func viewDidLoad()
    func getDetail()
}

final class DetailViewModel: DetailViewModelProtocol {
    
    weak var delegate: DetailViewDelegate?
   
    var detailName: String?
    var detailDescription: String?
    var detailBackgroundImage: String?
    var detailWebsite: String?
    private var gameID: Int
    
    let detailService: GameServiceProtocol

// MARK: - Init
    init(_ service: GameServiceProtocol = GameService(),
         gameID: Int) {
        self.detailService = service
        self.gameID = gameID
    }
 
// MARK: ViewDidLoad
    func viewDidLoad() {
        self.delegate?.viewLoaded()
    }
    
// MARK: - Get Data
    func getDetail() {
        
        self.delegate?.setLoading(isLoading: true)
        
        detailService.fetchDetail(id: self.gameID) { [weak self] results in
            guard let self = self else { return }
            
            self.delegate?.setLoading(isLoading: false)
            switch results {
            case .success(let detail):
                self.detailName = detail?.name ?? ""
                self.detailDescription = detail?.description ?? ""
                self.detailBackgroundImage = detail?.backgroundImage ?? ""
                self.detailWebsite = detail?.website ?? ""
                self.delegate?.dataRefreshed()
                
            case .failure(let error):
                print(error)
                self.delegate?.dataError()
            }
        }
    }
}
