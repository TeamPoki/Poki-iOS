//
//  SignUpViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/23.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    private let emailPlaceholder = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont(name: Constants.fontRegular, size: 16)
        $0.textColor = .lightGray
    }
    
    private let emailTextField = UITextField().then {
        $0.keyboardType = .emailAddress
    }
    
    private let emailTextFieldView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let passwordPlaceholder = UILabel().then {
        $0.text = "비밀번호"
        $0.font = UIFont(name: Constants.fontRegular, size: 16)
        $0.textColor = .lightGray
    }
    
    private let passwordTextField = UITextField().then {
        $0.isSecureTextEntry = true
    }
    
    private let passwordTextFieldView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let nicknamePlaceholder = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont(name: Constants.fontRegular, size: 16)
        $0.textColor = .lightGray
    }
    
    private let nicknameTextField = UITextField().then {
        $0.keyboardType = .alphabet
    }
    
    private let nicknameTextFieldView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let signUpButton = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: Constants.fontBold, size: 16)
        $0.layer.cornerRadius = 25
    }
    
    private lazy var agreeToTermsOfServiceButton = UIButton().then {
        $0.contentHorizontalAlignment = .left
        $0.tintColor = .lightGray
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25)
        $0.setImage(UIImage(systemName: "square", withConfiguration: imageConfig), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: imageConfig), for: .selected)
        $0.addTarget(self, action: #selector(agreeToTermsOfServiceButtonTapped), for: .touchUpInside)
        $0.clipsToBounds = true
    }
    
    private let agreeToTermsOfServiceLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontMedium, size: 14)
        $0.text = "서비스 이용약관에 동의합니다."
        $0.textColor = .lightGray
    }
    
    private let agreeToTermsOfServiceStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 3
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
        drawUnderline(emailTextFieldView)
        drawUnderline(passwordTextFieldView)
        drawUnderline(nicknameTextFieldView)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNav()
        configure(emailTextField)
        configure(passwordTextField)
        configure(nicknameTextField)
    }
    
    private func configureNav() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        navigationItem.title = "회원가입"
    }
    
    private func configure(_ textField: UITextField) {
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.tintColor = .black
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.delegate = self
        textField.layer.masksToBounds = true
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func addSubviews() {
        emailTextFieldView.addSubviews(emailTextField, emailPlaceholder)
        passwordTextFieldView.addSubviews(passwordTextField, passwordPlaceholder)
        nicknameTextFieldView.addSubviews(nicknameTextField, nicknamePlaceholder)
        agreeToTermsOfServiceStackView.addArrangedSubviews(agreeToTermsOfServiceButton, agreeToTermsOfServiceLabel)
        view.addSubviews(emailTextFieldView, passwordTextFieldView, nicknameTextFieldView, agreeToTermsOfServiceStackView, signUpButton)
    }
    
    private func setupLayout() {
        emailTextFieldView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(55)
        }
        emailTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
        }
        emailPlaceholder.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(emailTextField)
        }
        passwordTextFieldView.snp.makeConstraints {
            $0.top.equalTo(emailTextFieldView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(55)
        }
        passwordTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
        }
        passwordPlaceholder.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(passwordTextField)
        }
        nicknameTextFieldView.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(55)
        }
        nicknameTextField.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
        }
        nicknamePlaceholder.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(nicknameTextField)
        }
        agreeToTermsOfServiceStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFieldView.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        signUpButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(50)
        }
    }
    
    private func drawUnderline(_ view: UIView) {
        let underline = CALayer()
        let borderWidth: CGFloat = 1
        underline.borderColor = UIColor.lightGray.cgColor
        underline.frame = CGRect(origin: CGPoint(x: 0, y : view.frame.size.height - borderWidth),
                              size: CGSize(width: view.frame.size.width, height: view.frame.size.height))
        underline.borderWidth = borderWidth
        view.layer.addSublayer(underline)
        view.layer.masksToBounds = true
    }
    
    // MARK: - Actions
    
    @objc private func textDidChange(_ textField: UITextField) {
        
    }
    
    @objc func agreeToTermsOfServiceButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected == true {
            sender.tintColor = .black
            agreeToTermsOfServiceLabel.textColor = .black
        }
        if sender.isSelected == false {
            sender.tintColor = .lightGray
            agreeToTermsOfServiceLabel.textColor = .lightGray
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            updateLayout(emailPlaceholder, textField: textField)
        }
        if textField == passwordTextField {
            updateLayout(passwordPlaceholder, textField: textField)
        }
        if textField == nicknameTextField {
            updateLayout(nicknamePlaceholder, textField: textField)
        }
    }
    
    func updateLayout(_ placeholder: UILabel, textField: UITextField) {
        placeholder.snp.updateConstraints {
            $0.centerY.equalTo(textField).offset(-22)
        }
        UIView.animate(withDuration: 0.5) {
            placeholder.font = UIFont(name: Constants.fontRegular, size: 12)
            placeholder.superview?.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField, textField.text == "" {
            resetLayout(emailPlaceholder, textField: textField)
        }
        if textField == passwordTextField, textField.text == "" {
            resetLayout(passwordPlaceholder, textField: textField)
        }
        if textField == nicknameTextField, textField.text == "" {
            resetLayout(nicknamePlaceholder, textField: textField)
        }
    }
    
    func resetLayout(_ placeholder: UILabel, textField: UITextField) {
        placeholder.snp.updateConstraints {
            $0.centerY.equalTo(textField)
        }
        UIView.animate(withDuration: 0.5) {
            placeholder.font = UIFont(name: Constants.fontRegular, size: 16)
            placeholder.superview?.layoutIfNeeded()
        }
    }
}
