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
        $0.placeholder = " 이메일 입력해라"
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
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
        view.addSubviews(topBackgroundView, emailTitleLabel, emailTextField)
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
    }
    
    // MARK: - Actions
    
    @objc private func signUpButtonTapped(_ sender: UIButton) {
        print("회원가입 버튼 눌렀어유~")
    }
}
