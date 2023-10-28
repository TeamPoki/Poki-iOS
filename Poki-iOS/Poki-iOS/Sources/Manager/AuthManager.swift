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
    
    func loginUser(withEmail email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
     }
    
    func signUpUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func currentUserID() -> String? {
        if let user = Auth.auth().currentUser {
            return user.email
        }
        return nil
    }
    
    func userDelete() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    print("계정 삭제 실패 \(error.localizedDescription)")
                } else {
                    print("계정 삭제 성공")
                }
            }
        }
    }
}
