//
//  SettingsViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import SnapKit
import Then
import SafariServices

final class SettingsVC: UIViewController {
    
    // MARK: - Properties
    
    private var settingTableView = UITableView().then {
        $0.separatorColor = Constants.separatorGrayColor
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
    }
    
    private var data: [String] = ["공지사항", "개인정보 처리방침", "서비스 이용약관", "탈퇴하기"]
    private var dataFont = UIFont(name: Constants.fontMedium, size: 14)
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "설정"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.configureBasicAppearance()
    }
    
    private func setupTableView() {
        settingTableView.delegate = self
        settingTableView.dataSource = self
        view.addSubview(settingTableView)
        
        settingTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func openSFSafariPrivacyPolicy() {
        if let privacyPolicyURL = URL(string: "https://poki-project.notion.site/bf9b73c51fc34d32991d88966283c0ce?pvs=4") {
            let safariViewController = SFSafariViewController(url: privacyPolicyURL)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    func openSFSafariServiceRule() {
        if let serviceRuleURL = URL(string: "https://poki-project.notion.site/edab5f4b388545cd91a63665fc3b64dc?pvs=4") {
            let safariViewController = SFSafariViewController(url: serviceRuleURL)
            present(safariViewController, animated: true, completion: nil)
        }
    }
}
// MARK: - UITableViewDataSource, UITableViewDelegate

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath)
        
        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        image.tintColor = .black
        cell.contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.trailing.equalTo(cell.contentView).offset(-16)
            make.centerY.equalTo(cell.contentView)
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = dataFont
        cell.textLabel?.text = data[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = data[indexPath.row]
        if selectedData == "공지사항" {
            let noticeListViewController = NoticeListVC()
            navigationController?.pushViewController(noticeListViewController, animated: true)
        } else if selectedData == "탈퇴하기" {
            let accountDeletionViewController = AccountDeletionVC()
            navigationController?.pushViewController(accountDeletionViewController, animated: true)
        } else if selectedData == "개인정보 처리방침" {
            openSFSafariPrivacyPolicy()
        } else if selectedData == "서비스 이용약관" {
            openSFSafariServiceRule()
        }
    }
}
