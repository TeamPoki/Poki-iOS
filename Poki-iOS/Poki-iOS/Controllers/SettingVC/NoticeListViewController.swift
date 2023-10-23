//
//  NoticeListViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/19/23.
//

import UIKit
import SnapKit
import Then

class NoticeListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private var noticeItems: [Notice] = NoticeData.noticeItems
    private var cellTitleFont = UIFont(name: Constants.fontMedium, size: 14)
    private var cellDateFont = UIFont(name: Constants.fontMedium, size: 10)
    
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
        navigationItem.title = "공지사항"
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [
                .foregroundColor: UIColor.black,
                .font: UIFont(name: Constants.fontMedium, size: 18)
            ]
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoticeListTableViewCell.self, forCellReuseIdentifier: "NoticeListTableViewCell")
        
        view.addSubview(tableView)
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListTableViewCell") as? NoticeListTableViewCell {
            cell.titleLabel.font = cellTitleFont
            cell.dateLabel.font = cellDateFont
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    // MARK: - Actions

}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension NoticeListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListTableViewCell", for: indexPath) as! NoticeListTableViewCell
        let noticeItem = noticeItems[indexPath.row]
        cell.titleLabel.text = noticeItem.title
        cell.dateLabel.text = noticeItem.date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

