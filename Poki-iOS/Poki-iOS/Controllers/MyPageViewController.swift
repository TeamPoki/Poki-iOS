//
//  MyPageViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import SnapKit
import Then

class MyPageViewController: UIViewController {

    // MARK: - Properties
    
    
    
    
    

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        
    }
    
    // MARK: - Helpers

    private func configureNav() {
        let titleLabel = UILabel().then {
            $0.text = "My Page"
            $0.textColor = .black
            $0.font = UIFont(name: Constants.fontExtraBold, size: 28)
        }
        let titleItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.leftBarButtonItem = titleItem
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Actions

}
