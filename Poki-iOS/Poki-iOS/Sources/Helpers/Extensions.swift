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
        self.backgroundColor = .black.withAlphaComponent(0.8)
        self.textColor = .white
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = .center
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
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
    func showToast(message: String, completion: (() -> Void)?) {
        let toast = UILabel()
        toast.setupToast()
        toast.text = message
        view.addSubview(toast)
        toast.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(60)
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
        }
        UIView.animate(withDuration: 1.2, delay: 0.3) {
            toast.alpha = 0
        } completion: { _ in
            completion?()
            toast.removeFromSuperview()
        }
    }

    func showLoadingIndicator() {
        DispatchQueue.main.async {
            let indicatorView: UIActivityIndicatorView
            if let existedView = self.view.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
                indicatorView = existedView
            } else {
                indicatorView = UIActivityIndicatorView(style: .large)
                indicatorView.frame = self.view.frame
                indicatorView.color = .black
                self.view.addSubview(indicatorView)
            }
            indicatorView.startAnimating()
        }
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            self.view.subviews.filter { $0 is UIActivityIndicatorView }
                .forEach { $0.removeFromSuperview() }
        }
    }
}

// MARK: - UINavgationController

extension UINavigationController {
    func configureBasicAppearance() {
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.titleTextAttributes = [.foregroundColor: UIColor.black]
            $0.shadowColor = nil
        }
        self.navigationBar.tintColor = .black
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }

    func configureClearAppearance() {
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

    func configureBlackAppearance() {
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = Constants.appBlackColor
            $0.shadowColor = nil
        }
        self.navigationBar.tintColor = .white
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
    }

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

extension UIApplication {
    static var firstKeyWindowForConnectedScenes: UIWindow? {
        UIApplication.shared
            .connectedScenes.lazy

            .compactMap { $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil }

            .first(where: { $0.keyWindow != nil })?

            .keyWindow
    }
}
