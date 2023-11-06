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
    
    let firestoreManager = FirestoreManager.shared
    let storageManager = StorageManager.shared
    
    var addPhotoCompletionHandler: ((Photo?) -> Void)?
    var updateCompletionHandler: (() -> Void)?
    
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
        keyboardLayoutSetting()
    }
    
    // MARK: - Helpers
    
    private func configureNav() {
        navigationItem.title = "추억 저장하기"
        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseButton))
        navigationItem.leftBarButtonItem = closeButton
        navigationController?.configureBasicAppearance()
    }
    
    private func setup() {
        self.view.addSubview(addPhotoView)
        
        addPhotoView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configuration() {
        guard let photoData = photoData else { return }
        let photoImageURL = URL(string: photoData.image)
        let tagImageURL = URL(string: photoData.tag.tagImage)
        switch self.viewSeperated {
        case .edit:
            navigationItem.title = "추억 수정하기"
            addPhotoView.photoImageView.kf.setImage(with: photoImageURL)
            addPhotoView.dateTextField.text = photoData.date
            addPhotoView.memoTextField.text = photoData.memo
            addPhotoView.tagImageView.kf.setImage(with: tagImageURL)
            addPhotoView.tagAddButton.setTitle(photoData.tag.tagLabel, for: .normal)
            addPhotoView.addButton.setTitle("수정하기", for: .normal)
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
    
    private func keyboardLayoutSetting() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Actions
    
    @objc private func handleCloseButton() {
        let alert = UIAlertController(title: "페이지 나가기", message: "정말로 페이지를 나가시겠습니까?\n입력된 정보는 사라집니다.", preferredStyle: .alert)
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
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if addPhotoView.dateTextField.isFirstResponder {
            return
        }
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        let memoTextFieldFrame = addPhotoView.memoTextField.convert(addPhotoView.memoTextField.bounds, to: self.view)
        let memoTextFieldBottom = memoTextFieldFrame.origin.y + memoTextFieldFrame.size.height
        let spaceBetweenTextFieldAndKeyboard = 20.0
        
        let offsetY = memoTextFieldBottom + spaceBetweenTextFieldAndKeyboard - (self.view.frame.height - keyboardSize.height)

        if offsetY > 0 {
            self.view.frame.origin.y = 0 - offsetY
        }
    }

    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    func createPhoto(photoImageURL: URL, date: String, memo: String, tagImageURL: URL, tagText: String, completion: (DocumentReference, Photo) -> Void) {
//        let photoStringURL = photoImageURL.absoluteString
//        let tagStringURL = tagImageURL.absoluteString
//        firestoreManager.createPhotoData(photoURL: photoStringURL, date: date, memo: memo, tagURL: tagStringURL, tagText: tagText) { docRef, photo in
//            completion(docRef, photo)
//        }
//    }
    
    private func uploadPhoto(completion: @escaping (Result<(URL, URL), Error>) -> Void) {
        guard let photoImage = addPhotoView.photoImageView.image else { return }
        guard let tagImage = addPhotoView.tagImageView.image else { return }
        storageManager.uploadPhotoImage(image: [photoImage, tagImage]) { result in
            completion(result)
        }
    }
    
    private func createPhotoDocument(id: String?, completion: @escaping (Photo?, Error?) -> Void) {
        guard let tagText = addPhotoView.tagAddButton.currentTitle,
              let memo = addPhotoView.memoTextField.text,
              let date = addPhotoView.dateTextField.text else { return }
        self.uploadPhoto { [weak self] result in
            switch result {
            case .success((let photoURL, let tagURL)):
                guard let newID = self?.firestoreManager.newPhotoDocumentID else { return }
                let tag = TagModel(tagLabel: tagText, tagImage: tagURL.absoluteString)
                let newPhoto = Photo(id: id ?? String(newID), image: photoURL.absoluteString, memo: memo, date: date, tag: tag)
                self?.firestoreManager.createPhotoDocument(photo: newPhoto) { error in
                    if let error = error {
                        completion(nil, error)
                    }
                    completion(newPhoto, nil)
                }
            case .failure(let error):
                print("ERROR: AddPhotoVC - 포토, 태그 이미지 업로드 실패 \(error)")
            }
        }
    }
    
//    func updateData(documentPath: String, image: [UIImage], date: String, memo: String, tagText: String) {
//        storageManager.photoUploadImage(image: image, date: date, memo: memo, tagText: tagText) { result in
//            switch result {
//            case .success((let photoURL, let tagURL)):
//                // 이미지 업로드 및 다운로드 URL 가져온 후에 데이터 생성 및 Firestore에 저장
//                self.updateImageData(documentPath: documentPath, photoURL: photoURL, tagURL: tagURL, date: date, memo: memo, tagText: tagText)
//            case .failure(let error):
//                print("Error uploading images: \(error.localizedDescription)")
//                // 오류 처리
//            }
//        }
//    }
    
    // Firestore에 데이터 생성 및 저장
//    private func updateImageData(documentPath: String, photoURL: URL, tagURL: URL, date: String, memo: String, tagText: String) {
//        // URL을 문자열로 변환
//        let photoURLString = photoURL.absoluteString
//        let tagURLString = tagURL.absoluteString
//
//         Firestore에 데이터 생성
//        firestoreManager.photoUpdate(documentPath: documentPath, image: photoURLString, date: date, memo: memo, tagText: tagText, tagImage: tagURLString)
//    }
    
    // Creat 메서드
    @objc private func addButtonAction() {
        if addPhotoView.photoImageView.image != nil {
            switch self.viewSeperated {
            case .new:
                self.showLoadingIndicator()
                self.createPhotoDocument(id: nil) { [weak self] (newPhoto, error) in
                    if let error = error {
                        print("ERROR: AddPhotoVC - 포토 문서 생성 실패 \(error.localizedDescription)")
                    }
                    self?.addPhotoCompletionHandler?(newPhoto)
                    self?.hideLoadingIndicator()
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            // Update 메서드
            case .edit:
                guard let photoData = photoData else { return }
                storageManager.deleteImage(imageURL: photoData.image) { _ in
                    print("포토 이미지 삭제 완료")
                }
                storageManager.deleteImage(imageURL: photoData.tag.tagImage) { _ in
                    print("태그 이미지 삭제 완료")
                }
                self.showLoadingIndicator()
                self.createPhotoDocument(id: photoData.id) { [weak self] (_, error) in
                    if let error = error {
                        print("ERROR: AddPhotoVC - 포토 문서 생성 실패 \(error.localizedDescription)")
                    }
                    self?.updateCompletionHandler?()
                    self?.hideLoadingIndicator()
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        } else {
            let alertController = UIAlertController(title: "경고", message: "이미지를 반드시 입력해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc private func tagImageTapped() {
        tagButtonAction()
    }
    
    // 이미지 제한 함수
    private func limitedImageUpload(image: UIImage, picker: PHPickerViewController) {
        let maxSizeInBytes = 4 * 1024 * 1024
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
    
    // 키보드 관련
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK: - PHPickerViewControllerDelegate

extension AddPhotoVC: PHPickerViewControllerDelegate {
    // 사진이 선택이 된 후에 호출되는 메서드
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
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

// MARK: - UIViewControllerTransitioningDelegate

extension AddPhotoVC: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let sheetPresentationController = UISheetPresentationController(presentedViewController: presented, presenting: presenting)
        sheetPresentationController.detents = [.medium()]
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.prefersScrollingExpandsWhenScrolledToEdge = true
        return sheetPresentationController
    }
}

// MARK: - TagSelectionDelegate

extension AddPhotoVC: TagSelectionDelegate {
    func didSelectTag(_ tag: TagModel) {
        let url = URL(string: tag.tagImage)
        addPhotoView.tagAddButton.setTitle(tag.tagLabel, for: .normal)
        addPhotoView.tagAddButton.titleLabel?.font = UIFont(name: Constants.fontSemiBold, size: 14)
        addPhotoView.tagImageView.kf.setImage(with: url)
        addPhotoView.setTagStackViewBorder(show: true)
    }
}
