//
//  SignUpViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties

    private lazy var emailTextFieldView = UIView().then {
        $0.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
        $0.addSubview(emailTextField)
        $0.addSubview(emailTitleLabel)
    }
    
    private let emailTitleLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .lightGray
    }
    
    private lazy var emailTextField = UITextField().then {
        $0.frame.size.height = 44
        $0.backgroundColor = .clear
        $0.textColor = .white
        $0.tintColor = .white
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.keyboardType = .emailAddress
        $0.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "회원가입"
        navigationController?.navigationBar.isHidden = false
        addSubviews()
        setupLayout()
    }
    
    // MARK: - Helpers
    private func addSubviews() {
        view.addSubviews(emailTextFieldView)
    }
    
    private func setupLayout() {
        emailTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(emailTextFieldView).inset(8)
            $0.trailing.equalTo(emailTextFieldView).inset(8)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextFieldView).inset(15)
            $0.leading.equalTo(emailTextFieldView).inset(8)
            $0.trailing.equalTo(emailTextFieldView).inset(8)
            $0.bottom.equalTo(emailTextFieldView).inset(2)
        }
        emailTextFieldView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    // MARK: - Actions
    
    @objc private func textDidChange(_ textField: UITextField) {
        
    }
}
