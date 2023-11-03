//
//  AuthManager.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/27.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    
    var currentUserUID: String? {
        let uid = Auth.auth().currentUser?.uid
        return uid
    }
    
    var currentUserEmail: String? {
        let email = Auth.auth().currentUser?.email
        return email
    }
    
    func loginUser(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func signUpUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func logoutUser() {
        do {
            try Auth.auth().signOut()
            print("로그아웃 성공!")
        } catch {
            print("로그아웃 실패: \(error.localizedDescription)")
        }
    }
    
    func userDelete() {
        let user = Auth.auth().currentUser
        user?.delete { error in
            if let error = error {
                print("계정 삭제 실패 \(error.localizedDescription)")
                return
            }
            print("계정 삭제 성공")
        }
    }
    
    func sendPasswordReset(with email: String?) {
        guard let email = email else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("비밀번호 초기화 메일 보내기 실패!!!")
            }
            // 이메일이 존재하는지 검증하는 로직이 필요할까요..?
            print("비밀번호 초기화 메일 보내기 성공!")
        }
    }
}
