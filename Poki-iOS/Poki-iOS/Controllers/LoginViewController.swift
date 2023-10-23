//
//  LoginViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/18.
//

import UIKit
import SnapKit
import Then

class LoginViewController: UIViewController {
    
    // MARK: - Components
    private let topBackgroundView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let logoLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontHeavy, size: 46)
        $0.text = "POKI"
        $0.textColor = .white
    }
    
    private let commentLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontSemiBold, size: 14)
        $0.numberOfLines = 2
        $0.text = """
                    내가 찍은 인생네컷
                    이쁘게 보관할 수 있는 플랫폼
                    """
        $0.textColor = .white
        $0.setLineSpacing(spacing: 3)
    }
    
    private let emailTitleLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontSemiBold, size: 16)
        $0.text = "이메일"
        $0.textColor = .black
    }
    
    private let emailTextField = UITextField().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
    }
    
    private let passwordTitleLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontSemiBold, size: 16)
        $0.text = "비밀번호"
        $0.textColor = .black
    }
    
    private let passwordTextField = UITextField().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
    }
    
    private lazy var emailSaveButton = UIButton().then {
        let imageConfigure = UIImage.SymbolConfiguration(pointSize: 22)
        $0.tintColor = .lightGray
        $0.setImage(UIImage(systemName: "square", withConfiguration: imageConfigure), for: .normal)
        $0.addTarget(self, action: #selector(emailSaveButtonTapped), for: .touchUpInside)
    }
    
    private let emailSaveTextLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontMedium, size: 14)
        $0.text = "이메일 저장"
        $0.textColor = .black
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupLayout()
    }
    
    // MARK: - Helpers
    
    private func addSubviews() {
        topBackgroundView.addSubviews(logoLabel, commentLabel)
        view.addSubviews(topBackgroundView, emailTitleLabel, emailTextField, passwordTitleLabel, passwordTextField, emailSaveButton, emailSaveTextLabel)
    }
    
    private func setupLayout() {
        topBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
        logoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.leading.equalToSuperview().inset(20)
        }
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
        }
        emailTitleLabel.snp.makeConstraints {
            $0.top.equalTo(topBackgroundView.snp.bottom).offset(60)
            $0.leading.equalToSuperview().inset(20)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailTitleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        passwordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTitleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        emailSaveButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(25)
        }
        emailSaveTextLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(30)
            $0.leading.equalTo(emailSaveButton.snp.trailing).offset(5)
            $0.height.equalTo(25)
        }
    }
    
    // MARK: - Actions
    
    @objc private func emailSaveButtonTapped(_ sender: UIButton) {
        print("세이브 버튼 눌렀어염따")
    }
    
    @objc private func signUpButtonTapped(_ sender: UIButton) {
        print("회원가입 버튼 눌렀어유~")
    }
}
