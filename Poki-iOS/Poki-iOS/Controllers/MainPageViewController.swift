//
//  MainPageViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import SnapKit
import Then

class MainPageViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
    }
    
    // MARK: - Helpers

    private func configureNav() {
        let logo = UIImage(named: "poki-logo") // 현재 임시로 넣은거라 사이즈도 작아서 추후에 로고 제작이 된다면 바로 적용
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        let logoBarButton = UIBarButtonItem(customView: imageView)
        navigationItem.leftBarButtonItem = logoBarButton
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        
        let galleryAction = UIAction(title: "갤러리에서 추가하기", image: UIImage(systemName: "photo"), handler: { _ in
            print("이미지 피커 구현예정")
            let addPhotoVC = AddPhotoViewController() // 일단 개발을 위해서 페이지로 바로 연결
            addPhotoVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(addPhotoVC, animated: true)
        })
        let cameraAction = UIAction(title: "QR코드로 추가하기", image: UIImage(systemName: "qrcode"), handler: { _ in
            print("카메라 기능 구현예정")
        })

        let menu = UIMenu(title: "", children: [galleryAction, cameraAction])
        
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), primaryAction: nil, menu: menu)
        navigationItem.rightBarButtonItem = plusButton
    }

    

    
    
    
    
    
    // MARK: - Actions
    

}
