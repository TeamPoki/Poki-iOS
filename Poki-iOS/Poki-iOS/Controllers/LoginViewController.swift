//
//  LoginViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/18.
//

import UIKit
import SnapKit
import Then
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    private var email: String?
    private var password: String?
    private let authManager = AuthManager.shared
    
    // MARK: - Validation
    private var isLoginFormValid: Bool? {
        isValidEmail == true && isValidPassword == true
    }
    private var isValidEmail: Bool? {
        self.email?.isEmpty == false &&
        self.isValid(email: self.email)
    }
    private var isValidPassword: Bool? {
        self.password?.isEmpty == false &&
        self.isValid(password: self.password)
    }
    private var loginButtonColor: UIColor {
        isLoginFormValid == true ? UIColor.black : UIColor.lightGray
    }

    // MARK: - Components
    private let headerView = UIView().then {
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
                    네컷 추억을 보관하는 플랫폼
                    """
        $0.textColor = .white
        $0.setLineSpacing(spacing: 3)
    }
    
    private let emailTitleLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontBold, size: 16)
        $0.text = "이메일"
        $0.textColor = .black
    }
    
    private let emailTextField = UITextField().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
    }
    
    private let emailStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 5
    }
    
    private let passwordTitleLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontBold, size: 16)
        $0.text = "비밀번호"
        $0.textColor = .black
    }
    
    private let passwordTextField = UITextField().then {
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 8
        $0.isSecureTextEntry = true
    }
    
    private lazy var eyeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "eye"), for: .normal)
        $0.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        $0.tintColor = .lightGray
        $0.addTarget(self, action: #selector(eyeButtonTapped), for: .touchUpInside)
    }
    
    private let passwordStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 5
    }
    
    private lazy var emailSaveButton = UIButton().then {
        $0.contentHorizontalAlignment = .left
        $0.tintColor = .lightGray
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25)
        $0.setImage(UIImage(systemName: "square", withConfiguration: imageConfig), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: imageConfig), for: .selected)
        $0.addTarget(self, action: #selector(emailSaveButtonTapped), for: .touchUpInside)
    }
    
    private let emailSaveTextLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontMedium, size: 14)
        $0.text = "이메일 / 아이디 저장"
        $0.textColor = .lightGray
    }
    
    private lazy var emailSaveStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 3
    }
    
    private let bodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 30
    }
    
    private lazy var loginButton = UIButton().then {
        $0.backgroundColor = .lightGray
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: Constants.fontBold, size: 16)
        $0.layer.cornerRadius = 25
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont(name: Constants.fontBold, size: 16)
        $0.layer.cornerRadius = 25
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    private let bottomStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 10
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        addSubviews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Configure
    private func configureUI() {
        configure(emailTextField)
        configure(passwordTextField)
    }
    
    private func configure(_ textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.delegate = self
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    // MARK: - Helpers
    
    private func addSubviews() {
        headerView.addSubviews(logoLabel, commentLabel)
        emailStackView.addArrangedSubviews(emailTitleLabel, emailTextField)
        passwordStackView.addArrangedSubviews(passwordTitleLabel, passwordTextField)
        emailSaveStackView.addArrangedSubviews(emailSaveButton, emailSaveTextLabel)
        bodyStackView.addArrangedSubviews(emailStackView, passwordStackView, emailSaveStackView)
        bottomStackView.addArrangedSubviews(loginButton, signUpButton)
        passwordStackView.addSubview(eyeButton)
        view.addSubviews(headerView, bodyStackView, bottomStackView)
    }
    
    private func setupLayout() {
        headerView.snp.makeConstraints {
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
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        bodyStackView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(60)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
        emailSaveButton.snp.makeConstraints {
            $0.width.equalTo(25)
        }
        eyeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalTo(passwordTextField)
        }
        loginButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        bottomStackView.snp.makeConstraints {
            $0.top.equalTo(emailSaveTextLabel.snp.bottom).offset(110)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Update UI
    private func updateLoginButton() {
        if isLoginFormValid == true {
            loginButton.isEnabled = true
        }
        if isLoginFormValid == false {
            loginButton.isEnabled = false
        }
        loginButton.backgroundColor = self.loginButtonColor
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
    
    // MARK: - Actions
    
    @objc private func textDidChange(_ sender: UITextField) {
        if sender == emailTextField {
            self.email = sender.text
        }
        if sender == passwordTextField {
            self.password = sender.text
        }
        updateLoginButton()
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
    
    @objc private func emailSaveButtonTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected == true {
            sender.tintColor = .black
            emailSaveTextLabel.textColor = .black
        }
        if sender.isSelected == false {
            sender.tintColor = .lightGray
            emailSaveTextLabel.textColor = .lightGray
        }
    }
    
    @objc private func loginButtonTapped(_ sender: UIButton) {
        guard let email = self.email, let password = self.password else { return }
        authManager.loginUser(withEmail: email, password: password) { user, error in
            if let error = error {
                print("로그인 에러 : \(error.localizedDescription)")
                return
            }
            let rootVC = CustomTabBarController()
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            sceneDelegate.changeRootViewController(rootVC)
            UserDefaults.standard.set(true, forKey: "LoginStatus")
        }
    }
    
    @objc private func signUpButtonTapped(_ sender: UIButton) {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
}
