//
//  SignUpView.swift
//  Poki-iOS
//
//  Created by playhong on 2023/11/01.
//

import UIKit
import SnapKit
import Then

class SignUpView: UIView {

    // MARK: - Components

    let emailPlaceholder = UILabel().then {
        $0.text = "이메일"
        $0.font = UIFont(name: Constants.fontRegular, size: 16)
        $0.textColor = .lightGray
    }
    
    let emailTextField = UITextField().then {
        $0.keyboardType = .emailAddress
    }
    
    let emailTextFieldView = UIView().then {
        $0.backgroundColor = .clear
    }

    let emailHintLabel = UILabel().then {
        $0.text = "이메일 형식으로 입력해주세요."
        $0.font = UIFont(name: Constants.fontRegular, size: 12)
        $0.textColor = .black
    }
    
    let validEmailCheckLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontRegular, size: 12)
        $0.text = "이메일 형식이 유효하지 않습니다."
        $0.textColor = .red
    }
    
    let emailLabelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 3
    }
    
    let passwordPlaceholder = UILabel().then {
        $0.text = "비밀번호"
        $0.font = UIFont(name: Constants.fontRegular, size: 16)
        $0.textColor = .lightGray
    }
    
    lazy var passwordTextField = UITextField().then {
        $0.isSecureTextEntry = true
    }
    
    let passwordTextFieldView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    lazy var eyeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "eye"), for: .normal)
        $0.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        $0.tintColor = .lightGray
    }
    
    let passwordHintLabel = UILabel().then {
        $0.text = "8~20자, 영문, 숫자, 특수문자를 포함해주세요."
        $0.font = UIFont(name: Constants.fontRegular, size: 12)
        $0.textColor = .black
    }
    
    let validPasswordCheckLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontRegular, size: 12)
        $0.text = "비밀번호가 유효하지 않습니다."
        $0.textColor = .red
    }
    
    let passwordLabelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 3
    }
    
    let nicknamePlaceholder = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont(name: Constants.fontRegular, size: 16)
        $0.textColor = .lightGray
    }
    
    let nicknameTextField = UITextField().then {
        $0.keyboardType = .default
    }
    
    let nicknameTextFieldView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    let nicknameHintLabel = UILabel().then {
        $0.text = "2~8자, 영문, 한글만 입력할 수 있습니다."
        $0.font = UIFont(name: Constants.fontRegular, size: 12)
        $0.textColor = .black
    }
    
    let validNicknameCheckLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontRegular, size: 12)
        $0.text = "닉네임이 유효하지 않습니다."
        $0.textColor = .red
    }
    
    let nicknameLabelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 3
    }
    
    lazy var signUpButton = UIButton().then {
        $0.setTitle("가입하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont(name: Constants.fontBold, size: 16)
        $0.layer.cornerRadius = 25
    }
    
    lazy var agreeToTermsOfServiceButton = UIButton().then {
        $0.contentHorizontalAlignment = .left
        $0.tintColor = .lightGray
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25)
        $0.setImage(UIImage(systemName: "square", withConfiguration: imageConfig), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: imageConfig), for: .selected)
        $0.clipsToBounds = true
    }
    
    let agreeToTermsOfServiceLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontMedium, size: 14)
        let text = "서비스 이용약관에 동의합니다."
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        $0.attributedText = attributedString
        $0.textColor = .lightGray
        $0.isUserInteractionEnabled = true
    }

    let agreeToTermsOfServiceStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 3
    }
    
    // MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        drawUnderline(emailTextFieldView)
        drawUnderline(passwordTextFieldView)
        drawUnderline(nicknameTextFieldView)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        configure(emailTextField)
        configure(passwordTextField)
        configure(nicknameTextField)
    }

    private func configure(_ textField: UITextField) {
        textField.backgroundColor = .clear
        textField.textColor = .black
        textField.tintColor = .black
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.layer.masksToBounds = true
    }
    
    private func drawUnderline(_ view: UIView) {
        let underline = UIView()
        underline.backgroundColor = .lightGray
        underline.frame = CGRect(origin: CGPoint(x: 0, y: view.frame.size.height - 8),
                                 size: CGSize(width: view.frame.size.width, height: 0.5))
        view.addSubview(underline)
    }
    
    private func addSubviews() {
        emailTextFieldView.addSubviews(emailTextField, emailPlaceholder)
        passwordTextFieldView.addSubviews(passwordTextField, passwordPlaceholder)
        nicknameTextFieldView.addSubviews(nicknameTextField, nicknamePlaceholder)
        agreeToTermsOfServiceStackView.addArrangedSubviews(agreeToTermsOfServiceButton, agreeToTermsOfServiceLabel)
        passwordTextFieldView.addSubview(eyeButton)
        emailLabelStackView.addArrangedSubviews(emailHintLabel, validEmailCheckLabel)
        passwordLabelStackView.addArrangedSubviews(passwordHintLabel, validPasswordCheckLabel)
        nicknameLabelStackView.addArrangedSubviews(nicknameHintLabel, validNicknameCheckLabel)
        self.addSubviews(emailTextFieldView, emailLabelStackView, passwordTextFieldView, passwordLabelStackView, nicknameTextFieldView, nicknameLabelStackView, agreeToTermsOfServiceStackView, signUpButton)
    }
    
    private func setupLayout() {
        emailTextFieldView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(20)
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
        emailLabelStackView.snp.makeConstraints {
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
        passwordLabelStackView.snp.makeConstraints {
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
        nicknameLabelStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFieldView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(30)
        }
        agreeToTermsOfServiceStackView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabelStackView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        signUpButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.height.equalTo(50)
        }
        agreeToTermsOfServiceLabel.snp.contentHuggingHorizontalPriority = 249
        agreeToTermsOfServiceLabel.snp.contentCompressionResistanceHorizontalPriority = 249
    }
}
