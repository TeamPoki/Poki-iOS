//
//  RandomPoseViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/17

import UIKit

final class RandomPoseViewController: UIViewController {
    
    enum Category {
        case alone, twoPeople, manyPeople
    }
    
    // MARK: - Constants
    private let poseImageName = "alone-pose1"
    private let refreshButtonTitle = "다른 포즈보기"
    private let bookmarkButtonImageName = "star"

    // MARK: - Properties
    
    private var selectedCategory: Category?
    private var poseImages: [UIImage?] = []
    
    private lazy var poseImageView = UIImageView().then {
        $0.image = UIImage(named: poseImageName)
    }
    
    private lazy var refreshButton = UIButton().then {
        $0.titleLabel?.font = UIFont(name: Constants.fontSemiBold, size: 16)
        $0.setTitle(self.refreshButtonTitle, for: .normal)
        $0.setTitleColor( .black, for: .normal)
        $0.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        $0.layer.cornerRadius = 8
    }
    
    private lazy var bookmarkButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25)
        $0.setImage(UIImage(systemName: self.bookmarkButtonImageName, withConfiguration: imageConfig), for: .normal)
        $0.layer.cornerRadius = 55 / 2
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
        configureUI()
        addSubviews()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
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
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
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
            $0.height.equalTo(55)
            $0.width.equalTo(55)
        }
        refreshButton.snp.makeConstraints {
            $0.height.equalTo(55)
        }
    }
    
    func setup(selectCategory: Category) {
        self.selectedCategory = selectCategory
        switch selectCategory {
        case .alone:
            self.poseImages = PoseImageManager.shared.getAlonePoseImages()
        case .twoPeople:
            self.poseImages = PoseImageManager.shared.getTwoPoseImages()
        case .manyPeople:
            self.poseImages = PoseImageManager.shared.getManyPoseImages()
        }
        self.poseImageView.image = poseImages.randomElement() ?? UIImage()
    }
    
    // MARK: - Actions
    
    @objc private func refreshButtonTapped(_ sender: UIButton) {
        guard let randomPose = poseImages.randomElement() else { return }
        poseImageView.image = randomPose
    }
}
