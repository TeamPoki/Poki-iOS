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
    var userData: User?
    var poseData:[ImageData] = []
    
    var newPhotoDocumentID: String? {
        guard let id = self.photoList.first?.id else { return String(1000) }
        guard let index = Int(id) else { return String(1000) }
        return String(index + 1)
    }
    
    /// 파이어베이스에서 swift의 구조체나 클래스를 사용할 수 있도록 지원하기 때문에 [String: Any] 타입의 데이터를 Photo 로 변환하는 과정을 생략할 수 있기 때문에 해당 메서드를 사용하지 않을 수 있습니다.
//    private func createPhotoFromData(_ data: [String: Any]) -> Photo? {
//        guard
//            let documentReference = data["documentReference"] as? String,
//            let image = data["image"] as? String,
//            let memo = data["memo"] as? String,
//            let date = data["date"] as? String,
//            let tagData = data["tag"] as? [String: Any],
//            let tagLabel = tagData["tagLabel"] as? String,
//            let tagImage = tagData["tagImage"] as? String
//        else {
//            // 필수 필드가 누락되었거나 형식이 맞지 않는 경우 nil 반환
//            return nil
//        }
//
//        let tag = TagModel(tagLabel: tagLabel, tagImage: tagImage)
//        return Photo(documentReference: documentReference, image: image, memo: memo, date: date, tag: tag)
//    }

    func fetchPhotoFromFirestore(completion: @escaping (Error?) -> Void) {
        guard let userEmail = authManager.currentUserEmail else { return }
        let docRef = db.collection("users/\(userEmail)/Photo")
        docRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("ERROR: 파이어 스토어에서 Photo 컬렉션의 문서를 가져오지 못했습니다! \(error.localizedDescription)")
                completion(error)
            }
            guard let documents = snapshot?.documents else { return }
            self.photoList = documents.compactMap { document -> Photo? in
                let photoData = try? document.data(as: Photo.self)
                return photoData
            }
            self.photoList.reverse()
            completion(nil)
        }
    }
    
    /// setData 메서드는 문서가 없는 경우 새로 만들고, 있는 경우 덮어쓰기 때문에 하나의 메서드로 생성과 업데이트를 처리할 수 있습니다.
    /// 일부 문서만 업데이트 하는 경우 updateData() 메서드가 효율적이지만 현재 로직 상으로는 전체를 업데이트하기 때문에 해당 메서드를 호출해서 생성과 업데이트를 처리하는건 어떨까요?
    func createPhotoDocument(photo: Photo, completion: @escaping (Error?) -> Void) {
        do {
            guard let userEmail = authManager.currentUserEmail else { return }
            let docRef = db.collection("users/\(userEmail)/Photo").document(photo.id)
            try docRef.setData(from: photo)
            print("Document added successfully.")
            completion(nil)
        } catch let error {
            print("Error adding document: \(error)")
            completion(error)
        }
    }
    
    func deletePhotoDocument(id: String) {
        guard let userEmail = authManager.currentUserEmail else { return }
        let docRef = db.collection("users/\(userEmail)/Photo").document(id)
        docRef.delete { error in
            if let error = error {
                print("ERROR: Photo 컬렉션의 문서 삭제를 실패했습니다! \(error.localizedDescription)")
            }
        }
    }
    
