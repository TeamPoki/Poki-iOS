//
//  SignUpViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private let emailTitleLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont(name: Constants.fontBold, size: 16)
        $0.textColor = .black
    }
    
    private lazy var emailTextField = UITextField().then {
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.tintColor = .black
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.keyboardType = .emailAddress
        $0.placeholder = "이메일을 입력하세요."
    }
    
    private lazy var passwordTextField = UITextField().then {
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.tintColor = .black
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.isSecureTextEntry = true
        $0.placeholder = "비밀번호를 입력하세요."
    }
    
    private lazy var passwordCheckTextField = UITextField().then {
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.tintColor = .black
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.isSecureTextEntry = true
        $0.placeholder = "비밀번호를 확인해주세요."
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: Constants.fontBold, size: 16)
        $0.layer.cornerRadius = 5
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
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emailTextField.addUnderline()
        passwordTextField.addUnderline()
        passwordCheckTextField.addUnderline()
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "회원가입"
    }
    
    private func addSubviews() {
        view.addSubviews(emailTextField, passwordTextField, passwordCheckTextField, signUpButton)
    }
    
    private func setupLayout() {
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(5)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(55)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(55)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
        signUpButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(25)
            $0.height.equalTo(50)
        }
    }
    
    // MARK: - Actions
    
    @objc private func textDidChange(_ textField: UITextField) {
        
    }
}
