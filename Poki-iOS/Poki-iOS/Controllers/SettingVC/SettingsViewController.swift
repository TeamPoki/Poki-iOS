//
//  SettingsViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import SnapKit
import Then

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    private var tableView: UITableView!
    private var data: [String] = ["공지사항", "개인정보 처리방침", "서비스 이용약관", "탈퇴하기"]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        setupTableView()
        
    }
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "설정"
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
            tableView.separatorStyle = .singleLine
        }
    }
    
    
    
    
    // MARK: - Actions
    
    
    
    
    
}
// MARK: - UITableViewDataSource 및 UITableViewDelegate 구현
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        image.tintColor = .black
        cell.contentView.addSubview(image)
        image.snp.makeConstraints { make in
            make.trailing.equalTo(cell.contentView).offset(-16)
            make.centerY.equalTo(cell.contentView)
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "font", size: 12)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedData = data[indexPath.row]
        
        //print("선택한 항목: \(selectedData)")
        if selectedData == "공지사항" {
//            let noticeListViewController = NoticeListViewController()
//            navigationController?.pushViewController(noticeListViewController, animated: true)
            print("공지사항 눌림")
        } else if selectedData == "탈퇴하기" {
            let accountDeletionViewController = AccountDeletionViewController()
            navigationController?.pushViewController(accountDeletionViewController, animated: true)
        }
    }
}
