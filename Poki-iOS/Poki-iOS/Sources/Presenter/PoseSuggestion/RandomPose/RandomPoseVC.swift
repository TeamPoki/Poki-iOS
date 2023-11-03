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
    var isSelected = false
    var urlData = ""
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
        $0.setImage(UIImage(systemName: "star.fill", withConfiguration: imageConfig), for: .selected)
        $0.layer.cornerRadius = 25
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
        loadButtonData()
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
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        bookmarkButton.snp.makeConstraints {
            $0.height.width.equalTo(50)
        }
        refreshButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    func setup(selectCategory: Category) {
        self.selectedCategory = selectCategory
        self.showLoadingIndicator()
           switch selectCategory {
           case .alone:
               self.setupPoseData(categoryString: "alone")
           case .twoPeople:
               self.setupPoseData(categoryString: "twoPose")
           case .manyPeople:
               self.setupPoseData(categoryString: "manyPose")
        }
    }
    
    func setupPoseData(categoryString: String) {
        guard let Arraydata = firestoreManager.poseData.filter({ $0.category == categoryString }).randomElement() else { return }
        let url = Arraydata.imageUrl
        let isSelected = Arraydata.isSelected
        storageManager.downloadImage(urlString: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.poseImageView.image = image
                self?.isSelected = isSelected
                self?.urlData = url
                self?.loadButtonData()
                self?.hideLoadingIndicator()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func refreshButtonTapped(_ sender: UIButton) {
        self.showLoadingIndicator()
        switch selectedCategory {
        case .alone:
            self.setupPoseData(categoryString: "alone")
        case .twoPeople:
            self.setupPoseData(categoryString: "twoPose")
        case .manyPeople:
            self.setupPoseData(categoryString: "manyPose")
        case .none:
            break
        }
    }
    
    private func updateBookmark() {
        if isSelected == true {
            firestoreManager.poseImageUpdate(imageUrl: urlData, isSelected: false)
            isSelected = false
            return
        }
        
        if isSelected == false {
            firestoreManager.poseImageUpdate(imageUrl: urlData, isSelected: true)
            isSelected = true
            return
        }
    }
    
    @objc private func bookmarkButtonTapped() {
        switch selectedCategory {
        case .alone:
            updateBookmark()
        case .twoPeople:
            updateBookmark()
        case .manyPeople:
            updateBookmark()
        case .none:
            print("category 미분류 데이터")
            break
        }
    }
    
    private func loadButtonData() {
        firestoreManager.poseRealTimebinding { [weak self] images in
            guard let self = self else { return }
            
            switch selectedCategory {
            case .alone, .twoPeople, .manyPeople:
                if isSelected {
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
    
    
}
