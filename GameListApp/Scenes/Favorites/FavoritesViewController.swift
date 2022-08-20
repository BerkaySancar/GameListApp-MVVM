//
//  FavoritesViewController.swift
//  GameListApp
//
//  Created by Berkay Sancar on 17.08.2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    private let favoritesTableview: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    private func configure() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(favoritesTableview)
        
        favoritesTableview.delegate = self
        favoritesTableview.dataSource = self
    }
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        return cell
    }
}
