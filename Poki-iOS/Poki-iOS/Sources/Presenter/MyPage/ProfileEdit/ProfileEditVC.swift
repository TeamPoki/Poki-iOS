//
//  ProfileEditViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/20/23.
//

import UIKit
import Then

final class ProfileEditVC: UIViewController {
    
    // MARK: - Properties
    private var backGroundImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }
    
    private var userImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 60
        $0.clipsToBounds = true
    }
    
    private var nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont(name: Constants.fontBold, size: 16)
        $0.textColor = .black
        $0.textAlignment = .left
    }
    
    private var nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력하세요"
        $0.font = UIFont(name: Constants.fontRegular, size: 14)
        $0.borderStyle = .roundedRect
    }
    
    private var hintLabel = UILabel().then {
        $0.text = "닉네임을 입력해주세요!"
        $0.font = UIFont(name: Constants.fontMedium, size: 14)
        $0.textColor = .red
        $0.isHidden = false
    }
    
    private var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        view.backgroundColor = .white
        
        configureUserImageView()
        configureStackView()
        configureRightBarButton()
        
        nicknameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "프로필 수정"
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black, .font: UIFont(name: Constants.fontMedium, size: 17)]
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureUserImageView() {
        view.addSubview(backGroundImageView)
        
        backGroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backGroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            backGroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),// 네비게이션 바와의 간격을 30으로 설정
            backGroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20), // 왼쪽 간격을 20으로 설정
            backGroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20), // 오른쪽 간격을 20으로 설정
        ])
        
        view.addSubview(userImageView)
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            userImageView.centerXAnchor.constraint(equalTo: backGroundImageView.centerXAnchor), // 가로 가운데에 위치
            userImageView.centerYAnchor.constraint(equalTo: backGroundImageView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 120),
            userImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // 버튼 생성
        let button = UIButton(type: .system)
        button.setTitle("버튼", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10.0
        
        userImageView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: userImageView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: userImageView.bottomAnchor)
        ])
    }
    
    private func configureStackView() {
        stackView.addArrangedSubview(nicknameLabel)
        stackView.addArrangedSubview(nicknameTextField)
        stackView.addArrangedSubview(hintLabel)
        
        nicknameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureNicknameLabel() {
        view.addSubview(nicknameLabel)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 30),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    private func configureNicknameTextField() {
        view.addSubview(nicknameTextField)
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 10),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func configureRightBarButton() {
        let doneButton = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        doneButton.setTitleTextAttributes([.font: UIFont(name: Constants.fontMedium, size: 17)], for: .normal)
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureHintLabel() {
        view.addSubview(hintLabel)
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hintLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 5),
            hintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
    }
    
    // MARK: - Actions
    @objc private func buttonTapped() {
        //유저 이미지 변경하는 메서드
    }
    
    @objc private func doneButtonTapped() {
        //닉네임이 수정되고 저장되는 메서드
    }
    
    @objc private func textFieldEditingChanged() {
        if let text = nicknameTextField.text, text.isEmpty {
            hintLabel.isHidden = false
        } else {
            hintLabel.isHidden = true
        }
    }
    
}
