//
//  AccountDeletionViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/16/23.
//

import UIKit
import Then
import SnapKit

final class AccountDeletionVC: UIViewController {

    // MARK: - Properties

    let authManager = AuthManager.shared
    let firestoreManager = FirestoreManager.shared

    private let infoTexts = [
        "탈퇴 후에는 저장한 인생네컷을 수정, 삭제하실 수 없습니다. 탈퇴 하시기 전에 확인해주세요!",
        "탈퇴 하시게 되면 등록, 저장했던 모든 정보는 삭제되어 복구할 수 없습니다.",
        "이상의 내용에 동의하여 탈퇴를 원하실 경우, 아래의 동의 체크박스 버튼을 클릭하고 탈퇴하기 버튼을 눌러주세요."
    ]

    // MARK: - Size

    private var toastSize: CGRect {
        let width = view.frame.size.width - 120
        let frame = CGRect(x: 60, y: 710, width: width, height: Constants.toastHeight)
        return frame
    }

    private let titleLabel = UILabel().then {
        $0.text = "정말 떠나시는 건가요?"
        $0.font = UIFont(name: Constants.fontSemiBold, size: 24)
    }

    private lazy var infoViews: [UIStackView] = infoTexts.map { text in
        let icon = UIImageView().then {
            $0.image = UIImage(systemName: "exclamationmark.triangle")
            $0.tintColor = Constants.separatorGrayColor
        }

        let label = UILabel().then {
            $0.text = text
            $0.numberOfLines = 0
            $0.lineBreakMode = .byWordWrapping
            $0.font = UIFont(name: Constants.fontRegular, size: 14)
        }

        let stackView = UIStackView(arrangedSubviews: [icon, label]).then {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .leading
            $0.distribution = .fill
        }
        label.snp.makeConstraints {
            $0.width.lessThanOrEqualTo(UIScreen.main.bounds.width - (icon.frame.width + 8 + 20 * 2) - 20)
        }
        return stackView
    }

    private lazy var checkBoxButton = UIButton().then {
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        $0.tintColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)
        $0.addTarget(self, action: #selector(handleCheckBox), for: .touchUpInside)
    }

    private let checkBoxLabel = UILabel().then {
        $0.text = "회원 탈퇴 유의사항을 확인하였으며 동의합니다."
        $0.font = UIFont(name: Constants.fontRegular, size: 14)
        $0.textColor = .lightGray
    }

    private let reasonLabel = UILabel().then {
        $0.text = "POKI를 떠나는 이유를 알려주세요."
        $0.font = UIFont(name: Constants.fontSemiBold, size: 20)
    }

    private let reasonTextView = UITextView().then {
        $0.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.00)
        $0.layer.cornerRadius = 10
        $0.text = "떠나는 이유를 50자 이내로 입력해주세요."
        $0.font = UIFont(name: Constants.fontRegular, size: 14)
        $0.textColor = .lightGray
        $0.tintColor = .black
    }

    private lazy var withdrawButton = UIButton().then {
        $0.setTitle("탈퇴 하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: Constants.fontBold, size: 16)
        $0.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)
        $0.layer.cornerRadius = 25
        $0.addTarget(self, action: #selector(withdrawButtonTapped), for: .touchUpInside)
    }

    private lazy var checkBoxStackView = UIStackView(arrangedSubviews: [checkBoxButton, checkBoxLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }

    private let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }

    private let contentView = UIView()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        configureNav()
        configureUI()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        self.extendedLayoutIncludesOpaqueBars = true
    }

    // MARK: - Helpers

    private func configureNav() {
        navigationItem.title = "회원탈퇴"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.configureBasicAppearance()
    }

    private func configureUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(titleLabel, checkBoxStackView, reasonLabel, reasonTextView, withdrawButton)
        infoViews.forEach(contentView.addSubview)

        reasonTextView.delegate = self
        reasonTextView.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 0)

        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(view)
        }

        titleLabel.snp.makeConstraints {
            $0.top.left.equalTo(contentView).offset(30)
            $0.right.equalTo(contentView).offset(-20)
        }

        var previousView: UIView = titleLabel

        for infoView in infoViews {
            infoView.snp.makeConstraints {
                $0.top.equalTo(previousView.snp.bottom).offset(30)
                $0.left.equalTo(contentView).offset(20)
            }
            previousView = infoView
        }

        checkBoxStackView.snp.makeConstraints {
            $0.top.equalTo(previousView.snp.bottom).offset(40)
            $0.left.equalTo(contentView).offset(20)
        }

        reasonLabel.snp.makeConstraints {
            $0.top.equalTo(checkBoxStackView.snp.bottom).offset(30)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
        }

        reasonTextView.snp.makeConstraints {
            $0.top.equalTo(reasonLabel.snp.bottom).offset(20)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(200)
        }

        withdrawButton.snp.makeConstraints {
            $0.top.equalTo(reasonTextView.snp.bottom).offset(60)
            $0.left.equalTo(contentView).offset(20)
            $0.right.bottom.equalTo(contentView).offset(-20)
            $0.centerX.equalTo(contentView)
            $0.height.equalTo(50)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Actions

    @objc private func handleCheckBox(button: UIButton) {
        button.isSelected = !button.isSelected

        if button.isSelected {
            withdrawButton.backgroundColor = Constants.appBlackColor
            checkBoxButton.tintColor = Constants.appBlackColor
            checkBoxLabel.textColor = .black
        } else {
            withdrawButton.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)
            checkBoxButton.tintColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.00)
            checkBoxLabel.textColor = .lightGray
        }
    }

    @objc func withdrawButtonTapped() {
        firestoreManager.deleteAllPhotoData()
        firestoreManager.deleteAllPoseData()
        firestoreManager.deleteAllUserData()
        firestoreManager.deleteUserDocument()
        self.showLoadingIndicator()
        let reasonText = reasonTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if reasonText != "" && reasonText != "떠나는 이유를 50자 이내로 입력해주세요." {
            FirestoreManager.shared.saveDeletionReason(reason: reasonText) { error in
                if let error = error {
                    print("회원탈퇴 사유를 서버에 전송하지 못했습니다.:", error.localizedDescription)
                    self.hideLoadingIndicator()
                    return
                }
                print("회원탈퇴 사유를 서버에 전송했습니다.")
            }
        }
        self.hideLoadingIndicator()
        self.showToast(message: "탈퇴가 완료되었습니다.", frame: self.toastSize) {
            self.authManager.userDelete()
            let rootVC = UINavigationController(rootViewController: LoginVC())
            guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            sceneDelegate.changeRootViewController(rootVC)
            UserDefaults.standard.set(false, forKey: "LoginStatus")
            UserDataManager.deleteUserEmail()
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let keyboardHeight = keyboardSize.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        var aRect = self.view.frame
        aRect.size.height -= keyboardHeight

        let activeTextFieldRect: CGRect = reasonTextView.convert(reasonTextView.bounds, to: scrollView)
        let activeTextFieldBottom = activeTextFieldRect.origin.y + activeTextFieldRect.size.height

        if !aRect.contains(CGPoint(x: 0, y: activeTextFieldBottom)) {
            scrollView.scrollRectToVisible(activeTextFieldRect, animated: true)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - UITextViewDelegate

extension AccountDeletionVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "떠나는 이유를 50자 이내로 입력해주세요."
            textView.textColor = UIColor.lightGray
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 50
    }
}
