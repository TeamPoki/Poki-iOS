//  ProfileEditViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/20/23.
//

import UIKit
import SnapKit
import Then
import PhotosUI

final class ProfileEditVC: UIViewController {
    
    // MARK: - Properties
    
    let firestoreManager = FirestoreManager.shared
    let storageManager = StorageManager.shared
    
    private var userImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 75
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureUserName()
        configureUserImage()
    }
    
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "프로필 수정"
        navigationController?.configureBasicAppearance()
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
    
    private func configureUserName() {
        guard let nickname = self.firestoreManager.userData?.nickname else { return }
        nicknameTextField.text = nickname
        if nicknameTextField.text == "" {
            hintLabel.isHidden = false
        } else {
            hintLabel.isHidden = true
        }
    }
    
    private func configureUserImage() {
        guard let nickname = self.firestoreManager.userData?.nickname else { return }
        let imageData = nickname
        if imageData == "" {
            userImageView.image = UIImage()
        } else {
            storageManager.downloadImage(urlString: imageData) { image in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    userImageView.image = image }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Actions
    
    @objc private func selectImageButtonTapped() {
        let action = UIAction(title: "갤러리에서 선택하기", image: UIImage(systemName: "photo.on.rectangle")) { _ in
            self.requestPhotoLibraryAccess()
        }
        
        
        let menu = UIMenu(title: "", children: [action])
        selectImageButton.menu = menu
        selectImageButton.showsMenuAsPrimaryAction = true
    }
    
    @objc private func doneButtonTapped() {
        storageManager.userImageUpload(image: userImageView.image ?? UIImage()) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success((let photoURL)):
                guard let nickname = self.nicknameTextField.text else { return }
                firestoreManager.updateUserDocument(user: User(nickname: nickname, imageURL: photoURL.absoluteString))
                    firestoreManager.fetchUserDocumentFromFirestore()
                case .failure(let error):
                    print("Error uploading images: \(error.localizedDescription)")
                    // 오류 처리
            }
        }
    }
    
    @objc private func textFieldEditingChanged() {
        if let text = nicknameTextField.text, text.isEmpty {
            hintLabel.isHidden = false
        } else {
            hintLabel.isHidden = true
        }
    }
}

extension ProfileEditVC: PHPickerViewControllerDelegate {
    // 사진이 선택이 된 후에 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    let dataImage = image as? UIImage
                    self.userImageView.image  = dataImage
                }
            }
        } else {
            print("이미지 로드 실패")
        }
    }
    
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    self.setupImagePicker()
                }
            case .denied, .restricted:
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "사진 접근 거부됨", message: "사진에 접근하려면 설정에서 권한을 허용해야 합니다.", preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "설정 열기", style: .default) { _ in
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    alertController.addAction(settingsAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            case .notDetermined: break
                // 사용자가 아직 결정을 내리지 않은 경우
                // 다음에 권한 요청을 수행할 수 있습니다.

            case .limited:
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.fetchLimit = 30 // 최신 30장만 가져옴
                @unknown default:
                break
            }
        }
    }
    
    private func setupImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .videos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
}
