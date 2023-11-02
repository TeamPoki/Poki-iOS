//
//  NoticeListViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/19/23.
//

import UIKit
import SnapKit
import Then

final class NoticeListVC: UIViewController {
    
    // MARK: - Properties
    
    private let noticeTableView = UITableView().then {
        $0.estimatedRowHeight = 110
        $0.rowHeight = UITableView.automaticDimension
        $0.separatorColor = Constants.separatorGrayColor
        $0.register(NoticeListCell.self, forCellReuseIdentifier: "NoticeListTableViewCell")
    }
    
    private var noticeItems: [NoticeList] = []
    private var expandedIndexPath: IndexPath?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav()
        FirestoreManager.shared.loadNotices { [weak self] notices in
            DispatchQueue.main.async {
                self?.noticeItems = notices
                self?.noticeTableView.reloadData()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "공지사항"
        navigationController?.configureBasicAppearance()
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

extension NoticeListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeListTableViewCell", for: indexPath) as! NoticeListCell
        let noticeItem = noticeItems[indexPath.row]
        let isExpanded = expandedIndexPath == indexPath
        cell.configure(notice: noticeItem, isExpanded: isExpanded)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentExpandedIndexPath = expandedIndexPath {
            if currentExpandedIndexPath == indexPath {
                expandedIndexPath = nil
            } else {
                expandedIndexPath = indexPath
            }
        } else {
            expandedIndexPath = indexPath
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
