//
//  SettingsViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import SnapKit
import Then

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        
    }
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "설정"
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    
    
    

    // MARK: - Actions
    
    
    
    

}
