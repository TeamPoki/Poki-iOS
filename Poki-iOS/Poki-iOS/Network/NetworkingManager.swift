//
//  NetworkingManager.swift
//  Poki-iOS
//
//  Created by Insu on 10/14/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class NetworkingManager {
    static let shared = NetworkingManager()
    let db = Firestore.firestore()
    private var photoList: [Photo] = []
    private init() {}
    
    func create(_ photo: Photo) {
        photoList.append(photo)
    }
    
    func read() -> [Photo] {
        return photoList
    }
    
    func update(_ photo: Photo, index: Int) {
        photoList[index] = photo
    }
    
    func delete(index: Int?) {
        guard let index = index else { return }
        photoList.remove(at: index)
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
}
