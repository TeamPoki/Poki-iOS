//
//  NoticeListViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/19/23.
//

import UIKit
import SnapKit
import Then

final class NoticeListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let noticeTableView = UITableView().then {
        $0.estimatedRowHeight = 110
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorColor = Constants.d9GrayColor
        $0.register(NoticeListTableViewCell.self, forCellReuseIdentifier: "NoticeListTableViewCell")
    }
    
    private var noticeItems: [Notice] = NoticeData.noticeItems
    
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
        noticeTableView.dataSource = self
        noticeTableView.delegate = self
        
        view.addSubview(noticeTableView)
        noticeTableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension NoticeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListTableViewCell", for: indexPath) as! NoticeListTableViewCell
        let noticeItem = noticeItems[indexPath.row]
        cell.configure(title: noticeItem.title, date: noticeItem.date)
        cell.selectionStyle = .none
        return cell
    }
}
