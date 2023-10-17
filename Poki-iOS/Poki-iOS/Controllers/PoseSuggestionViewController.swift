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
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Constants.fontSemiBold, size: 26)
        label.text = "인원수를 선택해주세요."
        label.textAlignment = .center
        return label
    }()
    
    private let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
    
    private lazy var aloneButton: UIButton = {
        let button = UIButton()
        button.setTitle("혼자서 찍기", for: .normal)
        button.setImage(UIImage(systemName: "person.fill", withConfiguration: self.imageConfig), for: .normal)
        return button
    }()
    
    private lazy var twoPeopleButton: UIButton = {
        let button = UIButton()
        button.setTitle("둘이서 찍기", for: .normal)
        button.setImage(UIImage(systemName: "person.2.fill", withConfiguration: self.imageConfig), for: .normal)
        return button
    }()
    
    private lazy var manyPeopleButton: UIButton = {
        let button = UIButton()
        button.setTitle("여럿이서 찍기", for: .normal)
        button.setImage(UIImage(systemName: "person.3.fill", withConfiguration: self.imageConfig), for: .normal)
        return button
    }()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        addSubviews()
        setupLayout()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        configureNav()
        configure(aloneButton)
        configure(twoPeopleButton)
        configure(manyPeopleButton)
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
    }
    
    private func addSubviews() {
        view.addSubviews(commentLabel, aloneButton, twoPeopleButton, manyPeopleButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            commentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            commentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
        ])
        NSLayoutConstraint.activate([
            aloneButton.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 50),
            aloneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            aloneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            aloneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            twoPeopleButton.topAnchor.constraint(equalTo: aloneButton.bottomAnchor, constant: 50),
            twoPeopleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            twoPeopleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            twoPeopleButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        NSLayoutConstraint.activate([
            manyPeopleButton.topAnchor.constraint(equalTo: twoPeopleButton.bottomAnchor, constant: 50),
            manyPeopleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            manyPeopleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            manyPeopleButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions

}
