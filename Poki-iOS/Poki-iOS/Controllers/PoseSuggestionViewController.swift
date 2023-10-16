//
//  PoseSuggestionViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import SnapKit
import Then

class PoseSuggestionViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        
    }
    
    // MARK: - Helpers

    private func configureNav() {
        navigationItem.title = "포즈 추천"
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
            $0.shadowColor = .lightGray
        }
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Actions

}
