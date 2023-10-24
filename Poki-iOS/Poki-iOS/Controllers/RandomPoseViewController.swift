//
//  RandomPoseViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/17

import UIKit

final class RandomPoseViewController: UIViewController {
    // MARK: - Constants
    private let poseImageName = "alone-pose1"
    private let refreshButtonTitle = "다른 포즈보기"
    private let bookmarkButtonImageName = "star"

    // MARK: - Components
    
    private lazy var poseImageView = UIImageView().then {
        $0.image = UIImage(named: poseImageName)
    }
    
    private lazy var refreshButton = UIButton().then {
        $0.titleLabel?.font = UIFont(name: Constants.fontSemiBold, size: 16)
        $0.setTitle(self.refreshButtonTitle, for: .normal)
        $0.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        $0.layer.cornerRadius = 8
    }
    
    private lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(systemName: self.bookmarkButtonImageName), for: .normal)
        $0.layer.cornerRadius = 30
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 20
    }
    
    private let mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 40
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        addSubviews()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Helpers
    
    private func configure() {
        view.backgroundColor = .white
        configureNav()
        configure(refreshButton)
        configure(bookmarkButton)
    }
    
    private func configureNav() {
        navigationController?.configureLineAppearance()
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    private func configure(_ button: UIButton) {
        button.backgroundColor = .black
        button.tintColor = .white
    }
    
    private func addSubviews() {
        buttonStackView.addArrangedSubviews(bookmarkButton, refreshButton)
        mainStackView.addArrangedSubviews(poseImageView, buttonStackView)
        view.addSubview(mainStackView)
    }
    
    private func setupLayout() {
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        } 
        bookmarkButton.snp.makeConstraints {
            $0.height.equalTo(60)
            $0.width.equalTo(60)
        }
        refreshButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
    }
    
    // MARK: - Actions
    
    @objc private func refreshButtonTapped(_ sender: UIButton) {
        let images = NetworkingManager.shared.getAlonePoseImages()
        guard let randomPose = images.randomElement() else { return }
        poseImageView.image = randomPose
    }
}
