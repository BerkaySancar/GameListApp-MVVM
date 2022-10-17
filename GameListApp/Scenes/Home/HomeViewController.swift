//
//  ViewController.swift
//  GameListApp
//
//  Created by Berkay Sancar on 16.08.2022.
//

import UIKit

protocol HomeViewDelegate: AnyObject {
    
    func setLoading(isLoading: Bool)
    func dataRefreshed()
    func dataError()
    func viewLoaded()
}

final class HomeViewController: UIViewController {
    
    private lazy var homeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Type here to search"
        searchBar.searchBarStyle = .prominent
        return searchBar
    }()
    
    private lazy var refreshControl = UIRefreshControl()
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    private var viewModel: HomeViewModelProtocol
    
// MARK: - Init
    init(_ viewModel: HomeViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

// MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.viewDidLoad()
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
        
// MARK: Constraints
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
        
        viewModel.favoriteButtonTapped(senderTag: sender.tag)
    }
}
// MARK: - HomeViewDelegate
extension HomeViewController: HomeViewDelegate {
    
    func viewLoaded() {
        configure()
        viewModel.getGameList()
    }
    
    func setLoading(isLoading: Bool) {
        if isLoading == true {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func dataRefreshed() {
        self.homeCollectionView.reloadData()
    }
    
    func dataError() {
        self.errorMessage(title: "ERROR", message: "Games could not loaded! Please pull to refresh.")
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
        cell.design(gameImageURL: viewModel.games[indexPath.row].backgroundImage ?? "",
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let selectedGame = viewModel.games[indexPath.row].id else { return }
        let detailVM = DetailViewModel(gameID: selectedGame)
        
        navigationController?.pushViewController(DetailViewController(viewModel: detailVM), animated: true)
    }
}
// MARK: - SearchBar
extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel.search(searchText)
    }
}
