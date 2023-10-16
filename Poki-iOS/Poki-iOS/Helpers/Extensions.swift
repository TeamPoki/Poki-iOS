//
//  Extensions.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit

// MARK: - UIView

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
    
    static func createSeparatorLine() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        return separator
    }
}

// MARK: - UIStackView

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {addArrangedSubview(view)}
    }
}

// MARK: - 
