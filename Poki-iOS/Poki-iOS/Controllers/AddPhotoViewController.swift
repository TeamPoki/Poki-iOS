//
//  AddPhotoViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import SnapKit
import Then
import PhotosUI

protocol TagSelectionDelegate: AnyObject {
    func didSelectTag(_ tag: TagModel)
}

final class AddPhotoViewController: UIViewController {
    
    // MARK: - Properties
    
     let addPhotoView = AddPhotoView()


    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        setup()
        mainImageSetupTapGestures()
        tagButtonTapped()
        datePickerTapped()
        tagImageSetupTapGestures()
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
    
    private func setup() {
        self.view.addSubview(addPhotoView)
        
        addPhotoView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).inset(20)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func tagButtonTapped() {
        addPhotoView.tagAddButton.addTarget(self, action: #selector(tagButtonAction), for: .touchUpInside)
    }
    
    private func datePickerTapped() {
        addPhotoView.datePicker.addTarget(self, action: #selector(dateButtonAction), for: .valueChanged)
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
    
    private func tagImageSetupTapGestures() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tagImageTapped))
        addPhotoView.tagImageView.addGestureRecognizer(tapGesture)
        addPhotoView.tagImageView.isUserInteractionEnabled = true
       }
    
    private func mainImageSetupTapGestures() {
           let tapGesture = UITapGestureRecognizer(target: self, action: #selector(touchUpImageView))
        addPhotoView.photoImageView.addGestureRecognizer(tapGesture)
        addPhotoView.photoImageView.isUserInteractionEnabled = true
       }
    
    @objc private func touchUpImageView() {
            print("이미지뷰 터치")
        self.setupImagePicker()
        }
    
    private func setupImagePicker() {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .any(of: [.images, .videos])
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    
    @objc private func tagButtonAction() {
        let tagViewController = TagViewController()
        tagViewController.modalPresentationStyle = .custom
        tagViewController.transitioningDelegate = self
        tagViewController.delegate = self
        present(tagViewController, animated: true, completion: nil)
    }
    
    @objc private func dateButtonAction() {
        let formmater = DateFormatter()
        formmater.dateFormat = "yyyy년 MM월 dd일"
        formmater.locale = Locale(identifier: "ko_KR")
        self.addPhotoView.dateTextField.text = formmater.string(from: self.addPhotoView.datePicker.date)
        self.view.endEditing(true)
    }
    
    
    @objc private func tagImageTapped() {
        tagButtonAction()
    }
    
}


extension AddPhotoViewController: PHPickerViewControllerDelegate {
    // 사진이 선택이 된 후에 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.addPhotoView.photoImageView.image = image as? UIImage
                }
            }
        } else {
            print("이미지 로드 실패")
        }
    }
}

extension AddPhotoViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        // UISheetPresentationController를 사용하여 커스텀 프레

let sheetPresentationController = UISheetPresentationController(presentedViewController: presented, presenting: presenting)
        sheetPresentationController.detents = [.medium()]
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = true
        return sheetPresentationController
    }
}


extension AddPhotoViewController: TagSelectionDelegate {
    func didSelectTag(_ tag: TagModel) {
        addPhotoView.tagAddButton.setTitle(tag.tagLabel, for: .normal)
        addPhotoView.tagImageView.image = tag.tagImage
    }
    
    
}
