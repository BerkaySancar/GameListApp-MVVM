//
//  DetailViewController.swift
//  GameListApp
//
//  Created by Berkay Sancar on 24.08.2022.
//

import Kingfisher
import SafariServices
import UIKit

protocol DetailViewDelegate: AnyObject {
    
    func setLoading(isLoading: Bool)
    func dataRefreshed()
    func dataError()
    func viewLoaded()
}

final class DetailViewController: UIViewController {
    
    private lazy var detailImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private lazy var detailName: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        label.textColor = .label
        return label
    }()
    private lazy var detailDescription: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.textColor = .label
        return label
    }()
    private lazy var websiteButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.setTitle("Go to official website", for: UIControl.State.normal)
        button.setTitleColor(UIColor.systemRed, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold)
        return button
    }()
    
    private lazy var scrollView = UIScrollView()
    private lazy var contentView = UIView()
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    private var viewModel: DetailViewModelProtocol
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }
    
// MARK: - Activity Indicator
    private func setActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.style = .medium
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(view.frame.height / 16)
            make.right.equalToSuperview().offset(-20)
        }
    }
// MARK: - Ui Configure
    private func configure() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
        title = viewModel.detailName
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(detailImage)
        contentView.addSubview(detailName)
        contentView.addSubview(detailDescription)
        contentView.addSubview(websiteButton)
        websiteButton.addTarget(self, action: #selector(websiteButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        
// MARK: Constraints
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.bottom.equalTo(view)
        }
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.left.right.equalTo(view)
        }
        detailImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.left.right.equalTo(view)
            make.height.equalTo(detailImage.snp.width)
        }
        detailName.snp.makeConstraints { make in
            make.top.equalTo(detailImage.snp.bottom).offset(10)
            make.centerX.equalTo(detailImage)
        }
        detailDescription.snp.makeConstraints { make in
            make.top.equalTo(detailName.snp.bottom).offset(12)
            make.left.right.equalTo(contentView).inset(20)
        }
        websiteButton.snp.makeConstraints { make in
            make.top.equalTo(detailDescription.snp.bottom).offset(10)
            make.left.right.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView).offset(-20)
        }
    }

// MARK: - Website Button Action & Safari Service
    @objc private func websiteButtonTapped(_ sender: UIButton) {
        
        if let url = URL(string: viewModel.detailWebsite ?? "") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
    }
}
// MARK: - DetailViewDelegate
extension DetailViewController: DetailViewDelegate {
    
    func setLoading(isLoading: Bool) {
        if isLoading == true {
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
    
    func dataRefreshed() {
        
        if let url = URL(string: viewModel.detailBackgroundImage ?? "") {
            detailImage.kf.setImage(with: url)
        }
        detailName.text = viewModel.detailName ?? ""
        let descriptionText = viewModel.detailDescription?
            .replacingOccurrences(of: "<p>", with: "")
            .replacingOccurrences(of: "</p>", with: "")
            .replacingOccurrences(of: "<br>", with: "")
            .replacingOccurrences(of: "<br />", with: "")
        detailDescription.text = descriptionText
       
        self.configure()
    }
    
    func dataError() {
        self.errorMessage(title: "WARNING", message: "Game details could not load. Please try again.")
    }
    
    func viewLoaded() {
        view.backgroundColor = .systemBackground
        self.setActivityIndicator()
        self.viewModel.getDetail()
    }
}
