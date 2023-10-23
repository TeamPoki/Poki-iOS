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
    }
    
    // MARK: - Helpers
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "회원가입"
    }
    
    private func addSubviews() {
        view.addSubviews(emailTextField)
    }
    
    private func setupLayout() {
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailTitleLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(44)
        }
    }
    
    // MARK: - Actions
    
    @objc private func textDidChange(_ textField: UITextField) {
        
    }
}
