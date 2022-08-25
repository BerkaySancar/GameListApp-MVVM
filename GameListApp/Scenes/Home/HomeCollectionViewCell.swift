//
//  HomeCollectionViewCell.swift
//  GameListApp
//
//  Created by Berkay Sancar on 18.08.2022.
//

import Kingfisher
import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "HomeCollectionViewCell"
    
    private let gameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let gameNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        label.textColor = .white
        return label
    }()
    
    let gameFavButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemRed
        button.backgroundColor = .white
        button.layer.cornerRadius = 7
        return button
    }()
 
 // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
// MARK: - Cell Configure
    private func configure() {
        
        contentView.addSubview(gameImageView)
        contentView.addSubview(gameNameLabel)
        contentView.addSubview(gameFavButton)
        
        gameNameLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        gameNameLabel.textColor = .white
        gameFavButton.setImage(UIImage(systemName: "heart"), for: UIControl.State.normal)
        gameFavButton.setImage(UIImage(systemName: "heart.fill"), for: UIControl.State.selected)
        
// MARK: - Constraints
        gameImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        gameNameLabel.snp.makeConstraints { make in
            make.left.right.equalTo(gameImageView)
            make.bottom.equalTo(gameImageView.snp.bottom).offset(-10)
        }
        gameFavButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.top.equalToSuperview().offset(5)
            make.width.height.equalTo(28)
        }
    }
 // MARK: - Design
    func design(gameImageURL: String, gameName: String) {
        guard let url = URL(string: gameImageURL) else { return }
        gameImageView.kf.setImage(with: url)
        gameNameLabel.text = gameName
    }
}
