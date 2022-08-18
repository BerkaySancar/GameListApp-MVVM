//
//  ViewController.swift
//  GameListApp
//
//  Created by Berkay Sancar on 16.08.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private var viewModel: HomeViewModel
    
    init(_ viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemOrange
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        viewModel.getGameList()
        
        viewModel.dataRefreshed = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.games.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.games[indexPath.row].name
        return cell
    }
}
