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
    
    var image: UIImage?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageSetup()
        view.backgroundColor = .black
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
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseButton))
        navigationItem.leftBarButtonItem = closeButton
        navigationController?.configureBlackAppearance()
    }
    
    private func imageSetup() {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
    
    // MARK: - Actions
    
    @objc private func handleCloseButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
