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

final class FirestoreManager {
    static let shared = FirestoreManager()
    private init() {}
    
    private let authManager = AuthManager.shared
    private let db = Firestore.firestore()
    private lazy var collectionReference = db.collection("Photo")
    var photoList: [Photo] = []
    var userData:[User] = []
    var poseData:[ImageData] = []
    
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
    
    func photoCreate(image: String, date: String, memo: String, tagText: String, tagImage: String) {
        guard let userUID = authManager.currentUserUID else { return }
        let newDocumentRef = db.collection("users/\(userUID)/Photo").document()
        let phothData = Photo(documentReference: newDocumentRef.path, image: image, memo: memo, date: date, tag: TagModel(tagLabel: tagText, tagImage: tagImage))
        do {
            try newDocumentRef.setData(from: phothData)
            print("Document added successfully.")
        } catch let error {
            print("Error adding document: \(error)")
        }
    }
    
    func photoUpdate(documentPath: String, image: String, date: String, memo: String, tagText: String, tagImage: String) {
        guard let userUID = authManager.currentUserUID else { return }
        let documentComponents = documentPath.components(separatedBy: "/")
        _ = documentComponents[0]
        let documentID = documentComponents[3]
        let docRef = db.collection("users/\(userUID)/Photo").document(documentID)
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
            }
            print("Document updated successfully.")
        }
    }
    
    func photoDelete(documentPath: String) {
        guard let userUID = authManager.currentUserUID else { return }
        let documentComponents = documentPath.components(separatedBy: "/")
        _ = documentComponents[0]
        let documentID = documentComponents[3]
        let docRef = db.collection("users/\(userUID)/Photo").document(documentID)
        docRef.delete { error in
            if let error = error {
                print("Error updating document: \(error)")
            }
            print("Document updated successfully.")
        }
    }
    
    //실시간반영
    func photoRealTimebinding(collectionView : UICollectionView) {
        guard let userUID = authManager.currentUserUID else { return }
        let docRef = db.collection("users/\(userUID)/Photo")
        docRef.addSnapshotListener { (snapshot, error) in
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
                }
                return nil
            }
            collectionView.reloadData()
        }
    }
    
    // MARK: - Notice
    
    func loadNotices(completion: @escaping ([NoticeList]) -> Void) {
        db.collection("Notices").order(by: "date", descending: true).getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching Photos: \(error.localizedDescription)")
                completion([])
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion([])
                return
            }
            let notices = documents.compactMap { document -> NoticeList? in
                let data = document.data()
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try JSONSerialization.data(withJSONObject: data)
                    let notice = try decoder.decode(NoticeList.self, from: jsonData)
                    return notice
                } catch {
                    print("Error decoding Photos: \(error.localizedDescription)")
                    return nil
                }
            }
            completion(notices)
            print(notices)
        }
    }
    
    //회원탈퇴 포토 데이터 삭제
    func deleteAllPhotoData() {
        guard let userUID = authManager.currentUserUID else { return }
        let photoCollectionRef = db.collection("users/\(userUID)/Photo")
        
        // 1. 해당 사용자의 모든 사진 데이터 조회
        photoCollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying user's photo data: \(error)")
                return
            }
            
            // 2. 조회된 모든 문서를 삭제
            for document in querySnapshot!.documents {
                let documentID = document.documentID
                let documentRef = photoCollectionRef.document(documentID)
                
                documentRef.delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    }
                }
            }
        }
    }

    
    // MARK: - saveDeletionReason
    
    func saveDeletionReason(reason: String, completion: @escaping (Error?) -> Void) {
        let collectionRef = db.collection("DeletionReasons")
        let data = ["content": reason]
        collectionRef.addDocument(data: data) { error in
            completion(error)
        }
    }
    
    // MARK: - UserData
    private func createUserFromData(_ data: [String: Any]) -> User? {
        guard
            let documentReference = data["documentReference"] as? String,
            let userName = data["userName"] as? String,
            let userImage = data["userImage"] as? String
        else {
            return nil
        }

        return User(documentReference: documentReference, userName: userName, userImage: userImage)
    }

    private func createImageFromData(_ data: [String: Any]) -> ImageData? {
        guard
            let category = data["category"] as? String,
            let imageUrl = data["imageUrl"] as? String,
            let isSelected = data["isSelected"] as? Bool
        else {
            return nil
        }
        return ImageData(imageUrl: imageUrl, category: category, isSelected: isSelected)
    }
    
    func userCreate(name: String, image: String) {
        guard let userUID = authManager.currentUserUID else { return }
        let newDocumentRef = db.collection("users/\(userUID)/User").document()
        let userData = User(documentReference: newDocumentRef.path, userName: name, userImage: image)
        do {
            try newDocumentRef.setData(from: userData)
            print("Document added successfully.")
        } catch let error {
            print("Error adding document: \(error)")
        }
    }
    
    
    func imageCreate(imageUrl: String, category: String)  {
        guard let userUID = authManager.currentUserUID else { return  }
        let newDocumentRef = db.collection("users/\(userUID)/Image").document()
        let imageData = ImageData(imageUrl: imageUrl, category: category, isSelected: false)
        do {
            try newDocumentRef.setData(from: imageData)
            print("Document added successfully.")
        } catch let error {
            print("Error adding document: \(error)")
        }
    }
    
    func userProfileUpdate(documentPath: String, name: String, image: String) {
        guard let userUID = authManager.currentUserUID else { return }
        let documentComponents = documentPath.components(separatedBy: "/")
        _ = documentComponents[0]
        let documentID = documentComponents[3]
        let docRef = db.collection("users/\(userUID)/User").document(documentID)
        let data: [String : Any] = [
            "userImage" : image,
            "userName" : name
        ]
        docRef.updateData(data) { error in
            if let error = error {
                print("Error updating document: \(error)")
            }
            print("Document updated successfully.")
        }
    }
    
    
    func poseImageUpdate(imageUrl: String, isSelected: Bool) {
        guard let userUID = authManager.currentUserUID else { return }

        let imageCollectionRef = db.collection("users/\(userUID)/Image")

        imageCollectionRef.whereField("imageUrl", isEqualTo: imageUrl).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
        
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No matching documents found.")
                return
            }
            
            let documentToUpdate = documents[0]
            
            let data: [String: Any] = ["isSelected": isSelected]
            
            documentToUpdate.reference.updateData(data) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document updated successfully.")
                }
            }
        }
    }

    
    //실시간반영
    func userRealTimebinding() {
        guard let userUID = authManager.currentUserUID else { return }
        let docRef = db.collection("users/\(userUID)/User")
        docRef.addSnapshotListener { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error Firestore fetching document: \(String(describing: error))")
                return
            }
            self.userData = documents.compactMap { doc -> User? in
                // Firestore 스냅샷에서 필요한 데이터를 가져와 Photo 모델에 직접 할당
                let data = doc.data()
                if let userData = self.createUserFromData(data) {
                    print("photo data load 완료")
                    return userData
                }
                return nil
            }
        }
    }
    
    func poseRealTimebinding() {
        guard let userUID = authManager.currentUserUID else { return }
        let docRef = db.collection("users/\(userUID)/Image")
        docRef.addSnapshotListener { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error Firestore fetching document: \(String(describing: error))")
                return
            }
            self.poseData = documents.compactMap { doc -> ImageData? in
                // Firestore 스냅샷에서 필요한 데이터를 가져와 Photo 모델에 직접 할당
                let data = doc.data()
                if let poseData = self.createImageFromData(data) {
                    print("photo data load 완료")
                    return poseData
                }
                return nil
            }
        }
    }
    
    //회원탈퇴 포즈 데이터 삭제
    func deleteAllPoseData() {
        guard let userUID = authManager.currentUserUID else { return }
        let poseCollectionRef = db.collection("users/\(userUID)/Image")
        let poseCollectionRef1 = db.collection("users/\(userUID)/User")
        // 1. 해당 사용자의 모든 사진 데이터 조회
        poseCollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying user's photo data: \(error)")
                return
            }
            
            // 2. 조회된 모든 문서를 삭제
            for document in querySnapshot!.documents {
                let documentID = document.documentID
                let documentRef = poseCollectionRef.document(documentID)
                
                documentRef.delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    }
                }
            }
        }
        poseCollectionRef1.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error querying user's photo data: \(error)")
                return
            }
            
            // 2. 조회된 모든 문서를 삭제
            for document in querySnapshot!.documents {
                let documentID = document.documentID
                let documentRef = poseCollectionRef.document(documentID)
                
                documentRef.delete { error in
                    if let error = error {
                        print("Error deleting document: \(error)")
                    }
                }
            }
        }
        
    }
    
}


extension FirestoreManager {
    func makePoseData() {
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/alonePose/alone-pose1.jpg", category: "alone")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/alonePose/alone-pose2.jpeg", category: "alone")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/alonePose/alone-pose3.jpeg", category: "alone")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/alonePose/alone-pose4.jpeg", category: "alone")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/alonePose/alone-pose5.jpeg", category: "alone")
        
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose1.jpeg", category: "twoPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose2.jpeg", category: "twoPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose3.jpeg", category: "twoPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose4.jpeg", category: "twoPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose5.jpeg", category: "twoPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose6.jpeg", category: "twoPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose7.jpeg", category: "twoPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose8.jpeg", category: "twoPose")
        
        
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose1.jpeg", category: "manyPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose2.jpeg", category: "manyPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose3.jpeg", category: "manyPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose4.jpeg", category: "manyPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose5.jpeg", category: "manyPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose6.jpeg", category: "manyPose")
        imageCreate(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose7.jpeg", category: "manyPose")
    }
}
