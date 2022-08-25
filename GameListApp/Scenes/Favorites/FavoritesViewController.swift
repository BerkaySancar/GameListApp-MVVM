//
//  FavoritesViewController.swift
//  GameListApp
//
//  Created by Berkay Sancar on 17.08.2022.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    private let favoritesTableview: UITableView = {
        let tableView = UITableView()
        tableView.register(FavoritesTableViewCell.self,
                           forCellReuseIdentifier: FavoritesTableViewCell.identifier)
        return tableView
    }()
    
    private let viewModel: FavoritesViewModel

// MARK: - Init
    init(_ viewModel: FavoritesViewModel = FavoritesViewModel()) {
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
        
        viewModel.dataRefreshed = { [weak self] in
            self?.favoritesTableview.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchFavGames()
    }
 // MARK: - Ui Configure
    private func configure() {
        title = "Favorite Games"
        view.backgroundColor = .systemBackground
        view.addSubview(favoritesTableview)
        
        favoritesTableview.delegate = self
        favoritesTableview.dataSource = self
 
 // MARK: Constraints
        favoritesTableview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
 // MARK: - Unfollow Button Actions
    @objc private func unFavButtonTapped(_ sender: UIButton) {
       
        viewModel.deleteFavGames(index: sender.tag)
        viewModel.fetchFavGames()
    }
}
// MARK: - Favorites Table View
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.favGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoritesTableViewCell.identifier,
            for: indexPath) as? FavoritesTableViewCell else { return UITableViewCell() }
        
        cell.unFavButton.tag = indexPath.row
        cell.selectionStyle = .none
        cell.design(name: viewModel.favGames[indexPath.row].name ?? "")
        cell.unFavButton.addTarget(self, action: #selector(unFavButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
