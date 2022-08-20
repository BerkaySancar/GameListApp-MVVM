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
        
        viewModel.getGameList()
        configure()
        activityIndicator.startAnimating()
       
        viewModel.dataRefreshed = { [weak self] in
            self?.homeCollectionView.reloadData()
            self?.activityIndicator.stopAnimating()
        }
    }
// MARK: - UI Configure
    private func configure() {
        title = "Game List"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(homeCollectionView)
        view.addSubview(searchBar)
        view.addSubview(activityIndicator)
        searchBar.delegate = self
        
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self

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
// MARK: - Favorite Button Actions
        
    @objc private func favButttonTapped(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
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
        cell.design(gameImageURL: viewModel.games[indexPath.row].background_image ?? "",
                    gameName: viewModel.games[indexPath.row].name ?? "")
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.size.width / 2.1, height: collectionView.frame.size.width / 1.8)
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
