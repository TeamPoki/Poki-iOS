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
    private var poseData: ImageData?
    private let firestoreManager = FirestoreManager.shared
    private let storageManager = StorageManager.shared
    
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
        setup(selectCategory: self.selectedCategory!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
               self.setupPoseData(categoryString: "alone") {
                   self.hideLoadingIndicator()
               }
           case .twoPeople:
               self.setupPoseData(categoryString: "twoPose") {
                   self.hideLoadingIndicator()
               }
           case .manyPeople:
               self.setupPoseData(categoryString: "manyPose") {
                   self.hideLoadingIndicator()
               }
        }
    }
    
    func setupPoseData(categoryString: String, completion: @escaping () -> Void) {
        guard let pose = firestoreManager.poseData.filter({ $0.category == categoryString }).randomElement() else { return }
        
        self.poseData = pose
        
        if pose.isSelected == true {
            self.bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        
        if pose.isSelected == false {
            self.bookmarkButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    
        let url = URL(string: pose.imageUrl)
        
        self.poseImageView.kf.setImage(with: url)
    }
    
    // MARK: - Actions
    
    @objc private func refreshButtonTapped(_ sender: UIButton) {
        self.showLoadingIndicator()
        switch selectedCategory {
        case .alone:
            self.setupPoseData(categoryString: "alone") {
                self.hideLoadingIndicator()
            }
        case .twoPeople:
            self.setupPoseData(categoryString: "twoPose") {
                self.hideLoadingIndicator()
            }
        case .manyPeople:
            self.setupPoseData(categoryString: "manyPose") {
                self.hideLoadingIndicator()
            }
        case .none:
            break
        }
    }
    
    private func updateBookmark(completion: @escaping (Error?) -> Void) {
        self.poseData?.isSelected.toggle()
        guard let poseData = self.poseData else { return }
        if self.poseData?.isSelected == true {
            self.bookmarkButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            self.firestoreManager.poseImageUpdate(imageUrl: poseData.imageUrl, isSelected: poseData.isSelected) { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                self.firestoreManager.fetchPhotoFromFirestore { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                }
            }
        }
        
        if self.poseData?.isSelected == false {
            self.bookmarkButton.setImage(UIImage(systemName: "star"), for: .normal)
            self.firestoreManager.poseImageUpdate(imageUrl: poseData.imageUrl, isSelected: poseData.isSelected) { error in
                if let error = error {
                    completion(error)
                    return
                }
                
                self.firestoreManager.fetchPhotoFromFirestore { error in
                    if let error = error {
                        completion(error)
                        return
                    }
                }
            }
        }
    }
    
    @objc private func bookmarkButtonTapped() {
        switch selectedCategory {
        case .alone:
            updateBookmark { error in
                if let error = error {
                    print("ERROR: RandomPoseVC - 추천 포즈 이미지 북마크 업데이트를 실패했습니다. ㅠㅠ \(error)")
                    return
                }
            }
        case .twoPeople:
            updateBookmark { error in
                if let error = error {
                    print("ERROR: RandomPoseVC - 추천 포즈 이미지 북마크 업데이트를 실패했습니다. ㅠㅠ \(error)")
                    return
                }
            }
        case .manyPeople:
            updateBookmark { error in
                if let error = error {
                    print("ERROR: RandomPoseVC - 추천 포즈 이미지 북마크 업데이트를 실패했습니다. ㅠㅠ \(error)")
                    return
                }
            }
        case .none:
            print("category 미분류 데이터")
            break
        }
    }
}
