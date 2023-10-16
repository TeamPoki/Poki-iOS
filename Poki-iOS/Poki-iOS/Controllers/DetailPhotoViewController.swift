//
//  DetailPhotoViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/16.
//

import UIKit

final class DetailPhotoViewController: UIViewController {
    
    // MARK: - Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.fontBold, size: 32)
        label.text = "GOOD EATS"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.fontBold, size: 16)
        label.text = "2023. 10. 16"
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "인생네컷")
        return iv
    }()
    
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "인생네컷")
        return iv
    }()
    
    private lazy var backgroundBlurEffectView: UIVisualEffectView = {
        let effectView = UIVisualEffectView()
        effectView.translatesAutoresizingMaskIntoConstraints = false
        effectView.effect = UIBlurEffect(style: .light)
        return effectView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        addSubViews()
        setupLayout()
    }
    
    // MARK: - Helper
    private func configureNav() {
        let backButton = UIBarButtonItem(image: UIImage(named: "backButton"), style: .done, target: nil, action: nil)
        backButton.tintColor = .white
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .done, target: nil, action: nil)
        menuButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = menuButton
    }
    
    private func addSubViews() {
        view.addSubviews(backgroundImageView)
        backgroundImageView.addSubviews(backgroundBlurEffectView, titleLabel, dateLabel, mainImageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            backgroundBlurEffectView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            backgroundBlurEffectView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            backgroundBlurEffectView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            backgroundBlurEffectView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            mainImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainImageView.heightAnchor.constraint(equalToConstant: 537)
        ])
    }
}
