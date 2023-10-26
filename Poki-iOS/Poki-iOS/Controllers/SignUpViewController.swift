//
//  SignUpViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/23.
//

import UIKit
import FirebaseAuth


class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    private var email: String?
    private var password: String?
    private var nickname: String?
    private var isAgree: Bool?
    
    // MARK: - Validation
    private var isLoginFormValid: Bool? {
        self.isValidEmail == true &&
        self.isValidPassword == true &&
        self.isValidNickname == true &&
        self.isAgree == true
    }
    private var isValidEmail: Bool? {
        self.email?.isEmpty == false &&
        self.isValid(email: self.email)
    }
    private var isValidPassword: Bool? {
        self.password?.isEmpty == false &&
        self.isValid(password: self.password)
    }
    private var isValidNickname: Bool? {
        self.nickname?.isEmpty == false &&
        self.isValid(nickname: self.nickname)
    }
    private var signUpButtonColor: UIColor {
        isLoginFormValid == true ? UIColor.black : UIColor.lightGray
    }

    
    // MARK: - Components
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
    
    private lazy var eyeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "eye"), for: .normal)
        $0.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        $0.tintColor = .lightGray
        $0.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
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
        signUpButtonTapped()
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
        passwordTextFieldView.addSubview(eyeButton)
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
        eyeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalTo(passwordTextField)
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
            $0.top.equalTo(nicknameTextFieldView.snp.bottom).offset(30)
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
    
    private func signUpButtonTapped() {
        self.signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
    }
    
    private func verifyingDuplicationAlert(text: String) {
        let alert = UIAlertController(title: "중복", message: "\(text)는 이미 존재하는 ID 입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "종료", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Update UI

    private func updateSignUpButton() {
        if isLoginFormValid == true {
            signUpButton.isEnabled = true
        }
        if isLoginFormValid == false {
            signUpButton.isEnabled = false
        }
        signUpButton.backgroundColor = self.signUpButtonColor
    }
    
    // MARK: - Validation
    func isValid(email: String?) -> Bool {
        guard let email = email else { return false }
        let pred = NSPredicate(format: "SELF MATCHES %@", Constants.emailRegex)
        return pred.evaluate(with: email)
    }
    
    func isValid(password: String?) -> Bool {
        guard let password = password else { return false }
        let pred = NSPredicate(format: "SELF MATCHES %@", Constants.passwordRegex)
        return pred.evaluate(with: password)
    }
    
    func isValid(nickname: String?) -> Bool {
        guard let nickname = nickname else { return false }
        let pred = NSPredicate(format: "SELF MATCHES %@", Constants.passwordRegex)
        return pred.evaluate(with: nickname)
    }
    
    // MARK: - Actions
    
    @objc private func textDidChange(_ textField: UITextField) {
        
    }
    
    @objc private func eyeButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected == true {
            passwordTextField.isSecureTextEntry = false
        }
        if sender.isSelected == false {
            passwordTextField.isSecureTextEntry = true
        }
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

    @objc private func signUpButtonAction() {
        let email = self.emailTextField.text ?? ""
        let password = self.passwordTextField.text ?? ""
        
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007: //이미 가입한 계정일 때
                    self.verifyingDuplicationAlert(text: email)
                default:
                    print("아이디 생성 오류 : \(error.localizedDescription)")
                }
            } else {
                self.dismiss(animated: true)
//                self.navigationController?.popViewController(animated: true)
            }
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
