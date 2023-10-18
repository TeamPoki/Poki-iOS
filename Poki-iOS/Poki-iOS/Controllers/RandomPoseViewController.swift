//
//  RandomPoseViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/17.
//

import UIKit

final class RandomPoseViewController: UIViewController {
    
    // MARK: - Components
    
    private let poseImageView = UIImageView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(named: "alone-pose-1")
    }
    
    private let refreshButton = UIButton().then {
        $0.titleLabel?.font = UIFont(name: Constants.fontSemiBold, size: 16)
        $0.setTitle("다른 포즈보기", for: .normal)
        $0.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        $0.layer.cornerRadius = 8
    }
    
    private let bookmarkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.layer.cornerRadius = 30
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 20
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        addSubviews()
        setupLayout()
    }
    
    // MARK: - Helpers
    
    private func configure() {
        configureNav()
        configure(refreshButton)
        configure(bookmarkButton)
    }
    
    private func configureNav() {
    }
    
    private func configure(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.tintColor = .white
    }
    
    private func addSubviews() {
        buttonStackView.addArrangedSubviews(bookmarkButton, refreshButton)
        view.addSubviews(poseImageView, buttonStackView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            poseImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            poseImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            poseImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            poseImageView.heightAnchor.constraint(equalToConstant: 480)
        ])
        NSLayoutConstraint.activate([
            refreshButton.heightAnchor.constraint(equalToConstant: 60),
            bookmarkButton.widthAnchor.constraint(equalToConstant: 60),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func refreshButtonTapped(_ sender: UIButton) {
        print("새로고침 버튼 눌렀음요~")
    }
}
