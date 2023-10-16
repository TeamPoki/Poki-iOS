//
//  AddPhotoViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import SnapKit
import Then

class AddPhotoViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
    }
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "추가하기"
        
        let appearance = UINavigationBarAppearance().then {
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
            $0.shadowColor = nil
        }
        
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseButton))
        navigationItem.leftBarButtonItem = closeButton
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // MARK: - Actions
    
    @objc private func handleCloseButton() {
        let alert = UIAlertController(title: nil, message: "페이지 나가기", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "종료", style: .destructive, handler: { _ in
            if let navigationController = self.navigationController, let mainPageVC = navigationController.viewControllers.first(where: { $0 is MainPageViewController }) {
                navigationController.popToViewController(mainPageVC, animated: true)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
