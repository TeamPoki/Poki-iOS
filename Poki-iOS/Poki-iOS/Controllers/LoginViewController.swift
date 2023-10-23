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
    private let topBackgroundView = UIView().then {
        $0.backgroundColor = .black
    }
    
    private let logoLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontHeavy, size: 46)
        $0.text = "POKI"
        $0.textColor = .white
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
        topBackgroundView.addSubviews(logoLabel)
        view.addSubviews(topBackgroundView)
    }
    
    private func setupLayout() {
        topBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        logoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(70)
            $0.leading.equalToSuperview().inset(20)
        }
    }
    
    // MARK: - Actions
    
    @objc private func signUpButtonTapped(_ sender: UIButton) {
        print("회원가입 버튼 눌렀어유~")
    }
}
