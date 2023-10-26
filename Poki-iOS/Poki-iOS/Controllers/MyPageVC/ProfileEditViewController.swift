//
//  ProfileEditViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/20/23.
//

import UIKit
import Then

final class ProfileEditViewController: UIViewController {
    
    // MARK: - Properties

    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNav()
        view.backgroundColor = .white
    }
    
    
    // MARK: - Helpers

    private func configureNav() {
        navigationItem.title = "프로필 설정"
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    
    
    // MARK: - Actions


    
    
}
