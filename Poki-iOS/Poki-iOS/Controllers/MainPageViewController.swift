//
//  MainPageViewController.swift
//  Poki-iOS
//
//  Created by Insu on 10/15/23.
//

import UIKit
import SnapKit
import Then
import PhotosUI

class MainPageViewController: UIViewController {
    
    // MARK: - Properties
    
    
    
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
    }
    
    // MARK: - Helpers

    private func configureNav() {
        let logo = UIImage(named: "poki-logo") // 현재 임시로 넣은거라 사이즈도 작아서 추후에 로고 제작이 된다면 바로 적용
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        let logoBarButton = UIBarButtonItem(customView: imageView)
        navigationItem.leftBarButtonItem = logoBarButton
        
        let appearance = UINavigationBarAppearance().then {
            $0.configureWithOpaqueBackground()
            $0.backgroundColor = .white
            $0.shadowColor = nil
        }
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .black
        
        let galleryAction = UIAction(title: "갤러리에서 추가하기", image: UIImage(systemName: "photo"), handler: { _ in
            self.requestPhotoLibraryAccess()
        })
        let cameraAction = UIAction(title: "QR코드로 추가하기", image: UIImage(systemName: "qrcode"), handler: { _ in
            print("카메라 기능 구현예정")
        })

        let menu = UIMenu(title: "", children: [galleryAction, cameraAction])
        
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), primaryAction: nil, menu: menu)
        navigationItem.rightBarButtonItem = plusButton
    }

    

    
    
    
    
    
    // MARK: - Actions
    private func setupImagePicker() {
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .any(of: [.images, .videos])
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }

    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization {  status in
            switch status {
            case .authorized:
                // 사용자가 권한을 허용한 경우
                // 여기에서 사진 라이브러리에 접근할 수 있습니다.
                let fetchOptions = PHFetchOptions()
                let allPhotos = PHAsset.fetchAssets(with: fetchOptions)
                DispatchQueue.main.async {
                    self.setupImagePicker()
                    // 사진에 접근하여 무엇인가 작업 수행
                }
            case .denied, .restricted:
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "사진 접근 거부됨", message: "사진에 접근하려면 설정에서 권한을 허용해야 합니다.", preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "설정 열기", style: .default) { _ in
                        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                        }
                    }
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                    alertController.addAction(settingsAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            case .notDetermined: break
                // 사용자가 아직 결정을 내리지 않은 경우
                // 다음에 권한 요청을 수행할 수 있습니다.

            @unknown default:
                break
            }
        }
    }
    
}


extension MainPageViewController: PHPickerViewControllerDelegate {
    // 사진이 선택이 된 후에 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    let addPhotoVC = AddPhotoViewController() 
                    addPhotoVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(addPhotoVC, animated: true)
                    addPhotoVC.addPhotoView.photoImageView.image = image as? UIImage
                }
            }
        } else {
            print("이미지 로드 실패")
        }
    }
}