//    func photoUpdate(documentPath: String, image: String, date: String, memo: String, tagText: String, tagImage: String) {
//        guard let userUID = authManager.currentUserUID else { return }
//        let documentComponents = documentPath.components(separatedBy: "/")
//        _ = documentComponents[0]
//        let documentID = documentComponents[3]
//        let docRef = db.collection("users/\(userUID)/Photo").document(documentID)
//        let data: [String : Any] = [
//            "image" : image,
//            "date" : date,
//            "memo" : memo,
//            "tag" : [
//                "tagLabel": tagText,
//                "tagImage": tagImage
//            ]
//        ]
//        docRef.updateData(data) { error in
//            if let error = error {
//                print("Error updating document: \(error)")
//            }
//            print("Document updated successfully.")
//        }
//    }
    
    
//    func createPhotoData(photoURL: String, date: String, memo: String, tagURL: String, tagText: String, completion: (DocumentReference, Photo) -> Void) {
//        guard let userUID = authManager.currentUserUID else { return }
//        let newDocumentRef = db.collection("users/\(userUID)/Photo").document()
//        let newPhoto = Photo(documentReference: newDocumentRef.path, image: photoURL, memo: memo, date: date, tag: TagModel(tagLabel: tagText, tagImage: tagURL))
//        self.createPhotoDocument(new: newDocumentRef, photo: newPhoto)
//        completion(newDocumentRef, newPhoto)
//    }
//
//    func createPhotoDocument(new reference: DocumentReference, photo: Photo) {
//        do {
//            try reference.setData(from: photo)
//            print("Document added successfully.")
//        } catch let error {
//            print("Error adding document: \(error)")
//        }
//    }
    
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
//    func photoRealTimebinding(collectionView : UICollectionView) {
//        guard let userUID = authManager.currentUserUID else { return }
//        let docRef = db.collection("users/\(userUID)/Photo")
//        docRef.addSnapshotListener { (snapshot, error) in
//            guard let documents = snapshot?.documents else {
//                print("Error Firestore fetching document: \(String(describing: error))")
//                return
//            }
//            self.photoList = documents.compactMap { doc -> Photo? in
//                // Firestore 스냅샷에서 필요한 데이터를 가져와 Photo 모델에 직접 할당
//                let data = doc.data()
//                if let photo = self.createPhotoFromData(data) {
//                    return photo
//                }
//                return nil
//            }
//            collectionView.reloadData()
//            guard let updateMainVC = collectionView.delegate as? MainPageVC else { return }
//            updateMainVC.updateEmptyPhotoListViewVisibility()
//        }
//    }
    
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
    
    
    // MARK: - saveDeletionReason
    
    func saveDeletionReason(reason: String, completion: @escaping (Error?) -> Void) {
        let collectionRef = db.collection("DeletionReasons")
        let data = ["content": reason]
        collectionRef.addDocument(data: data) { error in
            completion(error)
        }
    }
    
    // MARK: - UserData
//    private func createUserFromData(_ data: [String: Any]) -> User? {
//        guard
//            let documentReference = data["documentReference"] as? String,
//            let userName = data["userName"] as? String,
//            let userImage = data["userImage"] as? String
//        else {
//            return nil
//        }
//
//        return User(documentReference: documentReference, userName: userName, userImage: userImage)
//    }
    
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
    
//    func userCreate(name: String, image: String) {
//        guard let userUID = authManager.currentUserUID else { return }
//        let newDocumentRef = db.collection("users/\(userUID)/User").document()
//        let userData = User(documentReference: newDocumentRef.path, userName: name, userImage: image)
//        do {
//            try newDocumentRef.setData(from: userData)
//            print("Document added successfully.")
//        } catch let error {
//            print("Error adding document: \(error)")
//        }
//    }
    
    //실시간반영
//    func userRealTimebinding() {
//        guard let userUID = authManager.currentUserUID else { return }
//        let docRef = db.collection("users/\(userUID)/User")
//        docRef.addSnapshotListener { (snapshot, error) in
//            guard let documents = snapshot?.documents else {
//                print("Error Firestore fetching document: \(String(describing: error))")
//                return
//            }
//            self.userData = documents.compactMap { doc -> User? in
//                // Firestore 스냅샷에서 필요한 데이터를 가져와 Photo 모델에 직접 할당
//                let data = doc.data()
//                if let userData = self.createUserFromData(data) {
//                    return userData
//                }
//                return nil
//            }
//        }
//    }
    
    func fetchUserDocumentFromFirestore() {
        guard let userEmail = authManager.currentUserEmail else { return }
        let docRef = db.collection("users").document(userEmail)
        
        docRef.getDocument { (snapshot, error) in
            if let error = error {
                print("ERROR: 파이어 스토어에서 유저 문서를 가져오지 못했습니다! \(error.localizedDescription)")
                return
            }
            let userData = try? snapshot?.data(as: User.self)
            self.userData = userData
        }
    }
    
    func createUserDocument(email: String, user: User) {
        do {
            let docRef = db.collection("users").document(email)
            try docRef.setData(from: user)
            print("SUCCESS: 유저 문서 생성 성공!!")
        } catch let error {
            print("ERROR: 유저 문서 생성 실패 ㅠㅠ!!! \(error)")
        }
    }
    
    func updateUserDocument(user: User) {
        guard let userEmail = authManager.currentUserEmail else { return }
        let docRef = db.collection("users").document(userEmail)
        do {
            try docRef.setData(from: user)
            print("SUCCESS: 유저 문서 업데이트 성공!!")
        } catch let error {
            print("ERROR: 유저 문서 업데이트 실패 ㅠㅠ!!! \(error)")
        }
    }
    
