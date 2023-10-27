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
import FirebaseFirestore
import FirebaseFirestoreSwift
import Kingfisher

protocol TagSelectionDelegate: AnyObject {
    func didSelectTag(_ tag: TagModel)
}

enum ViewSeperated {
    case new
    case edit
}

final class AddPhotoVC: UIViewController {
    
    // MARK: - Properties
    
     let addPhotoView = AddPhotoView()

    var viewSeperated: ViewSeperated = .new
    
    var photoData: Photo?
    var indexPath: IndexPath?
    
    let dataManager = PoseImageManager.shared
    let firestoreManager = FirestoreManager.shared
    let storageManager = StorageManager.shared
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNav()
        configuration()
        setup()
        mainImageSetupTapGestures()
        tagButtonTapped()
        datePickerTapped()
        tagImageSetupTapGestures()
        addButtonTapped()
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
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        addPhotoView.memoTextField.delegate = self
    }
    
    private func configuration() {
        guard let photoData = photoData else { return }
        let photoImageURL = URL(string: photoData.image)
        let tagImageURL = URL(string: photoData.tag.tagImage)
        switch self.viewSeperated {
        case .edit:
            navigationItem.title = "수정하기"
            addPhotoView.photoImageView.kf.setImage(with: photoImageURL)
            addPhotoView.dateTextField.text = photoData.date
            addPhotoView.memoTextField.text = photoData.memo
            addPhotoView.tagImageView.kf.setImage(with: tagImageURL)
            addPhotoView.tagAddButton.setTitle(photoData.tag.tagLabel, for: .normal)
        default:
            break
        }
    }
    
    private func tagButtonTapped() {
        addPhotoView.tagAddButton.addTarget(self, action: #selector(tagButtonAction), for: .touchUpInside)
    }
    
    private func datePickerTapped() {
        addPhotoView.datePicker.addTarget(self, action: #selector(dateButtonAction), for: .valueChanged)
    }
    
    private func addButtonTapped() {
        addPhotoView.addButton.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
    }
    
   

    
    // MARK: - Actions
    
    @objc private func handleCloseButton() {
        let alert = UIAlertController(title: nil, message: "페이지 나가기", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "종료", style: .destructive, handler: { _ in
            if let navigationController = self.navigationController, let mainPageVC = navigationController.viewControllers.first(where: { $0 is MainPageVC }) {
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
        let tagViewController = TagVC()
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
    
    func uploadAndCreateImageData(image: [UIImage], date: String, memo: String, tagText: String) {
        storageManager.uploadImage(image: image, date: date, memo: memo, tagText: tagText) { result in
            switch result {
            case .success((let photoURL, let tagURL)):
                // 이미지 업로드 및 다운로드 URL 가져온 후에 데이터 생성 및 Firestore에 저장
                self.createImageData(photoURL: photoURL, tagURL: tagURL, date: date, memo: memo, tagText: tagText)
                
            case .failure(let error):
                print("Error uploading images: \(error.localizedDescription)")
                // 오류 처리
            }
        }
    }
    
    // Firestore에 데이터 생성 및 저장
    private func createImageData(photoURL: URL, tagURL: URL, date: String, memo: String, tagText: String) {
        // URL을 문자열로 변환
        let photoURLString = photoURL.absoluteString
        let tagURLString = tagURL.absoluteString
        
        // Firestore에 데이터 생성
        firestoreManager.create(image: photoURLString, date: date, memo: memo, tagText: tagText, tagImage: tagURLString)
    }
    
    
    func updateData(documentPath: String, image: [UIImage], date: String, memo: String, tagText: String) {
        storageManager.uploadImage(image: image, date: date, memo: memo, tagText: tagText) { result in
            switch result {
            case .success((let photoURL, let tagURL)):
                // 이미지 업로드 및 다운로드 URL 가져온 후에 데이터 생성 및 Firestore에 저장
                self.updateImageData(documentPath: documentPath, photoURL: photoURL, tagURL: tagURL, date: date, memo: memo, tagText: tagText)
                
            case .failure(let error):
                print("Error uploading images: \(error.localizedDescription)")
                // 오류 처리
            }
        }
    }
    
    // Firestore에 데이터 생성 및 저장
    private func updateImageData(documentPath: String, photoURL: URL, tagURL: URL, date: String, memo: String, tagText: String) {
        // URL을 문자열로 변환
        let photoURLString = photoURL.absoluteString
        let tagURLString = tagURL.absoluteString
        
        // Firestore에 데이터 생성
        firestoreManager.update(documentPath: documentPath, image: photoURLString, date: date, memo: memo, tagText: tagText, tagImage: tagURLString)
    }
    
 
    
    //Creat 메서드
    @objc private func addButtonAction() {
        if addPhotoView.photoImageView.image != nil {
            guard let image = addPhotoView.photoImageView.image else { return }
            guard  let date = addPhotoView.dateTextField.text else { return }
            guard let memo = addPhotoView.memoTextField.text else { return }
            guard let tagImage = addPhotoView.tagImageView.image else { return }
            guard let tagText = addPhotoView.tagAddButton.currentTitle else { return }
            switch self.viewSeperated {
            case .new:
                
                uploadAndCreateImageData(image: [image, tagImage], date: date, memo: memo, tagText: tagText)
                
                //Update 메서드
            case .edit:
                guard let photoData = photoData else { return }
                updateData(documentPath: photoData.documentReference , image: [image, tagImage], date: date, memo: memo, tagText: tagText)
                storageManager.deleteImage(imageURL: photoData.image) { _ in
                    print("이미지 삭제 완료")
                }
                storageManager.deleteImage(imageURL: photoData.tag.tagImage) { _ in
                    print("이미지 삭제 완료")
                }
              

            }
        } else {
            let alertController = UIAlertController(title: "경고", message: "이미지를 반드시 입력해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc private func tagImageTapped() {
        tagButtonAction()
    }
    
    //이미지 제한 함수
    private func limitedImageUpload(image: UIImage, picker: PHPickerViewController) {
        let maxSizeInBytes: Int = 4 * 1024 * 1024
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            if imageData.count > maxSizeInBytes {
                let alertController = UIAlertController(title: "경고", message: "이미지 파일이 너무 큽니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                picker.dismiss(animated: true, completion: nil)
                present(alertController, animated: true, completion: nil)
            } else {
                self.addPhotoView.photoImageView.image = image
            }
        }
    }
    
    //키보드 관련
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
 
}


extension AddPhotoVC: PHPickerViewControllerDelegate {
    // 사진이 선택이 된 후에 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    guard let dataImage = image as? UIImage else { return }
                    self.limitedImageUpload(image: dataImage, picker: picker)
                }
            }
        } else {
            print("이미지 로드 실패")
        }
    }
}

extension AddPhotoVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        // UISheetPresentationController를 사용하여 커스텀 프레

let sheetPresentationController = UISheetPresentationController(presentedViewController: presented, presenting: presenting)
        sheetPresentationController.detents = [.medium()]
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = true
        return sheetPresentationController
    }
}


extension AddPhotoVC: TagSelectionDelegate {
    func didSelectTag(_ tag: TagModel) {
        addPhotoView.tagAddButton.setTitle(tag.tagLabel, for: .normal)
        storageManager.downloadImage(urlString: tag.tagImage) {  image in
            DispatchQueue.main.async {
                self.addPhotoView.tagImageView.image = image
            }
        }
    }
}

extension AddPhotoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addPhotoView.memoTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         animateViewMoving(up: true)
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
         animateViewMoving(up: false)
     }
     
     // 키보드가 나타날 때 뷰를 이동시키는 메서드
     func animateViewMoving(up: Bool) {
         let movement: CGFloat = (up ? -keyboardOffset() : keyboardOffset())
         
         UIView.animate(withDuration: 0.3) {
             self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
         }
     }
     
     // 키보드의 높이 반환
     func keyboardOffset() -> CGFloat {
         return addPhotoView.memoTextField.frame.origin.y + addPhotoView.memoTextField.frame.height
     }
}
