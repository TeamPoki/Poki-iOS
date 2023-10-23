//
//  Extensions.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import Then

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

// MARK: - UILabel

extension UILabel {
    func setLineSpacing(spacing: CGFloat) {
        guard let text = text else { return }

        let attributeString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributeString.addAttribute(.paragraphStyle,
                                        value: style,
                                        range: NSRange(location: 0, length: attributeString.length))
        attributedText = attributeString
    }
}

extension UITextField {
    func addUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth),
                              size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


// MARK: - UINavgationController

extension UINavigationController {
    // UINavigationBarAppearance 공통 적용을 위해 구현
    func configureAppearance() {
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .clear
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
            $0.shadowColor = nil
        }
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
    
    // 포즈 추천 페이지, 랜덤 포즈 페이지에서 사용하는 UINavigationBarAppearance
    func configureLineAppearance() {
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }
}