//    func userProfileUpdate(documentPath: String, name: String, image: String, vc: UIViewController) {
//        guard let userUID = authManager.currentUserUID else { return }
//        let documentComponents = documentPath.components(separatedBy: "/")
//        _ = documentComponents[0]
//        let documentID = documentComponents[3]
//        let docRef = db.collection("users/\(userUID)/User").document(documentID)
//        let data: [String : Any] = [
//            "userImage" : image,
//            "userName" : name
//        ]
//        docRef.updateData(data) { error in
//            if let error = error {
//                print("Error updating document: \(error)")
//            }
//            print("Document updated successfully.")
//            vc.navigationController?.popViewController(animated: true)
//        }
//    }
    
    func createRecommendPoseDocument(imageData: ImageData) {
        guard let userEmail = authManager.currentUserEmail else { return }
        let docRef = db.collection("users/\(userEmail)/Image").document()
        do {
            try docRef.setData(from: imageData)
            print("SUCCESS: 추천 포즈 문서 생성 성공 !!")
        } catch let error {
            print("ERROR: 추천 포즈 문서 생성 실패 ㅠㅠ!!! \(error)")
        }
    }
    
    
//    func imageCreate(imageUrl: String, category: String)  {
//        guard let userUID = authManager.currentUserUID else { return  }
//        let newDocumentRef = db.collection("users/\(userUID)/Image").document()
//        let imageData = ImageData(imageUrl: imageUrl, category: category, isSelected: false)
//        do {
//            try newDocumentRef.setData(from: imageData)
//            print("Document added successfully.")
//        } catch let error {
//            print("Error adding document: \(error)")
//        }
//    }
    
    
    func poseImageUpdate(imageUrl: String, isSelected: Bool) {
        guard let userEmail = authManager.currentUserEmail else { return }
        let imageCollectionRef = db.collection("users/\(userEmail)/Image")
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
        poseRealTimebinding { _ in}
    }
    
    
    
    
//    func poseRealTimebinding() {
//        guard let userUID = authManager.currentUserUID else { return }
//        let docRef = db.collection("users/\(userUID)/Image")
//        docRef.addSnapshotListener { (snapshot, error) in
//            guard let documents = snapshot?.documents else {
//                print("Error Firestore fetching document: \(String(describing: error))")
//                return
//            }
//            self.poseData = documents.compactMap { doc -> ImageData? in
//                // Firestore 스냅샷에서 필요한 데이터를 가져와 Photo 모델에 직접 할당
//                let data = doc.data()
//                if let poseData = self.createImageFromData(data) {
//                    return poseData
//                }
//                return nil
//            }
//        }
//    }
    
    func poseRealTimebinding(completion: @escaping ([ImageData]) -> Void) {
        guard let userEmail = authManager.currentUserEmail else { return }
        let docRef = db.collection("users/\(userEmail)/Image")
        docRef.addSnapshotListener { (snapshot, error) in
            guard let documents = snapshot?.documents else {
                print("Error Firestore fetching document: \(String(describing: error))")
                return
            }
            self.poseData = documents.compactMap { doc -> ImageData? in
                // Firestore 스냅샷에서 필요한 데이터를 가져와 ImageData 모델에 직접 할당
                let data = doc.data()
                if let poseData = self.createImageFromData(data) {
                    return poseData
                }
                return nil
            }
            
            // 업데이트된 데이터를 completion 핸들러를 통해 전달
            completion(self.poseData)
        }
    }

    
   
    
    
}

