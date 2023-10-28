//
//  RandomPoseViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/17

import UIKit
import SnapKit
import Then

final class RandomPoseVC: UIViewController {
    
    var selectedButton = false
    
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
        $0.tintColor = UIColor.yellow
        $0.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UserDataManager.loadUserData()
        loadButtonData()
//        UserDataManager.removeUserData()
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
        loadButtonData()
    }
    
    @objc private func bookmarkButtonTapped() {
        guard let imageData = poseImageView.image?.pngData() else { return }
        
        if selectedButton == false {
            bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            switch selectedCategory {
            case .alone:
                UserDataManager.userData.likedPose.firstPose.append((imageData))
            case .twoPeople:
                UserDataManager.userData.likedPose.secondPose.append((imageData))
            case .manyPeople:
                UserDataManager.userData.likedPose.thirdPose.append((imageData))
            case .none:
                break
            }
            UserDataManager.saveUserData()
            selectedButton.toggle()
        } else {
            bookmarkButton.setImage(UIImage(systemName: bookmarkButtonImageName), for: .normal)
            switch selectedCategory {
            case .alone:
                if let index = UserDataManager.userData.likedPose.firstPose.firstIndex(of: imageData) {
                    UserDataManager.userData.likedPose.firstPose.remove(at: index)
                }
            case .twoPeople:
                if let index = UserDataManager.userData.likedPose.secondPose.firstIndex(of: imageData) {
                    UserDataManager.userData.likedPose.secondPose.remove(at: index)
                }
            case .manyPeople:
                if let index = UserDataManager.userData.likedPose.thirdPose.firstIndex(of: imageData) {
                    UserDataManager.userData.likedPose.thirdPose.remove(at: index)
                }
            case .none:
                break
            }
            UserDataManager.saveUserData()
            selectedButton.toggle()
        }
    }
    
    private func loadButtonData() {
        guard let imageData = poseImageView.image?.pngData() else { return }
        switch selectedCategory {
        case .alone:
            if UserDataManager.userData.likedPose.firstPose.contains(imageData) {
                bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                selectedButton = true
            } else {
                bookmarkButton.setImage(UIImage(systemName: bookmarkButtonImageName), for: .normal)
                selectedButton = false
            }
        case .twoPeople:
            if UserDataManager.userData.likedPose.secondPose.contains(imageData) {
                bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                selectedButton = true
            } else {
                bookmarkButton.setImage(UIImage(systemName: bookmarkButtonImageName), for: .normal)
                selectedButton = false
            }
        case .manyPeople:
            if UserDataManager.userData.likedPose.thirdPose.contains(imageData) {
                bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                selectedButton = true
            } else {
                bookmarkButton.setImage(UIImage(systemName: bookmarkButtonImageName), for: .normal)
                selectedButton = false
            }
        case .none:
            break
        }
    }
    
 
}
