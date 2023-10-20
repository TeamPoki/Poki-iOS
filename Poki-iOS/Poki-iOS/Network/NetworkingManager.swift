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
}
