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
    
    // MARK: - Properties
    
    private let commentLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont(name: Constants.fontSemiBold, size: 26)
        $0.text = "인원수를 선택해주세요."
        $0.textAlignment = .center
    }
    
    private let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
    
    /// RandomPoseViewController 로 전환할 때 혼자서 찍기, 둘이서 찍기, 여럿이서 찍기인지 구분이 필요할 것 같아서 우선 버튼에 tag 를 넣어놨습니다!
    private lazy var aloneButton = UIButton().then {
        $0.setTitle("혼자서 찍기", for: .normal)
        $0.setImage(UIImage(systemName: "person.fill", withConfiguration: self.imageConfig), for: .normal)
        $0.tag = 1
    }
    
    private lazy var twoPeopleButton = UIButton().then {
        $0.setTitle("둘이서 찍기", for: .normal)
        $0.setImage(UIImage(systemName: "person.2.fill", withConfiguration: self.imageConfig), for: .normal)
        $0.tag = 2
    }
    
    private lazy var manyPeopleButton = UIButton().then {
        $0.setTitle("여럿이서 찍기", for: .normal)
        $0.setImage(UIImage(systemName: "person.3.fill", withConfiguration: self.imageConfig), for: .normal)
        $0.tag = 3
    }
    
    private lazy var mainStackView = UIStackView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
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
    
    // MARK: - Helpers
    
    private func configure() {
        configureNav()
        [aloneButton, twoPeopleButton, manyPeopleButton].forEach { configure($0) }
    }

    private func configureNav() {
        navigationItem.title = "포즈 추천"
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
            $0.shadowColor = .lightGray
        }
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configure(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        NSLayoutConstraint.activate([
            aloneButton.heightAnchor.constraint(equalToConstant: 60),
            twoPeopleButton.heightAnchor.constraint(equalToConstant: 60),
            manyPeopleButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    @objc private func numberOfPeopleButtonTapped(_ sender: UIButton) {
        let moveVC = RandomPoseViewController()
        switch sender.tag {
        case 1:
            moveVC.title = "혼자서 찍기"
        case 2:
            moveVC.title = "둘이서 찍기"
        case 3:
            moveVC.title = "여럿이서 찍기"
        default:
            print("에러")
        }
        navigationController?.pushViewController(moveVC, animated: true)
    }
}
