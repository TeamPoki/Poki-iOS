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
import Kingfisher

final class MainPageVC: UIViewController {

    // MARK: - Properties

    private let firestoreManager = FirestoreManager.shared
    private let stoageManager = StorageManager.shared
    private let emptyPhotoListView = EmptyPhotoListView()

    private var photoListCollectionView: UICollectionView = {
        let layout = CarouselFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.7)
        layout.sideItemScale = 175 / 251
        layout.spacing = -190
        layout.sideItemAlpha = 0.5

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        setupCollectionView()
        firestoreManager.userRealTimebinding()
        firestoreManager.photoRealTimebinding(collectionView: photoListCollectionView)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintColor = .black
    }

    // MARK: - Helpers

    private func configureNav() {
        let logoLabel = UILabel().then {
            $0.text = "POKI"
            $0.font = UIFont(name: Constants.fontHeavy, size: 32)
            $0.textColor = .black
            $0.sizeToFit()
        }
        navigationController?.configureBasicAppearance()

        let logoBarButton = UIBarButtonItem(customView: logoLabel)
        navigationItem.leftBarButtonItem = logoBarButton

        let filterButton = createFilterButton()
        let plusButton = createPlusButton()
        navigationItem.rightBarButtonItems = [plusButton, filterButton]
    }

    private func createFilterButton() -> UIBarButtonItem {
        let recentDateAction = UIAction(title: "최근 날짜순", image: nil, handler: { _ in
            self.sortByDate(ascending: false)
        })

        let oldDateAction = UIAction(title: "오래된 날짜순", image: nil, handler: { _ in
            self.sortByDate(ascending: true)
        })

        let dateSubMenu = UIMenu(title: "날짜", image: UIImage(systemName: "calendar"), identifier: nil, options: [], children: [recentDateAction, oldDateAction])

        let filterMenu = UIMenu(title: "", children: [dateSubMenu])
        return UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), primaryAction: nil, menu: filterMenu)
    }

    private func createPlusButton() -> UIBarButtonItem {
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
        return UIBarButtonItem(image: UIImage(systemName: "plus"), primaryAction: nil, menu: menu)
    }

    private func stringToDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter.date(from: dateString)
    }

    private func sortByDate(ascending: Bool) {
        firestoreManager.photoList.sort {
            guard let date1 = stringToDate($0.date), let date2 = stringToDate($1.date) else { return false }
            return ascending ? date1 < date2 : date1 > date2
        }
        photoListCollectionView.reloadData()
    }

    private func setupCollectionView() {
        view.addSubview(photoListCollectionView)

        photoListCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        photoListCollectionView.delegate = self
        photoListCollectionView.dataSource = self

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

    func updateEmptyPhotoListViewVisibility() {
        if firestoreManager.photoList.isEmpty {
            view.addSubview(emptyPhotoListView)
            emptyPhotoListView.snp.makeConstraints {
                $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
                $0.left.right.equalToSuperview()
            }
        } else {
            emptyPhotoListView.removeFromSuperview()
        }
    }

    // MARK: - Actions

    private func limitedImageUpload(image: UIImage, picker: PHPickerViewController) {
        let maxSizeInBytes = 4 * 1024 * 1024
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
        let url = URL(string: photo.image)
        cell.titleLabel.text = photo.memo
        cell.dateLabel.text = photo.date
        cell.tagLabel.text = photo.tag.tagLabel
        
        // Kingfisher를 사용하여 비동기적으로 이미지를 다운로드하고 셀에 그라데이션 설정
        cell.photoImage.kf.setImage(
            with: url,
            placeholder: nil,
            options: nil,
            progressBlock: nil)
        { result in
            switch result {
            case .success(let value):
                let image = value.image
                cell.setGradient(image: image)
            case .failure(let error):
                print(error)
            }
        }

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
                    addPhotoVC.addPhotoView.photoImageView.image = dataImage
                    addPhotoVC.addPhotoCompletionHandler = { photo in
                        self.photoListCollectionView.performBatchUpdates {
                            self.firestoreManager.photoList.insert(photo, at: 0)
                            self.photoListCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
                        }
                    }
                    self.navigationController?.pushViewController(addPhotoVC, animated: true)
                }
            }
        } else {
            print("이미지 로드 실패")
        }
    }
}
