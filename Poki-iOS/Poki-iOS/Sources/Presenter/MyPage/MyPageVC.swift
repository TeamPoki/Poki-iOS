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
    
    private let myPageTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.separatorColor = Constants.d9GrayColor
        $0.register(MyPageMenuCell.self, forCellReuseIdentifier: "CellIdentifier")
        $0.register(MyPageMenuCell.self, forCellReuseIdentifier: "AppVersionCellIdentifier")
        $0.isScrollEnabled = false
    }
    
    private lazy var addButton = UIButton().then {
        $0.setImage(UIImage(systemName: "photo")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private lazy var bookMarkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(bookMarkButtonTapped), for: .touchUpInside)
    }
    
    private lazy var modifyProfileButton = UIButton().then {
        $0.setImage(UIImage(named: "user-edit"), for: .normal)
        $0.backgroundColor = .white
        $0.addTarget(self, action: #selector(modifyProfileButtonTapped), for: .touchUpInside)
    }
    
    private var userImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.systemGray5.cgColor
        $0.layer.cornerRadius = 120 / 2
        $0.clipsToBounds = true
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "포키"
        $0.textColor = .black
        $0.font = UIFont(name: Constants.fontBold, size: 20)
    }
    
    private let emailLabel = UILabel().then {
        $0.text = "pokopoki@gmail.com"
        $0.textColor = .lightGray
        $0.font = UIFont(name: Constants.fontLight, size: 14)
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
    
    private let subStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 40
        $0.alignment = .center
        $0.distribution = .equalSpacing
    }
    
    private lazy var addButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.addArrangedSubview(addButton)
        $0.addArrangedSubview(UILabel().then {
            $0.text = "네컷 추가하기"
            $0.font = UIFont(name: Constants.fontMedium, size: 14)
        })
    }
    
    private lazy var bookMarkButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.addArrangedSubview(bookMarkButton)
        $0.addArrangedSubview(UILabel().then {
            $0.text = "찜 한 포즈"
            $0.font = UIFont(name: Constants.fontMedium, size: 14)
        })
    }
    
    private lazy var modifyProfileButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.addArrangedSubview(modifyProfileButton)
        $0.addArrangedSubview(UILabel().then {
            $0.text = "프로필 설정"
            $0.font = UIFont(name: Constants.fontMedium, size: 14)
        })
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
        UserDataManager.loadUserData()
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
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func configureUI() {
        myPageTableView.delegate = self
        myPageTableView.dataSource = self
        
        view.addSubviews(myPageTableView, stackView, contentView)
        contentView.addSubview(subStackView)
        subStackView.addArrangedSubviews(addButtonStackView, bookMarkButtonStackView, modifyProfileButtonStackView)
        
        myPageTableView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(100)
        }
        
        subStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        
        userImage.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(120)
        }
    }
    
    private func profileDataBinding() {
        self.nameLabel.text = UserDataManager.userData.userName
        emailLabel.text = authManager.currentUserEmail
        
        //이미지 변경
        if UIImage(data: UserDataManager.userData.userImage) == nil {
            self.userImage.image = UIImage()
        } else {
            self.userImage.image = UIImage(data: UserDataManager.userData.userImage)
        }
    }
    
    private func retrieveAppVersion() -> String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String,
              let build = dictionary["CFBundleVersion"] as? String else {
            return nil
        }
        return "\(version).\(build)"
    }
    
    // MARK: - Actions
    
    @objc private func addButtonTapped() {
        
    }
    
    @objc private func bookMarkButtonTapped() {
        let bookMarkViewController = LikedPoseVC()
        navigationController?.pushViewController(bookMarkViewController, animated: true)
    }
    
    @objc private func modifyProfileButtonTapped() {
        let modifyProfileViewController = ProfileEditVC()
        navigationController?.pushViewController(modifyProfileViewController, animated: true)
    }

    
}

// MARK: - Extension

extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! MyPageMenuCell
        switch indexPath.row {
        case 0:
            cell.cellTextLabel.text = "APP 설정"
            cell.cellTextLabel.font = UIFont(name: Constants.fontSemiBold, size: 14)
            cell.cellButton.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.cellButton.tintColor = .black
            cell.cellButton.isEnabled = false
            cell.selectionStyle = .none
        case 1:
            cell.cellTextLabel.text = "문의하기"
            cell.cellTextLabel.font = UIFont(name: Constants.fontSemiBold, size: 14)
            cell.cellButton.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.cellButton.tintColor = .black
            cell.cellButton.isEnabled = false
            cell.selectionStyle = .none
        case 2:
            cell.cellTextLabel.text = "로그아웃"
            cell.cellTextLabel.font = UIFont(name: Constants.fontSemiBold, size: 14)
            cell.cellButton.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.cellButton.tintColor = .black
            cell.cellButton.isEnabled = false
            cell.selectionStyle = .none
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
            UserDefaults.standard.set(false, forKey: "LoginStatus")
        case 3:
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
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
