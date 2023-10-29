//
//  UserDataManager.swift
//  Poki-iOS
//
//  Created by 천광조 on 10/27/23.
//


import UIKit


final class UserDataManager {
    
    static var userData = User(userName: "", userImage: Data(), likedPose: likePose(firstPose: [], secondPose: [], thirdPose: []))
    
    static var savedEmail: String? {
        UserDefaults.standard.string(forKey: "savedEmail")
    }
   
//유저디폴트 값 불러오기
    static func loadUserData() {
        if let data = UserDefaults.standard.data(forKey: "userData"),
           let userData = try? JSONDecoder().decode(User.self, from: data) {
            UserDataManager.userData = userData
        }
    }
    
    //유저디폴트 값 저장
    static func saveUserData() {
        do {
            let userData = try JSONEncoder().encode(UserDataManager.userData)
            UserDefaults.standard.set(userData, forKey: "userData")
        } catch {
            print("데이터를 저장하는 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
//유저디폴트 삭제 코드
    static func removeUserData() {
        UserDataManager.userData.likedPose.firstPose.removeAll()
        UserDataManager.userData.likedPose.secondPose.removeAll()
        do {
              let userData = try JSONEncoder().encode(UserDataManager.userData)
              UserDefaults.standard.set(userData, forKey: "userData")
          } catch {
              print("데이터를 저장하는 중 오류 발생: \(error.localizedDescription)")
          }
    }
    
    // MARK: - 이메일 저장
    static func saveUserEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: "savedEmail")
    }
}
