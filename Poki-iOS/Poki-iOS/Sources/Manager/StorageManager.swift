//
//  StorageManager.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/25.
//

import UIKit
import FirebaseStorage

final class StorageManager {
    private let authManager = AuthManager.shared
    static let shared = StorageManager()
    private init() {}
    
    // 아직 다른곳에서 사용하고 있어서 삭제 안했습니다. 추후 메서드 리팩토링 시 삭제 예정
    func photoUploadImage(image: [UIImage], date: String, memo: String, tagText: String, completion: @escaping (Result<(URL, URL), Error>) -> Void) {
        guard let userUID = authManager.currentUserUID else { return }
        guard image.count >= 2 else {
            completion(.failure(FirebaseError.imageCountError))
            return
        }
        
        let photoImageData = image[0].jpegData(compressionQuality: 0.4)
        let tagImageData = image[1].jpegData(compressionQuality: 0.4)

        guard let photoData = photoImageData, let tagData = tagImageData else {
            completion(.failure(FirebaseError.imageDataError))
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = userUID
        
        let firebaseReference = Storage.storage().reference().child(imageName).child(UUID().uuidString)

        // Upload the first image.
        firebaseReference.child("photo.jpg").putData(photoData, metadata: metaData) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Upload the second image.
            firebaseReference.child("tag.jpg").putData(tagData, metadata: metaData) { _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Get download URLs for both images.
                firebaseReference.child("photo.jpg").downloadURL { photoURL, _ in
                    firebaseReference.child("tag.jpg").downloadURL { tagURL, _ in
                        if let photoURL = photoURL, let tagURL = tagURL {
                            // Return the download URLs in the completion handler.
                            completion(.success((photoURL, tagURL)))
                        } else {
                            completion(.failure(FirebaseError.downloadURLError))
                        }
                    }
                }
            }
        }
    }
    
    func uploadPhotoImage(image: [UIImage], completion: @escaping (Result<(URL, URL), Error>) -> Void) {
        guard image.count >= 2 else {
            completion(.failure(FirebaseError.imageCountError))
            return
        }
        
        let photoImageData = image[0].jpegData(compressionQuality: 0.4)
        let tagImageData = image[1].jpegData(compressionQuality: 0.4)

        guard let photoData = photoImageData, let tagData = tagImageData else {
            completion(.failure(FirebaseError.imageDataError))
            return
        }
        guard let userUID = authManager.currentUserUID else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = userUID
        
        let firebaseReference = Storage.storage().reference().child(imageName).child(UUID().uuidString)

        // Upload the first image.
        firebaseReference.child("photo.jpg").putData(photoData, metadata: metaData) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Upload the second image.
            firebaseReference.child("tag.jpg").putData(tagData, metadata: metaData) { _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Get download URLs for both images.
                firebaseReference.child("photo.jpg").downloadURL { photoURL, _ in
                    firebaseReference.child("tag.jpg").downloadURL { tagURL, _ in
                        if let photoURL = photoURL, let tagURL = tagURL {
                            // Return the download URLs in the completion handler.
                            completion(.success((photoURL, tagURL)))
                        } else {
                            completion(.failure(FirebaseError.downloadURLError))
                        }
                    }
                }
            }
        }
    }
    
    func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: urlString)
        let megaByte = Int64(4.9 * 1024 * 1024)
           
        storageReference.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
    
    func deleteImage(imageURL: String, completion: @escaping (Error?) -> Void) {
        let storageReference = Storage.storage().reference(forURL: imageURL)

        // 이미지를 삭제합니다.
        storageReference.delete { error in
            if let error = error {
                completion(error)
            } else {
                // 이미지가 성공적으로 삭제된 경우 nil을 반환합니다.
                completion(nil)
            }
        }
    }
    
    // MARK: - PoseData
    
    func poseDownloadImages(fromURLs urls: [String], completion: @escaping ([UIImage?]) -> Void) {
        let storage = Storage.storage()
        let group = DispatchGroup()
        var images: [UIImage?] = Array(repeating: nil, count: urls.count)

        for (index, urlString) in urls.enumerated() {
            group.enter()

            let storageReference = storage.reference(forURL: urlString)
            let megaByte = Int64(4.9 * 1024 * 1024)

            storageReference.getData(maxSize: megaByte) { data, error in
                if let imageData = data {
                    images[index] = UIImage(data: imageData)
                }

                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(images)
        }
    }
    
    func userImageUpload(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        let ImageData = image.jpegData(compressionQuality: 0.4)

        guard let photoData = ImageData else {
            completion(.failure(FirebaseError.imageDataError))
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        
        let firebaseReference = Storage.storage().reference().child(imageName)

        // Upload the first image.
        firebaseReference.child("photo.jpg").putData(photoData, metadata: metaData) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

                firebaseReference.child("photo.jpg").downloadURL { photoURL, _ in
                        if let photoURL = photoURL {
                            completion(.success(photoURL))
                        } else {
                            completion(.failure(FirebaseError.downloadURLError))
                        }
                   
                }
            }
        }
   
    
}
