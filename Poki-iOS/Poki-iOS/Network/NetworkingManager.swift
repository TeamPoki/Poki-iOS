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

enum FirebaseError: Error {
    case imageCountError
    case imageDataError
    case downloadURLError
}


class NetworkingManager {
    static let shared = NetworkingManager()
    let db = Firestore.firestore()
    lazy var collectionReference = db.collection("Photo")
    lazy var documentReference = collectionReference.document("7vL68IneYlNuRW3cz5oZ")
    var photoList: [Photo] = []
    private init() {}
    
    private func createPhotoFromData(_ data: [String: Any]) -> Photo? {
        guard
            let documentReference = data["documentReference"] as? String,
            let image = data["image"] as? String,
            let memo = data["memo"] as? String,
            let date = data["date"] as? String,
            let tagData = data["tag"] as? [String: Any],
            let tagLabel = tagData["tagLabel"] as? String,
            let tagImage = tagData["tagImage"] as? String
        else {
            // 필수 필드가 누락되었거나 형식이 맞지 않는 경우 nil 반환
            return nil
        }

        let tag = TagModel(tagLabel: tagLabel, tagImage: tagImage)
        return Photo(documentReference: documentReference, image: image, memo: memo, date: date, tag: tag)
    }
    
    func create(image: String, date: String, memo: String, tagText: String, tagImage: String) {
        let newDocumentRef = collectionReference.document()
        let phothData = Photo(documentReference: newDocumentRef.path, image: image, memo: memo, date: date, tag: TagModel(tagLabel: tagText, tagImage: tagImage))
        do {
            try newDocumentRef.setData(from: phothData)
            print("Document added successfully.")
        } catch let error {
            print("Error adding document: \(error)")
        }
    }
    
    //실시간반영
    func realTimebinding(collectionView : UICollectionView) {
        self.collectionReference.addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Error Firestore fetching document: \(String(describing: error))")
                return
            }

            self.photoList = documents.compactMap { doc -> Photo? in
                // Firestore 스냅샷에서 필요한 데이터를 가져와 Photo 모델에 직접 할당
                let data = doc.data()
                if let photo = self.createPhotoFromData(data) {
                    print("photo data load 완료")
                    return photo
                } else {
                    return nil
                }
                
            }
            collectionView.reloadData()
        }
    }

   
   func update(documentPath: String, image: String, date: String, memo: String, tagText: String, tagImage: String) {
       let documentComponents = documentPath.components(separatedBy: "/")
       let collectionName = documentComponents[0]
        let documentID = documentComponents[1]
       let docRef = collectionReference.document(documentID)
       let data: [String : Any] = [
            "image" : image,
            "date" : date,
            "memo" : memo,
            "tag" : [
                "tagLabel": tagText,
                "tagImage": tagImage
            ]
        ]
       docRef.updateData(data) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document updated successfully.")
            }
        }
    }
    

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

    func delete(documentPath: String) {
        let documentComponents = documentPath.components(separatedBy: "/")
        _ = documentComponents[0]
        let documentID = documentComponents[1]
        let docRef = collectionReference.document(documentID)
        
        docRef.delete { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document updated successfully.")
            }
        }
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
