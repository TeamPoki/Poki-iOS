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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupLayout()
    }
    
    private func addSubviews() {
        view.addSubviews(poseImageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            poseImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            poseImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            poseImageView.widthAnchor.constraint(equalToConstant: 150),
            poseImageView.heightAnchor.constraint(equalToConstant: 452)
        ])
    }
}
