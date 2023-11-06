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
    
    func fetchUserDocumentFromFirestore(completion: @escaping (Error?) -> Void) {
        guard let userEmail = authManager.currentUserEmail else { return }
        let docRef = db.collection("users").document(userEmail)
        
        docRef.getDocument { (snapshot, error) in
            if let error = error {
                print("ERROR: 파이어 스토어에서 유저 문서를 가져오지 못했습니다! \(error.localizedDescription)")
                completion(error)
            }
            let userData = try? snapshot?.data(as: User.self)
            self.userData = userData
            completion(nil)
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
    
    func updateUserDocument(user: User, completion: (Error?) -> Void) {
        guard let userEmail = authManager.currentUserEmail else { return }
        let docRef = db.collection("users").document(userEmail)
        do {
            try docRef.setData(from: user)
            print("SUCCESS: 유저 문서 업데이트 성공!!")
            completion(nil)
        } catch let error {
            print("ERROR: 유저 문서 업데이트 실패 ㅠㅠ!!! \(error)")
            completion(error)
        }
    }
    
    func fetchRecommendPoseDocumentFromFirestore(completion: @escaping (Error?) -> Void) {
        guard let userEmail = authManager.currentUserEmail else { return }
        let docRef = db.collection("users/\(userEmail)/Image")
        docRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("ERROR: 파이어 스토어에서 Photo 컬렉션의 문서를 가져오지 못했습니다! \(error.localizedDescription)")
                completion(error)
            }
            guard let documents = snapshot?.documents else { return }
            self.poseData = documents.compactMap { document -> ImageData? in
                let poseData = try? document.data(as: ImageData.self)
                return poseData
            }
            completion(nil)
        }
    }
    
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
    
    /// 이것은 아직 리팩토링을 못했습니다. isSelected 필드만 변경하기 때문에 updateData 메서드를 호출해서 처리하는게 효율적인 것 같아 아직 고민중입니다. 의견 주십쇼!!
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
        guard let userEmail = authManager.currentUserEmail else { return }
        let collectionRef = db.collection("users/\(userEmail)/Photo")
        
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
        guard let userEmail = authManager.currentUserEmail else { return }
        let collectionRef = db.collection("users/\(userEmail)/Image")
        
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
        guard let userEmail = authManager.currentUserEmail else { return }
        // 사용자의 userUID에 해당하는 문서를 삭제
        let userDocumentRef = db.collection("users").document(userEmail)
        
        userDocumentRef.delete { error in
            if let error = error {
                print("Error deleting user document: \(error)")
            } else {
                print("User document with userUID \(userEmail) deleted successfully.")
            }
        }
    }
}