extension FirestoreManager {
    func makePoseData() {
        // MARK: - alone
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/alonePose/alone-pose1.jpg",
                                             category: "alone", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/alonePose/alone-pose2.jpeg",
                                             category: "alone", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/alonePose/alone-pose3.jpeg",
                                             category: "alone", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/alonePose/alone-pose4.jpeg",
                                             category: "alone", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/alonePose/alone-pose5.jpeg",
                                             category: "alone", isSelected: false))
        
        // MARK: - two
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose1.jpeg",
                                             category: "twoPose", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose2.jpeg",
                                             category: "twoPose", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose3.jpeg",
                                             category: "twoPose", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose4.jpeg",
                                             category: "twoPose", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose5.jpeg",
                                             category: "twoPose", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose6.jpeg",
                                             category: "twoPose", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/twoPeoplePose/two-pose7.jpeg",
                                             category: "twoPose", isSelected: false))
        
        // MARK: - many
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose1.jpeg",
                                             category: "manyPose", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose2.jpeg",
                                             category: "manyPose", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose3.jpeg",
                                             category: "manyPose", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose4.jpeg",
                                             category: "manyPose", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose5.jpeg",
                                             category: "manyPose", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose6.jpeg",
                                             category: "manyPose", isSelected: false))
        createRecommendPoseDocument(imageData: ImageData(imageUrl: "gs://poki-ios-87d7e.appspot.com/manyPeoplePose/many-pose7.jpeg",
                                             category: "manyPose", isSelected: false))
    }
}



//회원탈퇴 전용 메서드
extension FirestoreManager {
    //회원탈퇴 포토 데이터 삭제
    func deleteAllPhotoData() {
        guard let userUID = authManager.currentUserUID else { return }
        let collectionRef = db.collection("users/\(userUID)/Photo")
        
        collectionRef.getDocuments { (querySnapshot, error) in
              if let error = error {
                  print("Error querying documents in collection: \(error)")
                  return
              }

              for document in querySnapshot!.documents {
                  document.reference.delete { error in
                      if let error = error {
                          print("Error deleting document: \(error)")
                      } else {
                          print("Document deleted successfully.")
                      }
                  }
              }

              collectionRef.getDocuments { (querySnapshot, error) in
                  if let error = error {
                      print("Error querying collection: \(error)")
                      return
                  }

                  for document in querySnapshot!.documents {
                      document.reference.delete { error in
                          if let error = error {
                              print("Error deleting collection: \(error)")
                          } else {
                              print("Collection deleted successfully.")
                          }
                      }
                  }
              }
          }
        
    }
    
    //회원탈퇴 포즈 데이터 삭제
    func deleteAllPoseData() {
        guard let userUID = authManager.currentUserUID else { return }
        let collectionRef = db.collection("users/\(userUID)/Image")
        
        collectionRef.getDocuments { (querySnapshot, error) in
              if let error = error {
                  print("Error querying documents in collection: \(error)")
                  return
              }

              for document in querySnapshot!.documents {
                  document.reference.delete { error in
                      if let error = error {
                          print("Error deleting document: \(error)")
                      } else {
                          print("Document deleted successfully.")
                      }
                  }
              }

              collectionRef.getDocuments { (querySnapshot, error) in
                  if let error = error {
                      print("Error querying collection: \(error)")
                      return
                  }

                  for document in querySnapshot!.documents {
                      document.reference.delete { error in
                          if let error = error {
                              print("Error deleting collection: \(error)")
                          } else {
                              print("Collection deleted successfully.")
                          }
                      }
                  }
              }
          }
        
    }
    
    
    //유저데이터 삭제
    func deleteAllUserData() {
        guard let userUID = authManager.currentUserUID else { return }
        let collectionRef = db.collection("users/\(userUID)/User")
        
        collectionRef.getDocuments { (querySnapshot, error) in
              if let error = error {
                  print("Error querying documents in collection: \(error)")
                  return
              }

              for document in querySnapshot!.documents {
                  document.reference.delete { error in
                      if let error = error {
                          print("Error deleting document: \(error)")
                      } else {
                          print("Document deleted successfully.")
                      }
                  }
              }

              collectionRef.getDocuments { (querySnapshot, error) in
                  if let error = error {
                      print("Error querying collection: \(error)")
                      return
                  }

                  for document in querySnapshot!.documents {
                      document.reference.delete { error in
                          if let error = error {
                              print("Error deleting collection: \(error)")
                          } else {
                              print("Collection deleted successfully.")
                          }
                      }
                  }
              }
          }
    }
    



    
    
    //상위 문서 삭제
    func deleteUserDocument() {
        guard let userUID = authManager.currentUserUID else { return }
        
        // 사용자의 userUID에 해당하는 문서를 삭제
        let userDocumentRef = db.collection("users").document(userUID)
        
        userDocumentRef.delete { error in
            if let error = error {
                print("Error deleting user document: \(error)")
            } else {
                print("User document with userUID \(userUID) deleted successfully.")
            }
        }
    }
}
