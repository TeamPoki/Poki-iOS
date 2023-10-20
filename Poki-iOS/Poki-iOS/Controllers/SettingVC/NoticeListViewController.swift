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

    private let noticeItems: [NoticeItem] = [
        NoticeItem(title: "중요한 공지사항", date: "2023.10.20"),
        NoticeItem(title: "새로운 업데이트 안내", date: "2023.10.18"),
        NoticeItem(title: "이벤트 참여 방법", date: "2023.10.15"),
        NoticeItem(title: "긴 공지사항 입니다. 긴 공지사항입니다. 긴 공지사항 입니다. 긴 공지사항입니다. 긴 공지사항 입니다. 긴 공지사항입니다. 긴 공지사항 입니다. 긴 공지사항입니다.", date: "2023.10.20")
    ]
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoticeListTableViewCell.self, forCellReuseIdentifier: "NoticeListTableViewCell")
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
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

// MARK: - CustomCell

class NoticeListTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.font, size: 14)
        label.numberOfLines = 2 // 최대 2줄 표시
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Constants.font, size: 10)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView).offset(16)
            make.right.equalTo(contentView).offset(-16)
            make.bottom.equalTo(contentView).offset(-16)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

struct NoticeItem {
    var title: String
    var date: String
}


