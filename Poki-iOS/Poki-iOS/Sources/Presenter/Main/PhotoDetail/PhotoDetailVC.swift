//
//  DetailPhotoViewController.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/16.
//

import UIKit
import SnapKit
import Then

final class PhotoDetailVC: UIViewController {
    
    var photoData: Photo? {
        didSet {
            setupPhotoData()
        }
    }

    var indexPath: IndexPath?
    var updatePhotoCompletionHandler: (() -> Void)?
    
    private let firestoreManager = FirestoreManager.shared
    private let storageManager = StorageManager.shared
    
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
        $0.menu = self.detailMenu
    }
    
    private lazy var detailMenu = UIMenu(children: setupDetailMenuAction())
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav()
        navigationController?.navigationBar.tintColor = .white
    }
    
    // MARK: - Helper

    private func configureNav() {
        navigationItem.rightBarButtonItem = self.menuButton
        navigationController?.configureClearAppearance()
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    private func addSubViews() {
        mainStackView.addArrangedSubviews(titleLabel, dateLabel, mainImageView)
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubviews(backgroundBlurEffectView, mainStackView)
    }
    
    private func setupLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        backgroundBlurEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        mainStackView.setCustomSpacing(3, after: self.titleLabel)
        mainStackView.setCustomSpacing(20, after: self.dateLabel)
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    private func setupPhotoData() {
        guard let photoData = photoData else { return }
        guard let photoURL = URL(string: photoData.image) else { return }
        
        self.mainImageView.kf.setImage(with: photoURL)
        self.backgroundImageView.kf.setImage(with: photoURL) { [weak self] result in
            switch result {
            case .success(let value):
                if let dominantColor = value.image.dominantColor() {
                    self?.setGradientBackground(dominantColor: dominantColor)
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        self.titleLabel.text = photoData.memo
        self.dateLabel.text = photoData.date
    }

    private func setGradientBackground(dominantColor: UIColor) {
        let adjustedColor = dominantColor.withAlphaComponent(1.5)
        
        if let existingGradient = backgroundImageView.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
            existingGradient.removeFromSuperlayer()
        }
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 200)
        gradient.colors = [adjustedColor.cgColor, dominantColor.withAlphaComponent(0).cgColor]
        gradient.locations = [0, 1]
        backgroundImageView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupDetailMenuAction() -> [UIAction] {
        let update = UIAction(title: "수정하기", image: UIImage(systemName: "highlighter")) { _ in
            self.editMenuTapped()
        }
        let share = UIAction(title: "공유하기", image: UIImage(systemName: "arrowshape.turn.up.right")) { _ in
            self.shareMenuTapped()
        }
        let delete = UIAction(title: "삭제하기", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            self.deleteMenuTapped()
        }
        let actions = [update, share, delete]
        return actions
    }
    
    private func showAlertMessage() {
        let alert = UIAlertController(title: "사진 삭제하기", message: "선택한 사진을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            /// 이거는 왜 들어가야하는건지 궁금합니다.
            guard let self = self else { return }
            guard let indexPath = indexPath else { return }
            let photoData = firestoreManager.photoList[indexPath.row]
            firestoreManager.deletePhotoDocument(id: photoData.id)
            self.storageManager.deleteImage(imageURL: photoData.image) { _ in
                print("이미지 삭제 완료")
            }
            self.storageManager.deleteImage(imageURL: photoData.tag.tagImage) { _ in
                print("이미지 삭제 완료")
            }
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    private func editMenuTapped() {
        let moveVC = AddPhotoVC()
        moveVC.hidesBottomBarWhenPushed = true
        moveVC.viewSeperated = .edit
        moveVC.photoData = self.photoData
        moveVC.indexPath = self.indexPath
        moveVC.updateCompletionHandler = self.updatePhotoCompletionHandler
        navigationController?.pushViewController(moveVC, animated: true)
    }
    
    private func shareMenuTapped() {
        guard let imageUrl = self.photoData?.image else { return }
        storageManager.downloadImage(urlString: imageUrl) { image in
            let activityVC = UIActivityViewController(activityItems: [image ?? UIImage()], applicationActivities: nil)
            self.present(activityVC, animated: true)
        }
    }
    
    private func deleteMenuTapped() {
        showAlertMessage()
    }
}
