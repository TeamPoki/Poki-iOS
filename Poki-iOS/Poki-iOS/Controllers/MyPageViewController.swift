//
//  MyPageViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import SnapKit
import Then

class MyPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let addButton: UIButton = {
        let button = UIButton()
        let image1 = UIImage(systemName: "photo")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image1, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let bookMarkButton: UIButton = {
        let button = UIButton()
        let image1 = UIImage(systemName: "star")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image1, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(bookMarkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let modifyProfileButton: UIButton = {
        let button = UIButton()
        let image1 = UIImage(named: "user-edit")
        button.setImage(image1, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(modifyProfileButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let userImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image")
        image.contentMode = .scaleAspectFit
        image.layer.borderWidth = 1.0
        image.layer.borderColor = UIColor.systemGray5.cgColor
        image.clipsToBounds = true
        
        image.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(120)
        }
        
        image.layer.cornerRadius = 120 / 2
        
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "포키"
        label.textColor = .black
        label.font = UIFont(name: Constants.fontBold, size: 20)
        
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "pokopoki@gmail.com"
        label.textColor = .lightGray
        label.font = UIFont(name: Constants.fontLight, size: 14)
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userImage, nameLabel, emailLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        
        return stackView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.systemGray5.cgColor
        view.layer.cornerRadius = 10.0
        view.clipsToBounds = true
        return view
    }()
    
    private let subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var addButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.addArrangedSubview(addButton)
        
        let label = UILabel()
        label.text = "네컷 추가하기"
        label.font = UIFont(name: Constants.fontSemiBold, size: 14)
        stackView.addArrangedSubview(label)
        
        return stackView
    }()
    
    private lazy var bookMarkButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.addArrangedSubview(bookMarkButton)
        
        let label = UILabel()
        label.text = "찜 한 포즈"
        label.font = UIFont(name: Constants.fontSemiBold, size: 14)
        stackView.addArrangedSubview(label)
        
        return stackView
    }()
    
    private lazy var modifyProfileButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        stackView.addArrangedSubview(modifyProfileButton)
        
        let label = UILabel()
        label.text = "프로필 수정"
        label.font = UIFont(name: Constants.fontSemiBold, size: 14)
        stackView.addArrangedSubview(label)
        
        return stackView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        //tableView.separatorStyle = .singleLine
        
        return tableView
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(100)
        }
        
        contentView.addSubview(subStackView)
        subStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        subStackView.addArrangedSubview(addButtonStackView)
        subStackView.addArrangedSubview(bookMarkButtonStackView)
        subStackView.addArrangedSubview(modifyProfileButtonStackView)
        subStackView.distribution = .equalSpacing
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "AppVersionCellIdentifier")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
    }
    
    // MARK: - Helpers
    
    private func configureNav() {
        let titleLabel = UILabel().then {
            $0.text = "My Page"
            $0.textColor = .black
            $0.font = UIFont(name: Constants.fontExtraBold, size: 28)
        }
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem
        
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
    
    // MARK: - Actions
    // 네컷 추가하기, 찜 한 포즈, 프로필 수정에 사용
    @objc private func addButtonTapped() {
        
    }
    
    @objc private func bookMarkButtonTapped() {
        
    }
    
    @objc private func modifyProfileButtonTapped() {
        
    }
    
}

// MARK: - Extension
extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! CustomTableViewCell
        switch indexPath.row {
        case 0:
            cell.cellTextLabel.text = "APP 설정"
            cell.cellTextLabel.font = UIFont(name: Constants.fontSemiBold, size: 16)
            cell.cellButton.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.cellButton.tintColor = .black
            cell.cellButton.isEnabled = false
        case 1:
            cell.cellTextLabel.text = "문의하기"
            cell.cellTextLabel.font = UIFont(name: Constants.fontSemiBold, size: 16)
            cell.cellButton.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.cellButton.tintColor = .black
            cell.cellButton.isEnabled = false
        case 2:
            cell.cellTextLabel.text = "로그아웃"
            cell.cellTextLabel.font = UIFont(name: Constants.fontSemiBold, size: 16)
            cell.cellButton.setImage(UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate), for: .normal)
            cell.cellButton.tintColor = .black
            cell.cellButton.isEnabled = false
        case 3:
            cell.appVersionLabel.text = "앱 버전"
            cell.appVersionLabel.font = UIFont(name: Constants.fontSemiBold, size: 16)
            cell.cellButton.setTitle("1.0.0", for: .normal)
            
            let buttonFont = UIFont(name: Constants.fontSemiBold, size: 12)
            
            cell.cellButton.titleLabel?.font = buttonFont
            cell.cellButton.isEnabled = false
            cell.separatorInset = UIEdgeInsets(top: 0, left: cell.bounds.size.width, bottom: 0, right: 0)
        default:
            break
        }
        return cell
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
}

class CustomTableViewCell: UITableViewCell {
    
    let cellButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var cellTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: Constants.fontLight, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var appVersionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: Constants.fontLight, size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellButton)
        contentView.addSubview(cellTextLabel)
        cellButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        cellButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        cellTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        cellTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        contentView.addSubview(appVersionLabel)
        appVersionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        appVersionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
