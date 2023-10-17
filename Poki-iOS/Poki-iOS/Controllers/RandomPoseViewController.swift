//
//  RandomPoseViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/17.
//

import UIKit

final class RandomPoseViewController: UIViewController {
    
    // MARK: - Components
    
    private let poseImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "alone-pose-1")
        return iv
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: Constants.fontSemiBold, size: 16)
        button.setTitle("다른 포즈보기", for: .normal)
        button.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.layer.cornerRadius = 30
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [bookmarkButton, refreshButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 20
        return sv
    }()

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
