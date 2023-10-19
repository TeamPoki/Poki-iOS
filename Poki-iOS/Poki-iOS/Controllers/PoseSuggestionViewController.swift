//
//  PoseSuggestionViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import SnapKit
import Then

final class PoseSuggestionViewController: UIViewController {
    // MARK: - Constants
    private let commentText = "인원수를 선택해주세요."
    
    private let aloneButtonText = "혼자서 찍기"
    private let aloneButtonImageName = "person.fill"
    
    private let twoPeopleButtonText = "둘이서 찍기"
    private let twoPeopleButtonImageName = "person.2.fill"
    
    private let manyPeopleButtonText = "여럿이서 찍기"
    private let manyPeopleButtonImageName = "person.3.fill"
    
    // MARK: - Properties
    
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
        $0.spacing = 70
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        addSubviews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav()
    }
    
    // MARK: - Helpers
    
    private func configure() {
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
        button.backgroundColor = .black
        button.tintColor = .white
        button.titleLabel?.font = UIFont(name: Constants.fontBold, size: 16)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(numberOfPeopleButtonTapped), for: .touchUpInside)
    }
    
    private func addSubviews() {
        mainStackView.addArrangedSubviews(commentLabel, aloneButton, twoPeopleButton, manyPeopleButton)
        view.addSubview(mainStackView)
    }
    
    private func setupLayout() {
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
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc private func numberOfPeopleButtonTapped(_ sender: UIButton) {
        let moveVC = RandomPoseViewController()
        switch sender.tag {
        case 1:
            moveVC.title = self.aloneButtonText
        case 2:
            moveVC.title = self.twoPeopleButtonText
        case 3:
            moveVC.title = self.manyPeopleButtonText
        default:
            print("에러")
        }
        navigationController?.pushViewController(moveVC, animated: true)
    }
}
