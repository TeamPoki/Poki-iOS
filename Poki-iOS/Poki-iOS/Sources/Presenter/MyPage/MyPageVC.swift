//
//  MyPageViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import MessageUI
import SnapKit
import Then

final class MyPageVC: UIViewController {
    
    // MARK: - Properties
    let authManager = AuthManager.shared
    let firestoreManager = FirestoreManager.shared
    let storageManager = StorageManager.shared
    
    private let myPageTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorColor = Constants.separatorGrayColor
        $0.register(MyPageMenuCell.self, forCellReuseIdentifier: "CellIdentifier")
        $0.register(MyPageMenuCell.self, forCellReuseIdentifier: "AppVersionCellIdentifier")
        $0.isScrollEnabled = true
    }
    
    private lazy var addButton = UIButton().then {
        $0.setImage(UIImage(systemName: "photo")?.withTintColor(Constants.appBlackColor, renderingMode: .alwaysOriginal), for: .normal)
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
    }
    
    private lazy var bookMarkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star")?.withTintColor(Constants.appBlackColor, renderingMode: .alwaysOriginal), for: .normal)
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(bookMarkButtonTapped), for: .touchUpInside)
    }
    
    private lazy var modifyProfileButton = UIButton().then {
        $0.setImage(UIImage(named: "user-edit"), for: .normal)
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(modifyProfileButtonTapped), for: .touchUpInside)
    }
    
    var userImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 150 / 2
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    private let nameLabel = UILabel().then {
        $0.textColor = .black
        $0.font = UIFont(name: Constants.fontBold, size: 20)
    }
    
    private let emailLabel = UILabel().then {
        $0.textColor = .lightGray
        $0.font = UIFont(name: Constants.fontLight, size: 14)
    }
    
    private let addButtonLabel = UILabel().then {
        $0.text = "네컷 추가"
        $0.font = UIFont(name: Constants.fontMedium, size: 14)
        $0.textAlignment = .center
    }
    
    private let bookMarkButtonLabel = UILabel().then {
        $0.text = "찜 한 포즈"
        $0.font = UIFont(name: Constants.fontMedium, size: 14)
        $0.textAlignment = .center
    }
    
    private let modifyProfileButtonLabel = UILabel().then {
        $0.text = "프로필 설정"
        $0.font = UIFont(name: Constants.fontMedium, size: 14)
        $0.textAlignment = .center
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .center
        $0.addArrangedSubviews(userImage,nameLabel, emailLabel)
    }
    
    private let contentView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 10.0
        $0.clipsToBounds = true
    }
    
    private lazy var addButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .fill
        $0.distribution = .fillEqually
        
        $0.addArrangedSubview(addButton)
        $0.addArrangedSubview(addButtonLabel)
    }
    
    private lazy var bookMarkButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.addArrangedSubview(bookMarkButton)
        $0.addArrangedSubview(bookMarkButtonLabel)
    }
    
    private lazy var modifyProfileButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 6
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.addArrangedSubview(modifyProfileButton)
        $0.addArrangedSubview(modifyProfileButtonLabel)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        profileDataBinding()
    }
    
    // MARK: - Helpers
    
    private func configureNav() {
        let titleLabel = UILabel().then {
            $0.text = "My Page"
            $0.textColor = .black
            $0.font = UIFont(name: Constants.fontExtraBold, size: 32)
        }
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.configureBasicAppearance()
    }
    
    private func configureUI() {
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
        
        view.addSubviews(stackView, contentView, myPageTableView)
        contentView.addSubviews(addButtonStackView, bookMarkButtonStackView, modifyProfileButtonStackView)
        
        userImage.snp.makeConstraints {
            $0.width.equalTo(150)
            $0.height.equalTo(150)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        addButtonLabel.snp.makeConstraints {
            $0.centerX.equalTo(addButton)
        }
        
        modifyProfileButtonLabel.snp.makeConstraints {
            $0.centerX.equalTo(modifyProfileButton)
        }

        bookMarkButtonLabel.snp.makeConstraints {
            $0.centerX.equalTo(bookMarkButton)
        }
        
        addButtonStackView.snp.makeConstraints {
            $0.centerX.equalTo(bookMarkButtonStackView).offset(-110)
            $0.centerY.equalToSuperview()

        }
        
        bookMarkButtonStackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()

        }
        
        modifyProfileButtonStackView.snp.makeConstraints {
            $0.centerX.equalTo(bookMarkButtonStackView).offset(110)
            $0.centerY.equalToSuperview()
            
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(100)
        }
        
        myPageTableView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        
        let addPhotoTapped = UITapGestureRecognizer(target: self, action: #selector(addPhotoButtonTapped))
        addButtonStackView.addGestureRecognizer(addPhotoTapped)
        
        let bookMarkTapped = UITapGestureRecognizer(target: self, action: #selector(bookMarkButtonTapped))
        bookMarkButtonStackView.addGestureRecognizer(bookMarkTapped)
        
        let modifyProfileTapped = UITapGestureRecognizer(target: self, action: #selector(modifyProfileButtonTapped))
        modifyProfileButtonStackView.addGestureRecognizer(modifyProfileTapped)
        
    }
    
    func profileDataBinding() {
        guard let nickname = self.firestoreManager.userData?.nickname else { return }
        if nickname == "" {
            self.nameLabel.text = ""
        } else {
            self.nameLabel.text = nickname
            emailLabel.text = authManager.currentUserEmail
        }
        guard let imageURL = self.firestoreManager.userData?.imageURL,
              imageURL.isEmpty == false
        else
        {
            self.userImage.image = UIImage(named: "default-profile")
            return
        }
        let url = URL(string: imageURL)
        self.userImage.kf.setImage(with: url)
    }
    
    private func retrieveAppVersion() -> String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let build = dictionary["CFBundleVersion"] as? String else {
            return nil
        }
        return "\(version).\(build)"
    }
    
    func updateConfigureCell(_ title: String, cell: MyPageMenuCell) {
        cell.cellTextLabel.text = title
        cell.cellTextLabel.font = UIFont(name: Constants.fontSemiBold, size: 14)
        cell.cellButton.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        cell.cellButton.tintColor = .black
        cell.cellButton.isEnabled = false
        cell.selectionStyle = .none
    }
    
    // MARK: - Actions
    @objc private func addPhotoButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: "갤러리에 추가하기", style: .destructive) { (action) in
            let mainPageVCInstance = MainPageVC()
            mainPageVCInstance.requestPhotoLibraryAccess()
        }
        
        let qrCodeAction = UIAlertAction(title: "QR코드로 추가하기", style: .destructive) { (action) in
            let qrCodeVC = QRCodeVC()
            let navController = UINavigationController(rootViewController: qrCodeVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        let systemBlueColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        let systemRedColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1.0)
        
        galleryAction.setValue(systemBlueColor, forKey: "titleTextColor")
        qrCodeAction.setValue(systemBlueColor, forKey: "titleTextColor")
        cancelAction.setValue(systemRedColor, forKey: "titleTextColor")
        
        alertController.addAction(galleryAction)
        alertController.addAction(qrCodeAction)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func bookMarkButtonTapped() {
        let likedPoseVC = LikedPoseVC()
        likedPoseVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(likedPoseVC, animated: true)
    }
    
    @objc private func modifyProfileButtonTapped() {
        let profileEditVC = ProfileEditVC()
        profileEditVC.hidesBottomBarWhenPushed = true
        profileEditVC.nickname = self.nameLabel.text
        profileEditVC.profileImage = self.userImage.image
        navigationController?.pushViewController(profileEditVC, animated: true)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! MyPageMenuCell
        switch indexPath.row {
        case 0:
            updateConfigureCell("APP 설정", cell: cell)
        case 1:
            updateConfigureCell("문의하기", cell: cell)
        case 2:
            updateConfigureCell("로그아웃", cell: cell)
        case 3:
            cell.appVersionLabel.text = "앱 버전"
            cell.appVersionLabel.font = UIFont(name: Constants.fontSemiBold, size: 14)
            guard let appVersion = retrieveAppVersion() else {
                cell.cellButton.setTitle("버전 정보 없음", for: .normal)
                break
            }
            cell.cellButton.setTitle(appVersion, for: .normal)
            
            let buttonFont = UIFont(name: Constants.fontSemiBold, size: 12)
            
            cell.cellButton.titleLabel?.font = buttonFont
            cell.cellButton.isEnabled = false
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let settingsVC = SettingsVC()
            settingsVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(settingsVC, animated: true)
        case 1:
            if MFMailComposeViewController.canSendMail() {
                let mailComposeVC = MFMailComposeViewController()
                mailComposeVC.mailComposeDelegate = self
                mailComposeVC.setToRecipients(["poki230709@gmail.com"])
                mailComposeVC.setSubject("문의하기")
                self.present(mailComposeVC, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "문의 메일 보내기 실패", message: "문의를 보내기 위해선 \n 기기의 메일 설정이 필요합니다.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        case 2:
            let loginVC = UINavigationController(rootViewController: LoginVC())
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            sceneDelegate.changeRootViewController(loginVC)
            authManager.logoutUser()
            UserDefaults.standard.set(false, forKey: "LoginStatus")
        case 3:
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let separatorView = UIView()
            separatorView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1)
            return separatorView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 3 {
            return false
        }
        return true
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension MyPageVC: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
