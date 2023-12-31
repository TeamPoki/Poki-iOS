//
//  PoseSuggestionViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import SnapKit
import Then

final class PoseSuggestionVC: UIViewController {
    // MARK: - Constants
    private let commentText = "인원수를 선택해주세요."
    
    private let aloneButtonText = "혼자서 찍기"
    private let aloneButtonImageName = "person.fill"
    
    private let twoPeopleButtonText = "둘이서 찍기"
    private let twoPeopleButtonImageName = "person.2.fill"
    
    private let manyPeopleButtonText = "여럿이서 찍기"
    private let manyPeopleButtonImageName = "person.3.fill"
    
    // 아이폰 15 pro 화면 넓이가 393 이여서 기준을 393으로 잡았습니다.
    var isMaxDevice: Bool {
        UIScreen.main.bounds.size.width > 393
    }
    
    // MARK: - Properties
    
    let firestoreManager =  FirestoreManager.shared
    
    private lazy var commentLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: Constants.fontSemiBold, size: 26)
        $0.text = self.commentText
        $0.textAlignment = .center
    }
    
    private let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
    
    /// RandomPoseViewController 로 전환할 때 혼자서 찍기, 둘이서 찍기, 여럿이서 찍기인지 구분이 필요할 것 같아서 우선 버튼에 tag 를 넣어놨습니다!
    private lazy var aloneButton = UIButton().then {
        $0.setTitle(self.aloneButtonText, for: .normal)
        $0.setImage(UIImage(systemName: self.aloneButtonImageName, withConfiguration: self.imageConfig), for: .normal)
        $0.tag = 1
    }
    
    private lazy var twoPeopleButton = UIButton().then {
        $0.setTitle(self.twoPeopleButtonText, for: .normal)
        $0.setImage(UIImage(systemName: self.twoPeopleButtonImageName, withConfiguration: self.imageConfig), for: .normal)
        $0.tag = 2
    }
    
    private lazy var manyPeopleButton = UIButton().then {
        $0.setTitle(self.manyPeopleButtonText, for: .normal)
        $0.setImage(UIImage(systemName: self.manyPeopleButtonImageName, withConfiguration: self.imageConfig), for: .normal)
        $0.tag = 3
    }
    
    private lazy var mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 50
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupLayout()
        setupRecommendPoseImage()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav()
    }
    
    deinit {
        print("deinit: 포즈 추천 페이지 사라집니다.!")
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        [aloneButton, twoPeopleButton, manyPeopleButton].forEach { configure($0) }
    }

    private func configureNav() {
        navigationItem.title = "포즈 추천"
        navigationController?.configureLineAppearance()
    }
    
    private func configure(_ button: UIButton) {
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.imagePadding = 10
        button.configuration = buttonConfig
        button.backgroundColor = Constants.appBlackColor
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(numberOfPeopleButtonTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        mainStackView.addArrangedSubviews(aloneButton, twoPeopleButton, manyPeopleButton)
        view.addSubviews(commentLabel, mainStackView)
    }
    
    private func setupLayout() {
        if self.isMaxDevice == true {
            setupLayoutForMaxDevice()
        }
        if self.isMaxDevice == false {
            setupDefaultLayout()
        }
    }
    
    private func setupDefaultLayout() {
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(90)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
        }
        aloneButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        twoPeopleButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        manyPeopleButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(90)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
        }
    }
    
    /// 아이폰 max 일 때, 레이아웃 조정
    private func setupLayoutForMaxDevice() {
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(120)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
        }
        aloneButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        twoPeopleButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        manyPeopleButton.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(90)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
        }
    }
    
    private func setupRecommendPoseImage() {
        firestoreManager.fetchRecommendPoseDocumentFromFirestore { error in
            if let error = error {
                print("ERROR: 포즈 추천 페이지에서 추천 포즈 문서를 불러오지 못했습니다 ㅠㅠ \(error)")
                return
            }
            if self.firestoreManager.poseData.isEmpty {
                self.firestoreManager.makePoseData()
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func numberOfPeopleButtonTapped(_ sender: UIButton) {
        let moveVC = RandomPoseVC()
        switch sender.tag {
        case 1:
            moveVC.title = self.aloneButtonText
            moveVC.setup(selectCategory: .alone)
        case 2:
            moveVC.title = self.twoPeopleButtonText
            moveVC.setup(selectCategory: .twoPeople)
        case 3:
            moveVC.title = self.manyPeopleButtonText
            moveVC.setup(selectCategory: .manyPeople)
        default:
            print("에러")
        }
        moveVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(moveVC, animated: true)
    }
}
