//
//  LikedPoseImageDetailViewController.swift
//  Poki-iOS
//
//  Created by 요시킴 on 2023/10/26.
//

import UIKit

class LikedPoseImageDetailViewController: UIViewController {
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
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .black
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func imageSetup() {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }

}
