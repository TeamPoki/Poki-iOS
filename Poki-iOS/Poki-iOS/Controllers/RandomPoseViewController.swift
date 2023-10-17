//
//  RandomPoseViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/17.
//

import UIKit

final class RandomPoseViewController: UIViewController {
    
    private let poseImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "alone-pose-1")
        return iv
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.titleLabel?.font = UIFont(name: Constants.fontSemiBold, size: 16)
        button.titleLabel?.tintColor = .white
        button.setTitle("다른 포즈보기", for: .normal)
        button.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupLayout()
    }
    
    private func addSubviews() {
        view.addSubviews(poseImageView, refreshButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            poseImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            poseImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            poseImageView.widthAnchor.constraint(equalToConstant: 150),
            poseImageView.heightAnchor.constraint(equalToConstant: 452)
        ])
        NSLayoutConstraint.activate([
            refreshButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            refreshButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            refreshButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            refreshButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    @objc private func refreshButtonTapped(_ sender: UIButton) {
        print("새로고침 버튼 눌렀음요~")
    }
}
