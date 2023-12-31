//
//  LoginViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/18.
//

import UIKit
import SnapKit
import Then

final class LoginVC: UIViewController {
    
    // MARK: - Properties
    
    private var email: String?
    private var password: String?
    private var authManager = AuthManager.shared

    // MARK: - Components
    
    private let headerView = UIView().then {
        $0.backgroundColor = Constants.appBlackColor
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
        $0.placeholder = "이메일을 입력해주세요."
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Constants.separatorGrayColor.cgColor
        $0.layer.cornerRadius = 8
        $0.clearButtonMode = .whileEditing
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
        $0.placeholder = "비밀번호를 입력해주세요."
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Constants.separatorGrayColor.cgColor
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
        $0.backgroundColor = Constants.appBlackColor
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.lightGray.withAlphaComponent(0.5), for: .highlighted)
        $0.titleLabel?.font = UIFont(name: Constants.fontBold, size: 16)
        $0.layer.cornerRadius = 25
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.lightGray.withAlphaComponent(0.5), for: .highlighted)
        $0.titleLabel?.font = UIFont(name: Constants.fontBold, size: 16)
        $0.layer.cornerRadius = 25
        $0.layer.borderWidth = 1
        $0.layer.borderColor = Constants.appBlackColor.cgColor
        $0.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    private lazy var findPasswordButton = UIButton().then {
        $0.setTitle("비밀번호 찾기", for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = UIFont(name: Constants.fontRegular, size: 14)
        $0.addTarget(self, action: #selector(findPasswordButtonTapped), for: .touchUpInside)
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
    
    deinit {
        print("로그인 페이지 사라집니다.!")
    }
    
    // MARK: - Configure
    
    private func configureUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        configure(emailTextField)
        configure(passwordTextField)
        setupEmail()
    }
    
    private func configure(_ textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.delegate = self
        textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        textField.tintColor = .black
    }
    
    // MARK: - Helpers
    
    private func addSubviews() {
        headerView.addSubviews(logoLabel, commentLabel)
        emailStackView.addArrangedSubviews(emailTitleLabel, emailTextField)
        passwordStackView.addArrangedSubviews(passwordTitleLabel, passwordTextField)
        emailSaveStackView.addArrangedSubviews(emailSaveButton, emailSaveTextLabel)
        bodyStackView.addArrangedSubviews(emailStackView, passwordStackView)
        bottomStackView.addArrangedSubviews(loginButton, signUpButton, findPasswordButton)
        passwordStackView.addSubview(eyeButton)
        view.addSubviews(headerView, bodyStackView, emailSaveStackView, bottomStackView)
    }
    
    private func setupLayout() {
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
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
        
        emailSaveStackView.snp.makeConstraints {
            $0.top.equalTo(passwordStackView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        bodyStackView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        eyeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(5)
            $0.centerY.equalTo(passwordTextField)
        }
        
        loginButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        emailSaveTextLabel.snp.contentHuggingHorizontalPriority = 249
        emailSaveTextLabel.snp.contentCompressionResistanceHorizontalPriority = 249
    }
    
    private func setupEmail() {
        guard let email = UserDataManager.savedEmail else { return }
        self.email = email
        self.emailTextField.text = email
        self.emailSaveButton.isSelected = true
        self.emailSaveButton.tintColor = Constants.appBlackColor
        self.emailSaveTextLabel.textColor = Constants.appBlackColor
    }
    
    private func saveUserEmail(_ email: String) {
        if self.emailSaveButton.isSelected == true {
            UserDataManager.saveUserEmail(email)
        }
        if self.emailSaveButton.isSelected == false {
            UserDataManager.deleteUserEmail()
        }
    }
    
    // MARK: - Helpers
    
    private func showAlertToFindPassword(completion: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: "비밀번호 찾기", message: "가입한 이메일을 입력해주세요.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .destructive)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            let email = alert.textFields?[0].text
            completion(email)
        }
        alert.addTextField {
            $0.placeholder = "이메일을 입력해주세요."
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func textDidChange(_ sender: UITextField) {
        if sender == emailTextField {
            self.email = sender.text
        }
        if sender == passwordTextField {
            self.password = sender.text
        }
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
            sender.tintColor = Constants.appBlackColor
            emailSaveTextLabel.textColor = Constants.appBlackColor
        }
        if sender.isSelected == false {
            sender.tintColor = .lightGray
            emailSaveTextLabel.textColor = .lightGray
        }
    }
    
    @objc private func loginButtonTapped(_ sender: UIButton) {
        guard let email = self.email,
              let password = self.password else
        {
            self.showToast(criterionView: self.loginButton, message: "이메일과 비밀번호를 확인해주세요.", completion: nil)
            return
        }
        self.showLoadingIndicator()
        authManager.loginUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.showToast(criterionView: self.loginButton, message: "이메일과 비밀번호를 확인해주세요.") {
                    print("로그인 에러 : \(error.localizedDescription)")
                }
                self.hideLoadingIndicator()
                return
            }
            self.hideLoadingIndicator()
            self.saveUserEmail(email)
            let rootVC = CustomTabBarController()
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            sceneDelegate.changeRootViewController(rootVC)
            UserDefaults.standard.set(true, forKey: "LoginStatus")
        }
    }
    
    @objc private func signUpButtonTapped(_ sender: UIButton) {
        let signUpVC = SignUpVC()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func findPasswordButtonTapped(_ sender: UIButton) {
        showAlertToFindPassword { email in
            self.authManager.sendPasswordReset(with: email)
        }
    }
}

// MARK: - UITextFieldDelegate

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return false
    }
}
