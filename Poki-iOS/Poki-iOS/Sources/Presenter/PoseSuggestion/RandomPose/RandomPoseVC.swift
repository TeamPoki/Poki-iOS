//
//  RandomPoseViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/17

import UIKit
import SnapKit
import Then

enum Category {
    case alone, twoPeople, manyPeople
}

final class RandomPoseVC: UIViewController {
    
    // MARK: - Constants
    private let poseImageName = "alone-pose1"
    private let refreshButtonTitle = "다른 포즈보기"
    private let bookmarkButtonImageName = "star"
    
    // MARK: - Properties
    
    private var selectedCategory: Category?
    private var poseImages: [UIImage?] = []
    private  var imageDatas: [ImageData] = []
    private var imageData:ImageData?
    let firestoreManager = FirestoreManager.shared
    let storageManager = StorageManager.shared
    
    private lazy var poseImageView = UIImageView().then {
        $0.image = UIImage(named: poseImageName)
    }
    
    private lazy var refreshButton = UIButton().then {
        $0.titleLabel?.font = UIFont(name: Constants.fontSemiBold, size: 16)
        $0.setTitle(self.refreshButtonTitle, for: .normal)
        $0.setTitleColor( .black, for: .normal)
        $0.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
        $0.layer.cornerRadius = 25
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
        firestoreManager.poseRealTimebinding()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadButtonData()
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
        button.layer.borderColor = Constants.separatorGrayColor.cgColor
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
            $0.height.equalTo(50)
        }
    }
    
    func setup(selectCategory: Category) {
        self.selectedCategory = selectCategory
           switch selectCategory {
           case .alone:
               self.imageDatas = firestoreManager.poseData.filter{ $0.category == "alone" }
               self.imageData = imageDatas.randomElement()
           case .twoPeople:
               self.imageDatas = firestoreManager.poseData.filter{ $0.category == "twoPose" }
               self.imageData = imageDatas.randomElement()
           case .manyPeople:
               self.imageDatas = firestoreManager.poseData.filter{ $0.category == "manyPose" }
               self.imageData = imageDatas.randomElement()
           }
        guard let imageData = imageData else { return }
        storageManager.downloadImage(urlString: imageData.imageUrl) { [weak self] image in
               DispatchQueue.main.async {
                   self?.poseImageView.image = image
               }
           }
    }
    

    
    // MARK: - Actions
    
    @objc private func refreshButtonTapped(_ sender: UIButton) {
        self.imageData = self.imageDatas.randomElement()
        guard let imageData = imageData else { return }
        storageManager.downloadImage(urlString: imageData.imageUrl) { [weak self] image in
               DispatchQueue.main.async {
                   self?.poseImageView.image = image
                   self?.loadButtonData()
               }
           }
    }
    
    @objc private func bookmarkButtonTapped() {
        guard let imageData = imageData else { return }
        switch selectedCategory {
        case .alone:
            if imageData.isSelected == false {
                firestoreManager.poseImageUpdate(imageUrl: imageData.imageUrl, isSelected: true)
                self.bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                firestoreManager.poseImageUpdate(imageUrl: imageData.imageUrl, isSelected: false)
                self.bookmarkButton.setImage(UIImage(systemName: self.bookmarkButtonImageName), for: .normal)
            }
        case .twoPeople:
            if imageData.isSelected == false {
                firestoreManager.poseImageUpdate(imageUrl: imageData.imageUrl, isSelected: true)
                self.bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                firestoreManager.poseImageUpdate(imageUrl: imageData.imageUrl, isSelected: false)
                self.bookmarkButton.setImage(UIImage(systemName: self.bookmarkButtonImageName), for: .normal)
            }
        case .manyPeople:
            if imageData.isSelected == false {
                firestoreManager.poseImageUpdate(imageUrl: imageData.imageUrl, isSelected: true)
                self.bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                firestoreManager.poseImageUpdate(imageUrl: imageData.imageUrl, isSelected: false)
                self.bookmarkButton.setImage(UIImage(systemName: self.bookmarkButtonImageName), for: .normal)
            }
        case .none:
            print("category 미분류 데이터")
            break
        }
    }
    
    private func loadButtonData() {
        firestoreManager.poseRealTimebinding()
        guard let imageData = imageData else { return }
        switch selectedCategory {
        case .alone, .twoPeople, .manyPeople:
            if imageData.isSelected {
                self.bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                self.bookmarkButton.setImage(UIImage(systemName: self.bookmarkButtonImageName), for: .normal)
            }
        case .none:
            print("category 미분류 데이터")
            break
        }
    }
}
