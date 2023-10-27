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

final class MainPageVC: UIViewController {

    // MARK: - Properties
    
    private let dataManager = PoseImageManager.shared
    private let firestoreManager = FirestoreManager.shared
    private  let stoageManager = StorageManager.shared

    private var photoListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        photoListCollectionView.reloadData()
        firestoreManager.realTimebinding(collectionView: photoListCollectionView)
    }

    // MARK: - Helpers
    
    private func configureNav() {
        let logoLabel = UILabel().then {
            $0.text = "POKI"
            $0.font = UIFont(name: Constants.fontHeavy, size: 32)
            $0.textColor = .black
            $0.sizeToFit()
        }
        
        let logoBarButton = UIBarButtonItem(customView: logoLabel)
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
            let qrCodeVC = QRCodeVC()
            let navController = UINavigationController(rootViewController: qrCodeVC)
            navController.modalPresentationStyle = .fullScreen
            self.present(navController, animated: true, completion: nil)
        })

        let menu = UIMenu(title: "", children: [galleryAction, cameraAction])

        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus"), primaryAction: nil, menu: menu)
        navigationItem.rightBarButtonItem = plusButton
    }

    private func setupCollectionView() {
        view.addSubview(photoListCollectionView)

        photoListCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        photoListCollectionView.delegate = self
        photoListCollectionView.dataSource = self
        photoListCollectionView.isPagingEnabled = true

        photoListCollectionView.register(MainPhotoListCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }

    private func setupImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .videos])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }

    // MARK: - Actions

//    @objc private func handleLogout() {
//        UserDefaults.standard.removeObject(forKey: "userIdStatus")
//        self.userIdStatus.toggle()
//    }
    
    private func limitedImageUpload(image: UIImage, picker: PHPickerViewController) {
        let maxSizeInBytes: Int = 4 * 1024 * 1024
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            if imageData.count > maxSizeInBytes {
                let alertController = UIAlertController(title: "경고", message: "이미지 파일이 너무 큽니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                picker.dismiss(animated: true, completion: nil)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { status in
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

            case .limited:
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.fetchLimit = 30 // 최신 30장만 가져옴
                @unknown default:
                break
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension MainPageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return firestoreManager.photoList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! MainPhotoListCell
        let photo = firestoreManager.photoList[indexPath.row]
        
        stoageManager.downloadImage(urlString: photo.image) {  image in
            DispatchQueue.main.async {
                cell.photoImage.image = image
            }
        }
            
        stoageManager.downloadImage(urlString: photo.tag.tagImage) {  image in
            DispatchQueue.main.async {
                cell.tagImage.image = image
            }
        }
        cell.titleLabel.text = photo.memo
        cell.dateLabel.text = photo.date
        cell.tagLabel.text = photo.tag.tagLabel
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoDetailVC = PhotoDetailVC()
        photoDetailVC.photoData = firestoreManager.photoList[indexPath.row]
        photoDetailVC.indexPath = indexPath
        photoDetailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(photoDetailVC, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MainPageVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.height * 0.7)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: collectionView.frame.width * 0.1, bottom: 20, right: collectionView.frame.width * 0.1)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -collectionView.frame.width * 0.2
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        updateCellAppearance(cell: cell, in: collectionView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in photoListCollectionView.visibleCells {
            updateCellAppearance(cell: cell, in: photoListCollectionView)
        }
    }

    private func updateCellAppearance(cell: UICollectionViewCell, in collectionView: UICollectionView) {
        let distanceFromCenter = abs(collectionView.frame.width / 2 - cell.center.x + collectionView.contentOffset.x)
        let scale = max(0.75, 1 - distanceFromCenter / collectionView.frame.width)

        cell.transform = CGAffineTransform(scaleX: scale, y: scale)
        // 셀의 중앙 위치에서 얼마나 떨어져 있는지에 따라 알파 값을 조절
        if distanceFromCenter > collectionView.frame.width / 2 {
            cell.alpha = 0
        } else {
            cell.alpha = 1 - (distanceFromCenter / (collectionView.frame.width / 2))
        }

        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.3
        cell.layer.shadowOffset = CGSize(width: 0, height: 5)
        cell.layer.shadowRadius = 10
        cell.layer.masksToBounds = false
    }
}

// MARK: - PHPickerViewControllerDelegate

extension MainPageVC: PHPickerViewControllerDelegate {
    // 사진이 선택이 된 후에 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    let dataImage = image as? UIImage
                    self.limitedImageUpload(image: dataImage!, picker: picker)
                    let addPhotoVC = AddPhotoVC()
                    addPhotoVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(addPhotoVC, animated: true)
                    addPhotoVC.addPhotoView.photoImageView.image = dataImage
                }
            }
        } else {
            print("이미지 로드 실패")
        }
    }
}
