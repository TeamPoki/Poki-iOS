//
//  FirestoreManager.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/25.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class FirestoreManager {
    static let shared = FirestoreManager()
    
    private init() {}
    
    private let db = Firestore.firestore()
    private lazy var collectionReference = db.collection("Photo")
    var photoList: [Photo] = []
    
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
        if let user = Auth.auth().currentUser {
            let userID = user.uid
            
            let newDocumentRef = db.collection("users/\(userID)/Photo").document()
            let phothData = Photo(documentReference: newDocumentRef.path, image: image, memo: memo, date: date, tag: TagModel(tagLabel: tagText, tagImage: tagImage))
            do {
                try newDocumentRef.setData(from: phothData)
                print("Document added successfully.")
            } catch let error {
                print("Error adding document: \(error)")
            }
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
}
