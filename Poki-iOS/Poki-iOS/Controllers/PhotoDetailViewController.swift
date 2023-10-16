//
//  DetailPhotoViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/16.
//

import UIKit

final class PhotoDetailViewController: UIViewController {
    
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
    
    private lazy var mainStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, dateLabel, mainImageView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .fill
        sv.setCustomSpacing(3, after: titleLabel)
        sv.setCustomSpacing(20, after: dateLabel)
        return sv
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
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubviews(backgroundBlurEffectView, mainStackView)
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
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
}
