//
//  Extensions.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import CoreImage
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
        for view in views { addArrangedSubview(view) }
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

    func setupToast() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 16)
        self.textAlignment = .center
        self.alpha = 1.0
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.numberOfLines = 2
    }
}

// MARK: - UIImage

extension UIImage {
    func dominantColor() -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }

        let inputImage = CIImage(cgImage: cgImage)
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

// MARK: - UIViewController

extension UIViewController {
    func showToast(message: String, frame: CGRect, completion: (() -> Void)?) {
        let toast = UILabel(frame: frame)
        toast.setupToast()
        toast.text = message
        view.addSubview(toast)
        UIView.animate(withDuration: 1.2, delay: 0.3) {
            toast.alpha = 0
        } completion: { _ in
            completion?()
            toast.removeFromSuperview()
        }
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
