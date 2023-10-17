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
    
    private let addPhotoView = AddPhotoView()


    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        setup()
        setupTapGestures()
        tagButtonTapped()
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
    
    private func setupTapGestures() {
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
 
    
    
//    func requestPhotoLibraryAccess() {
//        PHPhotoLibrary.requestAuthorization {  status in
//            switch status {
//            case .authorized:
//                // 사용자가 권한을 허용한 경우
//                // 여기에서 사진 라이브러리에 접근할 수 있습니다.
//                let fetchOptions = PHFetchOptions()
//                let allPhotos = PHAsset.fetchAssets(with: fetchOptions)
//                DispatchQueue.main.async {
//                    self.setupImagePicker()
//                    // 사진에 접근하여 무엇인가 작업 수행
//                }
//            case .denied, .restricted:
//                DispatchQueue.main.async {
//                    let alertController = UIAlertController(title: "사진 접근 거부됨", message: "사진에 접근하려면 설정에서 권한을 허용해야 합니다.", preferredStyle: .alert)
//                    let settingsAction = UIAlertAction(title: "설정 열기", style: .default) { _ in
//                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
//                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
//                        }
//                    }
//                    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//                    alertController.addAction(settingsAction)
//                    alertController.addAction(cancelAction)
//                    self.present(alertController, animated: true, completion: nil)
//                }
//            case .notDetermined: break
//                // 사용자가 아직 결정을 내리지 않은 경우
//                // 다음에 권한 요청을 수행할 수 있습니다.
//
//            @unknown default:
//                break
//            }
//        }
//    }
    
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

extension AddPhotoViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
       
    }
}


extension AddPhotoViewController: TagSelectionDelegate {
    func didSelectTag(_ tag: TagModel) {
//        if addPhotoView.tagStackView.contains(addPhotoView.tagAddButton) == true {
//            print("tagAddButton 확인")
//            addPhotoView.tagStackView.removeArrangedSubview(addPhotoView.tagAddButton)
//            addPhotoView.tagStackView.addArrangedSubviews(addPhotoView.tagImageButton)
//            addPhotoView.tagImageButton.setTitle(tag.tagLabel, for: .normal)
//            addPhotoView.tagImageButton.setImage(tag.tagImage, for: .normal)
//        } else {
//            addPhotoView.tagImageButton.setTitle(tag.tagLabel, for: .normal)
//            addPhotoView.tagImageButton.setImage(tag.tagImage, for: .normal)
//        }
        
        addPhotoView.tagAddButton.setTitle(tag.tagLabel, for: .normal)
        addPhotoView.tagAddButton.setImage(tag.tagImage, for: .normal)
    }
    
    
}
