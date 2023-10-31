//  ProfileEditViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/20/23.
//

import UIKit
import Then
import SnapKit

final class ProfileEditVC: UIViewController {
    
    // MARK: - Properties
    
    private var userImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 75
        $0.clipsToBounds = true
    }
    
    private var nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont(name: Constants.fontBold, size: 16)
        $0.textColor = .black
        $0.textAlignment = .left
    }
    
    private lazy var nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력하세요"
        $0.font = UIFont(name: Constants.fontRegular, size: 14)
        $0.borderStyle = .roundedRect
        $0.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    private var hintLabel = UILabel().then {
        $0.text = "닉네임을 입력해주세요!"
        $0.font = UIFont(name: Constants.fontMedium, size: 14)
        $0.textColor = .systemRed
        $0.isHidden = false
    }
    
    private var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private lazy var selectImageButton = UIButton().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .white
        $0.tintColor = .lightGray
        $0.clipsToBounds = true
        $0.setImage(UIImage(systemName: "camera"), for: .normal)
        
        $0.layer.shadowColor = UIColor.lightGray.cgColor
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowOffset = CGSize(width: 2, height: 4)
        $0.layer.shadowRadius = 2
        $0.layer.masksToBounds = false
        
        $0.addTarget(self, action: #selector(selectImageButtonTapped), for: .touchUpInside)
    }

    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        configureUI()
    }
    
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "프로필 수정"
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func configureUI() {
        view.addSubviews(userImageView, selectImageButton, stackView)
        stackView.addArrangedSubviews(nicknameLabel, nicknameTextField, hintLabel)
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalTo(view)
            $0.width.height.equalTo(150)
        }
        
        selectImageButton.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.leading).offset(245)
            $0.top.equalTo(view.snp.top).offset(230)
            $0.width.height.equalTo(30)
        }
        
        nicknameTextField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(50)
            $0.leading.equalTo(view).offset(20)
            $0.trailing.equalTo(view).offset(-20)
        }
    }
    
    // MARK: - Actions
    
    @objc private func selectImageButtonTapped() {
        print("카메라 버튼 눌림")
    }
    
    @objc private func doneButtonTapped() {
        
    }
    
    @objc private func textFieldEditingChanged() {
        if let text = nicknameTextField.text, text.isEmpty {
            hintLabel.isHidden = false
        } else {
            hintLabel.isHidden = true
        }
    }
}
