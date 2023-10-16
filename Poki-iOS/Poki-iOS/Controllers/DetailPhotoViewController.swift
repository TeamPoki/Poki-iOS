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

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        addSubViews()
        setupLayout()
    }
    
    // MARK: - Helper
    private func addSubViews() {
        view.addSubviews(titleLabel, dateLabel)
    }
    
    private func setupLayout() {
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
    }
}
