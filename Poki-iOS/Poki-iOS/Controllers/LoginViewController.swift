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

    private let kakakoLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "Kakao Login"), for: .normal)
    }
    
    private let emailLoginButton = UIButton().then {
        $0.setImage(UIImage(named: "Email Login"), for: .normal)
        $0.addTarget(self, action: #selector(emailLoginButtonTapped), for: .touchUpInside)
    }
    
    private let signUpButton = UIButton().then {
        $0.titleLabel?.font = UIFont(name: Constants.fontMedium, size: 12)
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(UIColor.gray, for: .normal)
        $0.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    private let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 15
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
        buttonStackView.addArrangedSubviews(kakakoLoginButton, emailLoginButton, signUpButton)
        view.addSubviews(buttonStackView)
    }
    
    private func setupLayout() {
        buttonStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
    }
    
    // MARK: - Actions
    @objc private func emailLoginButtonTapped(_ sender: UIButton) {
        let moveVC = EmailLoginViewController()
        navigationController?.pushViewController(moveVC, animated: true)
    }
    
    @objc private func signUpButtonTapped(_ sender: UIButton) {
        print("회원가입 버튼 눌렀어유~")
    }
}
