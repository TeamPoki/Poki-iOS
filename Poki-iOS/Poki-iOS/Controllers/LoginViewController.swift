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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupLayout()
    }
    
    // MARK: - Helpers
    
    private func addSubviews() {
        view.addSubviews(topBackgroundView)
    }
    
    private func setupLayout() {
        topBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(250)
        }
    }
    
    // MARK: - Actions
    
    @objc private func signUpButtonTapped(_ sender: UIButton) {
        print("회원가입 버튼 눌렀어유~")
    }
}
