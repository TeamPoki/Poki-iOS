//
//  UserDataManager.swift
//  Poki-iOS
//
//  Created by 천광조 on 10/27/23.
//


import UIKit


class UserDataManager {
    
   static let shared = UserDataManager()
    
    private init() {}
    
    static var userData = User(userName: "", userImage: Data(), likedPose: likePose(firstPose: [], secondPose: [], thirdPose: []))
   
//    var data: User {
//        get {
//            if let data = UserDefaults.standard.data(forKey: "userData"),
//               let userData = try? JSONDecoder().decode(User.self, from: data) {
//                return userData
//            } else {
//                return User(userName: "", userImage: Data(), likedPose: likePose(firstPose: [], secondPose: [], thirdPose: []))
//            }
//        }
//        set {
//            if let encodedData = try? JSONEncoder().encode(newValue) {
//                UserDefaults.standard.set(encodedData, forKey: "userData")
//            }
//        }
//    }
    
    
}
