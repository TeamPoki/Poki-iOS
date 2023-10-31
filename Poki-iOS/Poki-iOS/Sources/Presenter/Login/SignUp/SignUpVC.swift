//
//  SignUpViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/23.
//

import UIKit
import FirebaseAuth


final class SignUpVC: UIViewController {
    
    // MARK: - Properties
    private var email: String?
    private var password: String?
    private var nickname: String?
    private var isAgree: Bool?
    
    private let authManager = AuthManager.shared
    
    // MARK: - Validation
    private var isSignUpFormValid: Bool? {
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
        isSignUpFormValid == true ? UIColor.black : UIColor.lightGray
    }
    
    // MARK: - Size
    private var toastSize: CGRect {
        let width = view.frame.size.width - 60
        let height = view.frame.size.height / 18
        let frame = CGRect(x: 30, y: 680, width: width, height: height)
        return frame
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
    private let emailHintLabel = UILabel().then {
        $0.text = "이메일 형식으로 입력해주세요."
        $0.font = UIFont(name: Constants.fontRegular, size: 12)
        $0.textColor = .black
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
    
    private lazy var eyeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "eye"), for: .normal)
        $0.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        $0.tintColor = .lightGray
        $0.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
    }
    
    private let passwordHintLabel = UILabel().then {
        $0.text = "8~20자, 영문, 숫자, 특수문자를 포함해주세요."
        $0.font = UIFont(name: Constants.fontRegular, size: 12)
        $0.textColor = .black
    }
    
    private let nicknamePlaceholder = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont(name: Constants.fontRegular, size: 16)
        $0.textColor = .lightGray
    }
    
    private let nicknameTextField = UITextField().then {
        $0.keyboardType = .default
    }
    
    private let nicknameTextFieldView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let nicknameHintLabel = UILabel().then {
        $0.text = "2~8자, 영문, 한글만 입력할 수 있습니다."
        $0.font = UIFont(name: Constants.fontRegular, size: 12)
        $0.textColor = .black
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: Constants.fontBold, size: 16)
        $0.layer.cornerRadius = 25
        $0.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
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
        updateSignUpButton()
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
        navigationItem.title = "회원가입"
        navigationController?.configureBasicAppearance()
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
        view.addSubviews(emailTextFieldView, emailHintLabel, passwordTextFieldView, passwordHintLabel, nicknameTextFieldView, nicknameHintLabel, agreeToTermsOfServiceStackView, signUpButton)
    }
    
    private func setupLayout() {
        emailTextFieldView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        emailTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        emailPlaceholder.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(emailTextField)
        }
        emailHintLabel.snp.makeConstraints {
            $0.top.equalTo(emailTextFieldView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        passwordTextFieldView.snp.makeConstraints {
            $0.top.equalTo(emailTextFieldView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
        passwordHintLabel.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        eyeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalTo(passwordTextField)
        }
        passwordPlaceholder.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(passwordTextField)
        }
        nicknameTextFieldView.snp.makeConstraints {
            $0.top.equalTo(passwordTextFieldView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        nicknameTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        nicknamePlaceholder.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.centerY.equalTo(nicknameTextField)
        }
        nicknameHintLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFieldView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        agreeToTermsOfServiceStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFieldView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        signUpButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            $0.height.equalTo(50)
        }
    }
    
    private func drawUnderline(_ view: UIView) {
        let underline = UIView()
        underline.backgroundColor = .lightGray
        underline.frame = CGRect(origin: CGPoint(x: 0, y : view.frame.size.height - 8),
                                 size: CGSize(width: view.frame.size.width, height: 0.5))
        view.addSubview(underline)
    }
    
    private func verifyingDuplicationAlert(text: String) {
        let alert = UIAlertController(title: "중복된 이메일", message: "\(text)는 이미 존재하는 이메일입니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "종료", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showAlert(title: String?, message: String?, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in completion?() }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Update UI

    private func updateSignUpButton() {
        if isSignUpFormValid == true {
            signUpButton.isEnabled = true
        }
        if isSignUpFormValid == false {
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
        let pred = NSPredicate(format: "SELF MATCHES %@", Constants.nicknameRegex)
        return pred.evaluate(with: nickname)
    }
    
    // MARK: - Actions
    
    @objc private func textDidChange(_ sender: UITextField) {
        if sender == emailTextField {
            self.email = sender.text
        }
        if sender == passwordTextField {
            self.password = sender.text
        }
        if sender == nicknameTextField {
            self.nickname = sender.text
        }
        self.updateSignUpButton()
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
            self.isAgree = true
        }
        if sender.isSelected == false {
            sender.tintColor = .lightGray
            agreeToTermsOfServiceLabel.textColor = .lightGray
            self.isAgree = false
        }
        self.updateSignUpButton()
    }
    
    @objc private func signUpButtonTapped() {
        guard let email = self.email, let password = self.password else { return }
        authManager.signUpUser(email: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007:
                    self.verifyingDuplicationAlert(text: email)
                default:
                    print("계정 생성 오류 : \(error.localizedDescription)")
                }
                return
            }
            self.showToast(message: "회원가입이 완료되었습니다.", frame: self.toastSize) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpVC: UITextFieldDelegate {
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
            $0.centerY.equalTo(textField).offset(-20)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            nicknameTextField.becomeFirstResponder()
        }
        if textField == nicknameTextField {
            nicknameTextField.resignFirstResponder()
        }
        return false
    }
}
