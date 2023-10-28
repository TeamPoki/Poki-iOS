//
//  AuthManager.swift
//  Poki-iOS
//
//  Created by playhong on 2023/10/27.
//

import UIKit
import FirebaseAuth

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
}
