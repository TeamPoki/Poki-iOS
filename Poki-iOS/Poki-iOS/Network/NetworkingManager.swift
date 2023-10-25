//
//  NetworkingManager.swift
//  Poki-iOS
//
//  Created by Insu on 10/14/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class NetworkingManager {
    static let shared = NetworkingManager()
    
    private init() {}
    
    // MARK: - 포즈 추천 사진 불러오기
    func getAlonePoseImages() -> [UIImage?] {
        let images = [
            UIImage(named: "alone-pose1"),
            UIImage(named: "alone-pose2"),
            UIImage(named: "alone-pose3"),
            UIImage(named: "alone-pose4"),
            UIImage(named: "alone-pose5")
        ]
        return images
    }
    
    func getTwoPoseImages() -> [UIImage?] {
        let images = [
            UIImage(named: "two-pose1"),
            UIImage(named: "two-pose2"),
            UIImage(named: "two-pose3"),
            UIImage(named: "two-pose4"),
            UIImage(named: "two-pose5")
        ]
        return images
    }
    
    func getManyPoseImages() -> [UIImage?] {
        let images = [
            UIImage(named: "many-pose1"),
            UIImage(named: "many-pose2"),
            UIImage(named: "many-pose3"),
            UIImage(named: "many-pose4"),
            UIImage(named: "many-pose5")
        ]
        return images
    }

    func uploadImage(image: [UIImage], date: String, memo: String, tagText: String, completion: @escaping (Result<(URL, URL), Error>) -> Void) {
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
        
        let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
        
        let firebaseReference = Storage.storage().reference().child(imageName)

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
}
