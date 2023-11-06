//
//  LikedPoseImageDetailViewController.swift
//  Poki-iOS
//
//  Created by 요시킴 on 2023/10/26.
//

import UIKit
import Then

final class LikedPoseImageDetailVC: UIViewController {
    
    // MARK: - Properties
    
    lazy var poseImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.frame = self.view.bounds
        view.addSubview($0)
    }
    
    var isSelected = true
    
    lazy var bookmarkButton = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(customBarButtonTapped))
 
    var url: String? {
        didSet {
            imageSetup()
        }
    }
    
    let storageManager = StorageManager.shared
    let firestoreManager = FirestoreManager.shared
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.appBlackColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNav()
        bookmarkButton = UIBarButtonItem(image: isSelected ? UIImage(systemName: "star.fill") : UIImage(systemName: "star"), style: .plain, target: self, action: #selector(customBarButtonTapped))
        navigationItem.rightBarButtonItem = bookmarkButton
    }

    // MARK: - Helpers
    
    private func configureNav() {
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseButton))
        navigationItem.leftBarButtonItem = closeButton
        navigationController?.configureBlackAppearance()
    }
    
    private func imageSetup() {
        guard let url = url else { return }
        storageManager.downloadImage(urlString: url) { [weak self] image in
            self?.poseImageView.image = image
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleCloseButton() {
        firestoreManager.fetchRecommendPoseDocumentFromFirestore { error in
            if let error = error {
                print("ERROR: 찜한 포즈 상세보기 페이지에서 추천 포즈 이미지를 불러오지 못했습니다 ㅠㅠ \(error)")
                return
            }
            self.dismiss(animated: true)
        }
    }
    
    @objc private func customBarButtonTapped() {
        if isSelected {
            firestoreManager.poseImageUpdate(imageUrl: url!, isSelected: false)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star")
            self.isSelected = false
        } else {
            firestoreManager.poseImageUpdate(imageUrl: url!, isSelected: true)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "star.fill")
            self.isSelected = true
        }
    }
}
