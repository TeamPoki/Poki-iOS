//
//  DetailPhotoViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/16.
//

import UIKit
import SnapKit
import Then

final class PhotoDetailViewController: UIViewController {
    
    var photoData: Photo? {
        didSet {
            setupPhotoData()
        }
    }
    var indexPath: IndexPath?
    
    // MARK: - Components
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontBold, size: 32)
        $0.text = "GOOD EATS"
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let dateLabel = UILabel().then {
        $0.font = UIFont(name: Constants.fontBold, size: 16)
        $0.text = "2023. 10. 16"
        $0.textColor = .white
        $0.textAlignment = .center
    }
    
    private let mainImageView = UIImageView()
    
    private lazy var mainStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let backgroundImageView = UIImageView()
    
    private lazy var backgroundBlurEffectView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .light)
    }
    
    private lazy var menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                  style: .done,
                                                  target: self,
                                                  action: nil).then {
        $0.tintColor = .white
        $0.menu = self.detailMenu
    }
    
    private lazy var detailMenu = UIMenu(children: setupDetailMenuAction())

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        addSubViews()
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Helper
    private func configureNav() {
        navigationItem.rightBarButtonItem = self.menuButton
        navigationController?.configureAppearance()
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        tabBarController?.tabBar.isHidden = true
    }
    
    private func addSubViews() {
        mainStackView.addArrangedSubviews(titleLabel, dateLabel, mainImageView)
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubviews(backgroundBlurEffectView, mainStackView)
    }
    
    private func setupLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        backgroundBlurEffectView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        mainStackView.setCustomSpacing(3, after: self.titleLabel)
        mainStackView.setCustomSpacing(20, after: self.dateLabel)
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func setupPhotoData() {
        self.mainImageView.image = photoData?.image
        self.backgroundImageView.image = photoData?.image
        self.titleLabel.text = photoData?.memo
        self.dateLabel.text = photoData?.date
    }
    
    private func setupDetailMenuAction() -> [UIAction] {
        let update = UIAction(title: "수정하기", image: UIImage(systemName: "highlighter")) { _ in
            self.editMenuTapped() }
        let share = UIAction(title: "공유하기", image: UIImage(systemName: "arrowshape.turn.up.right")) { _ in
            self.shareMenuTapped() }
        let delete = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            print("삭제하기 클릭~") }
        let actions = [update, share, delete]
        return actions
    }
    
    // MARK: - Actions
    
    private func editMenuTapped() {
        let moveVC = AddPhotoViewController()
        moveVC.hidesBottomBarWhenPushed = true
        moveVC.viewSeperated = .edit
        moveVC.photoData = self.photoData
        moveVC.indexPath = self.indexPath
        navigationController?.pushViewController(moveVC, animated: true)
    }
    
    private func shareMenuTapped() {
        let title = "네컷 공유하기"
        let activityVC = UIActivityViewController(activityItems: [title], applicationActivities: nil)
        present(activityVC, animated: true)
    }
}
