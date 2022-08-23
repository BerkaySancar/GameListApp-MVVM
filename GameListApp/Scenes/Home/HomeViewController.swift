//
//  ViewController.swift
//  GameListApp
//
//  Created by Berkay Sancar on 16.08.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let homeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        return collectionView
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Type here to search"
        searchBar.searchBarStyle = .prominent
        return searchBar
    }()
    
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView()
      
    private let viewModel: HomeViewModel
    
    init(_ viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        viewModel.getGameList()
        activityIndicator.startAnimating()
       
        viewModel.dataRefreshed = { [weak self] in
            self?.homeCollectionView.reloadData()
            self?.activityIndicator.stopAnimating()
        }
        
        viewModel.dataNotRefreshed = { [weak self] in
            self?.errorMessage(title: "ERROR", message: "Games could not loaded! Please pull to refresh.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.homeCollectionView.reloadData()
    }
// MARK: - UI Configure
    private func configure() {
        title = "Game List"
        view.backgroundColor = .systemBackground
        view.addSubview(homeCollectionView)
        view.addSubview(searchBar)
        view.addSubview(activityIndicator)
        searchBar.delegate = self
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        homeCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Reloading...")

        homeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.top).offset(-30)
            make.right.equalToSuperview().offset(-20)
        }
    }
// MARK: - Refresh Collection View Action
    @objc private func refreshCollectionView() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.viewModel.getGameList()
            self.homeCollectionView.refreshControl?.endRefreshing()
        }
    }
// MARK: - Favorite Button Actions
        
    @objc private func favButttonTapped(_ sender: UIButton) {
        
        sender.isSelected.toggle()
        
        if let data = CoreDataFavoriteHelper.shared
            .fetchData()?
            .filter({ $0.name == viewModel.games[sender.tag].name }) {
            
            if data.isEmpty {
                CoreDataFavoriteHelper.shared.saveData(name: viewModel.games[sender.tag].name ?? "",
                                                       id: viewModel.games[sender.tag].id ?? 0)
            } else {
                
                if let index = CoreDataFavoriteHelper.shared
                    .fetchData()?
                    .firstIndex(where: { $0.name == viewModel.games[sender.tag].name }) {
                    CoreDataFavoriteHelper.shared.deleteData(index: index)
                }
            }
        }
    }
}
// MARK: - COLLECTiON ViEW
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.games.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = homeCollectionView.dequeueReusableCell(
            withReuseIdentifier: HomeCollectionViewCell.identifier,
            for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        
        cell.gameFavButton.addTarget(self, action: #selector(favButttonTapped(_:)), for: UIControl.Event.touchUpInside)
        cell.gameFavButton.tag = indexPath.row
        cell.design(gameImageURL: viewModel.games[indexPath.row].background_image ?? "",
                    gameName: viewModel.games[indexPath.row].name ?? "")
        
        if let data = CoreDataFavoriteHelper
            .shared
            .fetchData()?
            .filter({ $0.name == viewModel.games[indexPath.row].name }) {
            cell.gameFavButton.isSelected = !data.isEmpty
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.size.width / 2.1, height: collectionView.frame.size.width / 2.1)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
// MARK: - SearchBar
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.viewModel.search(searchText)
    }
}
