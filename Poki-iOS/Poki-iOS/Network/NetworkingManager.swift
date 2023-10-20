//
//  NetworkingManager.swift
//  Poki-iOS
//
//  Created by Insu on 10/14/23.
//

import UIKit

class NetworkingManager {
    static let shared = NetworkingManager()
    private var photoList: [Photo] = []
    private init() {}
    
    func create(_ photo: Photo) {
        
    }
    
    func read(_ photos: [Photo]) -> [Photo] {
        return photos
    }
    
    func update(_ photo: Photo) {
        
    }
    
    func delete(_ photo: Photo) {
        
    }
}
